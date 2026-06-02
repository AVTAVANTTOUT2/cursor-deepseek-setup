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
CLI_CONFIG_FILE="$HOME/.cursor/cli-config.json"

# ── Détection Cursor Desktop vs CLI ───────────
IS_DESKTOP=false
IS_CLI=false

if [[ -f "$SETTINGS_FILE" ]]; then
  IS_DESKTOP=true
fi

if [[ -f "$CLI_CONFIG_FILE" ]]; then
  IS_CLI=true
fi

# Détection heuristique : pas de DISPLAY + pas de settings desktop = probablement CLI
if [[ -z "${DISPLAY:-}" ]] && [[ "$IS_DESKTOP" == false ]]; then
  IS_CLI=true
fi

# ── Branche CLI (non supporté) ────────────────
if [[ "$IS_CLI" == true ]] && [[ "$IS_DESKTOP" == false ]]; then
  echo -e "${YELLOW}⚠ Cursor Agent CLI détecté (pas d'interface graphique).${NC}"
  echo ""
  echo -e "${RED}Le Cursor Agent CLI NE supporte PAS les endpoints OpenAI custom.${NC}"
  echo -e "${RED}Les modèles custom + override base URL sont une fonctionnalité${NC}"
  echo -e "${RED}du Cursor Desktop uniquement, pas du CLI.${NC}"
  echo ""
  echo -e "${BOLD}════════════════════════════════════════${NC}"
  echo -e "${BOLD}  Alternative : Aider × DeepSeek${NC}"
  echo -e "${BOLD}════════════════════════════════════════${NC}"
  echo ""
  echo -e "${GREEN}Aider${NC} est un outil de coding en terminal qui supporte"
  echo -e "DeepSeek nativement, sans proxy ni hack."
  echo ""
  echo -e "${CYAN}Installation rapide :${NC}"
  echo ""
  echo -e "  ${BOLD}# 1. Installer Aider${NC}"
  echo -e "  sudo apt update && sudo apt install -y pipx"
  echo -e "  pipx ensurepath && source ~/.bashrc"
  echo -e "  pipx install aider-chat"
  echo ""
  echo -e "  ${BOLD}# 2. Lancer avec DeepSeek${NC}"
  echo -e "  export DEEPSEEK_API_KEY=\"sk-ta-clé\""
  echo -e "  aider --model deepseek/deepseek-chat"
  echo ""
  echo -e "  ${BOLD}# 3. Mode architecte (optionnel)${NC}"
  echo -e "  aider --model deepseek/deepseek-chat \\"
  echo -e "        --architect-model deepseek/deepseek-reasoner"
  echo ""
  echo -e "${YELLOW}Plus d'infos : https://aider.chat${NC}"
  echo ""
  exit 0
fi

# ── Branche Desktop ────────────────────────────
echo -e "${GREEN}✓ Cursor Desktop détecté${NC}"
echo ""

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
