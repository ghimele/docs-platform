#Requires -Version 5.1
<#
.SYNOPSIS
    Scaffold the standard documentation structure into a new repo.
.DESCRIPTION
    PowerShell equivalent of init-docs.sh for Windows.
    Run from the root of your target folder.
.PARAMETER PlatformPath
    Override the local docs-platform source path. When omitted, the script
    reuses the checkout it is running from if possible.
.PARAMETER PlatformRepo
    Override the platform repo URL (default from $env:DOCS_PLATFORM_REPO or GitHub).
.PARAMETER Ref
    Override the branch/tag to use (default from $env:DOCS_PLATFORM_REF or "main").
#>
[CmdletBinding()]
param(
    [string]$PlatformPath,
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

function Test-GitRepo {
    param([string]$Path)

    try {
        git -C $Path rev-parse --git-dir 2>$null | Out-Null
        return ($LASTEXITCODE -eq 0)
    }
    catch {
        return $false
    }
}

Write-Host 'docs-platform init' -ForegroundColor Cyan
Write-Host "Platform repo : $PlatformRepo @ $Ref"
Write-Host "Target repo   : $(Get-Location)"
Write-Host ''

# ── Check target folder ──────────────────────────────────────────────────────
if (Test-GitRepo (Get-Location).Path) {
    Write-Host 'Target folder type: git repository'
}
else {
    Write-Host 'Warning: target folder is not a git repository. Continuing anyway.' -ForegroundColor Yellow
}
Write-Host ''

# ── Check docs/ does not already exist ───────────────────────────────────────
if (Test-Path -Path './docs' -PathType Container) {
    Write-Host 'Warning: docs/ already exists.' -ForegroundColor Yellow
    Write-Host 'Use sync-docs.ps1 (or sync-docs.sh) to update templates in an existing repo.'
    Write-Host 'To force a fresh scaffold anyway, delete docs/ first.'
    exit 1
}

# ── Clone platform repo ─────────────────────────────────────────────────────
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$LocalPlatformRoot = Split-Path -Parent $ScriptDir
$platformSource = $null
$TmpDir = $null
try {
    if (-not $PlatformPath -and $env:DOCS_PLATFORM_PATH) {
        $PlatformPath = $env:DOCS_PLATFORM_PATH
    }

    if ($PlatformPath -and (Test-Path (Join-Path $PlatformPath 'scaffold') -PathType Container)) {
        $platformSource = $PlatformPath
        Write-Host "Using docs-platform source from PlatformPath: $platformSource"
    }
    elseif (Test-Path (Join-Path $LocalPlatformRoot 'scaffold') -PathType Container) {
        $platformSource = $LocalPlatformRoot
        Write-Host "Using local docs-platform checkout: $platformSource"
    }
    else {
        $TmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "docs-platform-$([guid]::NewGuid().ToString('N'))"
        Write-Host 'Cloning docs-platform...'
        git clone --quiet --depth 1 --branch $Ref $PlatformRepo $TmpDir
        if ($LASTEXITCODE -ne 0) {
            Write-Error 'Failed to clone docs-platform repository.'
            exit 1
        }

        $platformSource = $TmpDir
    }
    Write-Host ''

    # ── Copy root files (skip if already present) ────────────────────────────
    Write-Host 'Copying root files...'
    $rootFiles = @('AGENTS.md', 'CONTRIBUTING.md', 'CHANGELOG.md', '.markdownlint.json')
    foreach ($f in $rootFiles) {
        $source = Join-Path $platformSource "scaffold/$f"
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
    $scaffoldDocs = Join-Path $platformSource 'scaffold/docs'
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
        $excludeFiles = $rootFiles + @('README.md')
        Get-ChildItem -Path (Join-Path $platformSource 'scaffold') -Exclude $excludeFiles | ForEach-Object {
            $targetPath = Join-Path './docs' $_.Name
            if (-not (Test-Path $targetPath)) {
                Copy-Item -Path $_.FullName -Destination $targetPath -Recurse
            }
        }
        # Copy scaffold README.md into docs/ as the index
        $scaffoldReadme = Join-Path $platformSource 'scaffold/README.md'
        $docsReadme     = Join-Path './docs' 'README.md'
        if ((Test-Path $scaffoldReadme) -and -not (Test-Path $docsReadme)) {
            Copy-Item -Path $scaffoldReadme -Destination $docsReadme
        }
    }
    Write-Host '  created  docs/' -ForegroundColor Green

    # ── Copy agent prompt files ──────────────────────────────────────────────
    $agentSource = Join-Path $platformSource 'agent'
    if (Test-Path $agentSource -PathType Container) {
        Write-Host 'Copying agent prompts...'
        New-Item -Path './agent' -ItemType Directory -Force | Out-Null
        Get-ChildItem -Path $agentSource -Filter '*.prompt.md' | ForEach-Object {
            $targetPath = Join-Path './agent' $_.Name
            if (-not (Test-Path $targetPath)) {
                Copy-Item -Path $_.FullName -Destination $targetPath
                Write-Host "  created  agent/$($_.Name)" -ForegroundColor Green
            }
            else {
                Write-Host "  skipped  agent/$($_.Name) (already exists)" -ForegroundColor Yellow
            }
        }
    }

    # ── Store platform version reference ─────────────────────────────────────
    if (Test-GitRepo $platformSource) {
        $platformRepoValue = (git -C $platformSource config --get remote.origin.url).Trim()
        if (-not $platformRepoValue) {
            $platformRepoValue = $platformSource
        }

        $platformRefValue = (git -C $platformSource branch --show-current).Trim()
        if (-not $platformRefValue) {
            $platformRefValue = $Ref
        }

        $commit  = (git -C $platformSource rev-parse HEAD).Trim()
    }
    else {
        $platformRepoValue = if ($PlatformPath) { $PlatformPath } else { $PlatformRepo }
        $platformRefValue = $Ref
        $commit = 'unknown'
    }

    $synced  = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    $versionContent = @"
# This file is managed by docs-platform. Do not edit manually.
repo=$platformRepoValue
ref=$platformRefValue
commit=$commit
synced=$synced
"@
    New-Item -Path './docs' -ItemType Directory -Force | Out-Null
    Set-Content -Path './docs/.platform-version' -Value $versionContent -Encoding UTF8
    Write-Host '  created  docs/.platform-version' -ForegroundColor Green
}
finally {
    # ── Cleanup temp dir ─────────────────────────────────────────────────────
    if ($TmpDir -and (Test-Path $TmpDir)) {
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
Write-Host '  4. To sync template and prompt updates later: .\scripts\sync-docs.ps1'
