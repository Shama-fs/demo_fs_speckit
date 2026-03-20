#!/usr/bin/env bash
set -e

echo "🔍 FutureStandard tech stack validation..."
<<'comment'
# ===== Node.js =====
if ! command -v node >/dev/null 2>&1; then
  echo "❌ Node.js is required (Next.js stack)."
  echo "👉 Install from https://nodejs.org/"
  exit 1
fi

NODE_VERSION=$(node -v | sed 's/v//')
REQUIRED_NODE="18.0.0"
if [ "$(printf '%s\n' "$REQUIRED_NODE" "$NODE_VERSION" | sort -V | head -n1)" != "$REQUIRED_NODE" ]; then
  echo "❌ Node.js >= $REQUIRED_NODE required. Found $NODE_VERSION."
  exit 1
fi

# ===== npm / pnpm =====
if ! command -v npm >/dev/null && ! command -v pnpm >/dev/null; then
  echo "❌ npm or pnpm is required."
  exit 1
fi
comment
# ===== Python =====
if ! command -v python3 >/dev/null; then
  echo "❌ Python 3 is required (FastAPI stack)."
  exit 1
fi

# ===== pip / uv =====
if ! command -v pip >/dev/null && ! command -v uv >/dev/null; then
  echo "❌ pip or uv is required for Python dependencies."
  exit 1
fi

# ===== Git =====
if ! command -v git >/dev/null; then
  echo "❌ Git is required for Spec‑Kit branching workflow."
  exit 1
fi

# ===== VS Code =====
if ! command -v code >/dev/null; then
  echo "⚠️ VS Code not detected."
  echo "👉 Install VS Code or enable the 'code' command from VS Code."
  exit 1
fi

echo "✅ FutureStandard tech stack validation passed."