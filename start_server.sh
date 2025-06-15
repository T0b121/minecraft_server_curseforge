#!/bin/bash

# Pfad zur .env Datei (im gleichen Verzeichnis wie das Skript)
DIR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_MODPACK="$DIR_ROOT/modpack"
FILE_MODPACK_VERSION="$DIR_MODPACK/modpack_version.txt"
FILE_ENV="$DIR_ROOT/.env"

# ENV Variablen
# Überprüfen ob die .env Datei existiert, andernfalls erstelle die Datei
if [ ! -f "$FILE_ENV" ]; then
    touch "$FILE_ENV"
fi
# Laden der ENV Variablen (CF_API_KEY, CF_MODPACK_IDs); wenn nicht gesetzt vordere die angebe im terminal nach (im passwort modus bei den api key)
CF_API_KEY=$(grep -E '^CF_API_KEY=' "$FILE_ENV" | cut -d '=' -f2-)
if [ -z "$CF_API_KEY" ]; then
    echo -n "Bitte gib deinen CurseForge API Key ein: "
    stty -echo
    read CF_API_KEY
    stty echo
    echo
    echo "CF_API_KEY=$CF_API_KEY" >> "$FILE_ENV"
fi
CF_MODPACK_ID=$(grep -E '^CF_MODPACK_ID=' "$FILE_ENV" | cut -d '=' -f2-)
if [ -z "$CF_MODPACK_ID" ]; then
    read -p "Bitte gib die CurseForge Modpack ID ein: " CF_MODPACK_ID
    echo "CF_MODPACK_ID=$CF_MODPACK_ID" >> "$FILE_ENV"
fi

# Anfrage der aktuellen Version des Minecraft Modpacks, bei der CurseForge API
# Warte darauf das ich einen Key Bekomme