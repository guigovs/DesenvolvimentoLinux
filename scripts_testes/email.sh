#!/bin/bash

# Definindo a mensagem e o título do popup
MENSAGEM="O backup dos arquivos foram feitos do diretorio X para o diretorio Y"
TITULO="Backup Realizado com Sucesso!"

# Exibindo o popup com zenity
zenity --info --text="$MENSAGEM" --title="$TITULO"
