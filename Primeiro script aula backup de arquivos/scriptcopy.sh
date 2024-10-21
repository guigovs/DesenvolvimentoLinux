#!/bin/bash

# Verificar se um argumento foi fornecido
if [ $# -eq 0 ]; then
    echo "Erro: Por favor, forneça o nome do arquivo como argumento."
    exit 1
fi

filename="$1"

# Verificar se o arquivo existe
if [ -e "$filename" ]; then
    # Verificar se um arquivo de backup já existe
    current_date2=$(date +%F)
    backup_filename="${filename}.bak.${current_date2}"
    if [ -e "$backup_filename" ]; then
        read -p "O arquivo de backup já existe. Deseja substituí-lo? (sim/não): " replace_backup
        
        if [ "$replace_backup" = "sim" ]; then
            # Copiar o arquivo para o nome do backup com a data atual
            current_date=$(date +%F)
            new_backup_filename="${filename}.bak.${current_date}"
            cp "$filename" "$new_backup_filename"
            echo "Backup criado!"
            ls -la | grep $new_backup_filename
        else
            echo "Nenhum backup foi criado!"
        fi
    else
        # Copiar o arquivo para o nome do backup
        cp "$filename" "$backup_filename"
        echo "Backup criado!"
        ls -la | grep $backup_filename
    fi
else
    echo "O arquivo não existe, então nenhum backup foi criado."
fi

