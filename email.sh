#!/bin/bash

# Função para exibir popup no Linux
linux_popup() {
    if command -v zenity >/dev/null 2>&1; then
        zenity --info --text="Este é um alerta de popup no Linux!" --title="Alerta"
    elif command -v notify-send >/dev/null 2>&1; then
        notify-send "Alerta" "Este é um alerta de popup no Linux!"
    else
        echo "Nenhuma ferramenta de notificação encontrada no Linux."
        exit 1
    fi
}

# Função para exibir popup no macOS
macos_popup() {
    osascript -e 'display notification "Este é um alerta de popup no macOS!" with title "Alerta"'
}

# Detectar o sistema operacional
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    linux_popup
elif [[ "$OSTYPE" == "darwin"* ]]; then
    macos_popup
else
    echo "Sistema operacional não suportado."
    exit 1
fi
