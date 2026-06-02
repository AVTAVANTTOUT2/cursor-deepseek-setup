# Cursor × DeepSeek V4 Setup

Configure Cursor IDE pour utiliser les modèles DeepSeek V4 (`deepseek-v4-pro` et `deepseek-v4-flash`) via l'API compatible OpenAI.

## Utilisation rapide

```bash
curl -fsSL https://raw.githubusercontent.com/AVTAVANTTOUT2/cursor-deepseek-setup/main/setup.sh | bash
```

Ou en local :

```bash
chmod +x setup.sh
./setup.sh
```

Le script te demandera ta clé API DeepSeek (`sk-...`) et configurera automatiquement Cursor.

## Ce que fait le script

1. **Détecte ton OS** (macOS, Linux, Windows)
2. **Sauvegarde** ton `settings.json` existant
3. **Configure** l'URL de base DeepSeek (`https://api.deepseek.com`)
4. **Ajoute** les modèles `deepseek-v4-flash` et `deepseek-v4-pro`
5. **Enregistre** ta clé API dans le champ compatible OpenAI

## Étape manuelle après le script

Dans Cursor : **Settings → Models →** activer **Override OpenAI Base URL**

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

## Compatibilité

- macOS (Apple Silicon / Intel)
- Linux (x86_64, ARM64)
- Windows (Git Bash, WSL)

## Sécurité

- La clé API est stockée localement dans `settings.json` de Cursor
- Le script sauvegarde ton fichier de config existant avant modification
- Aucune donnée n'est envoyée en ligne par le script
