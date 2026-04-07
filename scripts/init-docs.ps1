#Requires -Version 5.1
<#
.SYNOPSIS
    Scaffold the standard documentation structure into a new repo.
.DESCRIPTION
    PowerShell equivalent of init-docs.sh for Windows.
    Run from the root of your target repository.
.PARAMETER PlatformRepo
    Override the platform repo URL (default from $env:DOCS_PLATFORM_REPO or GitHub).
.PARAMETER Ref
    Override the branch/tag to use (default from $env:DOCS_PLATFORM_REF or "main").
#>
[CmdletBinding()]
param(
    [string]$PlatformRepo = ($env:DOCS_PLATFORM_REPO, 'https://github.com/yourorg/docs-platform' | Where-Object { $_ } | Select-Object -First 1),
    [string]$Ref          = ($env:DOCS_PLATFORM_REF, 'main' | Where-Object { $_ } | Select-Object -First 1)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ── Colours ──────────────────────────────────────────────────────────────────
function Write-Colour {
    param([string]$Text, [ConsoleColor]$Colour)
    Write-Host $Text -ForegroundColor $Colour -NoNewline
}

Write-Host 'docs-platform init' -ForegroundColor Cyan
Write-Host "Platform repo : $PlatformRepo @ $Ref"
Write-Host "Target repo   : $(Get-Location)"
Write-Host ''

# ── Check we are inside a git repo ───────────────────────────────────────────
try {
    git rev-parse --git-dir 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw }
}
catch {
    Write-Error 'Error: not inside a git repository. Run this from your repo root.'
    exit 1
}

# ── Check docs/ does not already exist ───────────────────────────────────────
if (Test-Path -Path './docs' -PathType Container) {
    Write-Host 'Warning: docs/ already exists.' -ForegroundColor Yellow
    Write-Host 'Use sync-docs.ps1 (or sync-docs.sh) to update templates in an existing repo.'
    Write-Host 'To force a fresh scaffold anyway, delete docs/ first.'
    exit 1
}

# ── Clone platform repo ─────────────────────────────────────────────────────
$TmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "docs-platform-$([guid]::NewGuid().ToString('N'))"
try {
    Write-Host 'Cloning docs-platform...'
    git clone --quiet --depth 1 --branch $Ref $PlatformRepo $TmpDir
    if ($LASTEXITCODE -ne 0) {
        Write-Error 'Failed to clone docs-platform repository.'
        exit 1
    }

    # ── Copy root files (skip if already present) ────────────────────────────
    Write-Host 'Copying root files...'
    $rootFiles = @('AGENTS.md', 'CONTRIBUTING.md', 'CHANGELOG.md', '.markdownlint.json')
    foreach ($f in $rootFiles) {
        $source = Join-Path $TmpDir "scaffold/$f"
        $dest   = Join-Path '.' $f
        if (-not (Test-Path $dest)) {
            if (Test-Path $source) {
                Copy-Item -Path $source -Destination $dest
                Write-Host "  created  $f" -ForegroundColor Green
            }
            else {
                Write-Host "  skipped  $f (not in scaffold)" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "  skipped  $f (already exists)" -ForegroundColor Yellow
        }
    }

    # ── Copy docs/ tree ──────────────────────────────────────────────────────
    Write-Host 'Copying docs/ structure...'
    $scaffoldDocs = Join-Path $TmpDir 'scaffold/docs'
    if (Test-Path $scaffoldDocs -PathType Container) {
        # Copy every item, skipping files that already exist
        New-Item -Path './docs' -ItemType Directory -Force | Out-Null
        Get-ChildItem -Path $scaffoldDocs -Recurse | ForEach-Object {
            $relativePath = $_.FullName.Substring($scaffoldDocs.Length).TrimStart('\', '/')
            $targetPath   = Join-Path './docs' $relativePath
            if ($_.PSIsContainer) {
                if (-not (Test-Path $targetPath)) {
                    New-Item -Path $targetPath -ItemType Directory -Force | Out-Null
                }
            }
            else {
                if (-not (Test-Path $targetPath)) {
                    Copy-Item -Path $_.FullName -Destination $targetPath
                }
            }
        }
    }
    else {
        # Fallback: scaffold root IS the docs content (minus root files)
        New-Item -Path './docs' -ItemType Directory -Force | Out-Null
        $excludeFiles = $rootFiles + @('STYLE.md', 'README.md')
        Get-ChildItem -Path (Join-Path $TmpDir 'scaffold') -Exclude $excludeFiles | ForEach-Object {
            $targetPath = Join-Path './docs' $_.Name
            if (-not (Test-Path $targetPath)) {
                Copy-Item -Path $_.FullName -Destination $targetPath -Recurse
            }
        }
        # Copy scaffold README.md into docs/ as the index
        $scaffoldReadme = Join-Path $TmpDir 'scaffold/README.md'
        $docsReadme     = Join-Path './docs' 'README.md'
        if ((Test-Path $scaffoldReadme) -and -not (Test-Path $docsReadme)) {
            Copy-Item -Path $scaffoldReadme -Destination $docsReadme
        }
    }
    Write-Host '  created  docs/' -ForegroundColor Green

    # ── Store platform version reference ─────────────────────────────────────
    $commit  = (git -C $TmpDir rev-parse HEAD).Trim()
    $synced  = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    $versionContent = @"
# This file is managed by docs-platform. Do not edit manually.
repo=$PlatformRepo
ref=$Ref
commit=$commit
synced=$synced
"@
    New-Item -Path './docs' -ItemType Directory -Force | Out-Null
    Set-Content -Path './docs/.platform-version' -Value $versionContent -Encoding UTF8
    Write-Host '  created  docs/.platform-version' -ForegroundColor Green
}
finally {
    # ── Cleanup temp dir ─────────────────────────────────────────────────────
    if (Test-Path $TmpDir) {
        Remove-Item -Path $TmpDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# ── Done ─────────────────────────────────────────────────────────────────────
Write-Host ''
Write-Host 'Scaffold complete.' -ForegroundColor Green
Write-Host ''
Write-Host 'Next steps:'
Write-Host '  1. Edit AGENTS.md — add your project-specific code conventions'
Write-Host '  2. Edit docs/glossary.md — add your domain terms'
Write-Host "  3. Commit everything: git add -A ; git commit -m 'chore: init docs structure from docs-platform'"
Write-Host '  4. To sync template updates later: .\scripts\sync-docs.ps1'
