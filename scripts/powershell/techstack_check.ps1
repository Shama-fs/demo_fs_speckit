Write-Host "🔍 FutureStandard tech stack validation..."

# ===== Node.js =====
<#if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  Write-Error "❌ Node.js is required (Next.js stack)."
  Write-Host "👉 Install from https://nodejs.org/"
  exit 1
}

$nodeVersion = (node -v).TrimStart("v")
if ([version]$nodeVersion -lt [version]"18.0.0") {
  Write-Error "❌ Node.js >= 18 required. Found $nodeVersion."
  exit 1
}

# ===== npm / pnpm =====
if (-not (Get-Command npm -ErrorAction SilentlyContinue) -and
    -not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
  Write-Error "❌ npm or pnpm is required."
  exit 1
}#>

# ===== Python =====
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
  Write-Error "❌ Python is required (FastAPI stack)."
  exit 1
}

# ===== pip / uv =====
if (-not (Get-Command pip -ErrorAction SilentlyContinue) -and
    -not (Get-Command uv -ErrorAction SilentlyContinue)) {
  Write-Error "❌ pip or uv is required."
  exit 1
}

# ===== Git =====
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Error "❌ Git is required."
  exit 1
}

# ===== VS Code =====
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
  Write-Error "❌ VS Code not detected."
  Write-Host "👉 Install VS Code or enable 'code' command."
  exit 1
}

Write-Host "✅ FutureStandard tech stack validation passed."