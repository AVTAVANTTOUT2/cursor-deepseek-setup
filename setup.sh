#!/bin/bash

# ─────────────────────────────────────────────
#  Cursor × DeepSeek Setup
#  Models : deepseek-v4-pro + deepseek-v4-flash
#  github.com/AVTAVANTTOUT2/cursor-deepseek-setup
# ─────────────────────────────────────────────

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}║    Cursor × DeepSeek V4 Setup        ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════╝${NC}"
echo ""

# ── Détection OS ──────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
  SETTINGS_DIR="$HOME/Library/Application Support/Cursor/User"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  SETTINGS_DIR="$HOME/.config/Cursor/User"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  SETTINGS_DIR="$APPDATA/Cursor/User"
else
  echo -e "${RED}OS non supporté.${NC}"
  exit 1
fi

SETTINGS_FILE="$SETTINGS_DIR/settings.json"

# ── Saisie clé API ────────────────────────────
echo -e "${CYAN}Colle ta clé API DeepSeek (sk-...) :${NC}"
read -rs API_KEY
echo ""

if [[ -z "$API_KEY" ]]; then
  echo -e "${RED}Clé vide. Abandon.${NC}"
  exit 1
fi

if [[ ! "$API_KEY" == sk-* ]]; then
  echo -e "${YELLOW}⚠ La clé ne commence pas par sk- — continue quand même...${NC}"
fi

# ── Backup settings existants ─────────────────
mkdir -p "$SETTINGS_DIR"

if [[ -f "$SETTINGS_FILE" ]]; then
  BACKUP="$SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
  cp "$SETTINGS_FILE" "$BACKUP"
  echo -e "${YELLOW}Backup → $BACKUP${NC}"
else
  echo "{}" > "$SETTINGS_FILE"
fi

# ── Merge settings via Python ─────────────────
python3 - <<PYEOF
import json, sys

path = """$SETTINGS_FILE"""

with open(path, "r") as f:
    try:
        settings = json.load(f)
    except json.JSONDecodeError:
        settings = {}

# Clé DeepSeek dans le champ OpenAI (compatible)
settings["openai.apiKey"]              = """$API_KEY"""
settings["cursor.openai.baseUrl"]      = "https://api.deepseek.com"

# Modèles custom
existing = settings.get("cursor.models.custom", [])
for model in ["deepseek-v4-flash", "deepseek-v4-pro"]:
    if model not in existing:
        existing.append(model)
settings["cursor.models.custom"] = existing

with open(path, "w") as f:
    json.dump(settings, f, indent=2)

print("OK")
PYEOF

# ── Confirmation ──────────────────────────────
echo ""
echo -e "${GREEN}✅ Config appliquée !${NC}"
echo ""
echo -e "${BOLD}Résumé :${NC}"
echo -e "  Base URL  → ${CYAN}https://api.deepseek.com${NC}"
echo -e "  Modèles   → ${CYAN}deepseek-v4-flash${NC} + ${CYAN}deepseek-v4-pro${NC}"
echo -e "  API Key   → ${CYAN}${API_KEY:0:8}...${NC}"
echo ""
echo -e "${BOLD}Étape manuelle restante :${NC}"
echo -e "  Cursor → Settings → Models → toggle ${YELLOW}Override OpenAI Base URL${NC} → ${GREEN}ON${NC}"
echo ""
echo -e "${YELLOW}💡 Recommandé pour le coding : deepseek-v4-flash (moins cher, zéro bug)${NC}"
echo -e "${YELLOW}💡 Pour l'architecture complexe : deepseek-v4-pro${NC}"
echo ""
