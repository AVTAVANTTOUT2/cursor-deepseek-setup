# Cursor × DeepSeek V4 Setup

Configure Cursor IDE pour utiliser les modèles DeepSeek V4 (`deepseek-v4-pro` et `deepseek-v4-flash`) via l'API compatible OpenAI.

> **Important :** ce script fonctionne uniquement avec **Cursor Desktop** (l'application avec interface graphique). Le **Cursor Agent CLI** (terminal/headless) ne supporte pas les endpoints OpenAI custom. Si tu es sur un serveur sans interface graphique, vois la section [Alternative pour serveur headless](#alternative-pour-serveur-headless).

## Utilisation rapide

```bash
curl -fsSL https://raw.githubusercontent.com/AVTAVANTTOUT2/cursor-deepseek-setup/main/setup.sh | bash
```

Ou en local :

```bash
chmod +x setup.sh
./setup.sh
```

Le script détecte automatiquement si tu es sur Desktop ou CLI, et te guide en conséquence.

## Ce que fait le script

1. **Détecte ton OS** (macOS, Linux, Windows)
2. **Détecte Cursor Desktop vs CLI** (ne tente pas de configurer un CLI non supporté)
3. **Sauvegarde** ton `settings.json` existant
4. **Configure** l'URL de base DeepSeek (`https://api.deepseek.com`)
5. **Ajoute** les modèles `deepseek-v4-flash` et `deepseek-v4-pro`
6. **Enregistre** ta clé API dans le champ compatible OpenAI

## Étape manuelle après le script

Dans Cursor Desktop : **Settings → Models →** activer **Override OpenAI Base URL**

## Modèles disponibles

| Modèle | Usage recommandé |
|--------|-----------------|
| `deepseek-v4-flash` | Coding quotidien (rapide, économique) |
| `deepseek-v4-pro` | Architecture complexe, refactoring lourd |

## Obtenir une clé API

1. Va sur [platform.deepseek.com](https://platform.deepseek.com)
2. Crée un compte ou connecte-toi
3. Va dans **API Keys** → **Create new key**
4. Copie la clé (format `sk-...`)

## Alternative pour serveur headless

Si tu utilises Cursor Agent CLI sur un serveur sans interface graphique (Debian, Ubuntu Server, etc.), le Cursor CLI ne supporte **pas** les endpoints OpenAI custom. Utilise plutôt **[Aider](https://aider.chat)** :

```bash
# Installation
sudo apt update && sudo apt install -y pipx
pipx ensurepath && source ~/.bashrc
pipx install aider-chat

# Utilisation avec DeepSeek
export DEEPSEEK_API_KEY="sk-ta-clé"
aider --model deepseek/deepseek-chat

# Mode architecte (deepseek-reasoner pour le design, deepseek-chat pour le code)
aider --model deepseek/deepseek-chat \
      --architect-model deepseek/deepseek-reasoner
```

Aider fonctionne 100% en terminal, supporte DeepSeek nativement, et intègre git automatiquement.

## Compatibilité

| Version Cursor | Supporté |
|---------------|---------|
| Cursor Desktop (macOS, Linux, Windows) | Oui |
| Cursor Agent CLI (terminal/headless) | Non — utiliser Aider |

## Sécurité

- La clé API est stockée localement dans `settings.json` de Cursor
- Le script sauvegarde ton fichier de config existant avant modification
- Aucune donnée n'est envoyée en ligne par le script
