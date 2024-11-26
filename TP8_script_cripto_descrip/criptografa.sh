#!/bin/bash

# Função para exibir mensagens de erro
mostrar_erro() {
    zenity --error --text="$1" --title="Erro" 2>/dev/null
}

# Selecionar a pasta para criptografar
pasta=$(zenity --file-selection --directory --title="Selecione a pasta para criptografar" 2>/dev/null)
if [[ -z "$pasta" ]]; then
    mostrar_erro "Nenhuma pasta foi selecionada. O script será encerrado."
    exit 1
fi

# Solicitar o nome do arquivo de saída
saida=$(zenity --file-selection --save --confirm-overwrite --title="Salvar arquivo criptografado como" --filename="pasta_criptografada.tar.gz.bf" 2>/dev/null)
if [[ -z "$saida" ]]; then
    mostrar_erro "Nenhum nome de arquivo foi especificado. O script será encerrado."
    exit 1
fi

# Solicitar uma senha para criptografia
senha=$(zenity --password --title="Digite a senha para criptografia" 2>/dev/null)
if [[ -z "$senha" ]]; then
    mostrar_erro "Nenhuma senha foi fornecida. O script será encerrado."
    exit 1
fi

# Compactar a pasta em um arquivo tar.gz
arquivo_tar="pasta_temporaria.tar.gz"
tar -czf "$arquivo_tar" -C "$(dirname "$pasta")" "$(basename "$pasta")"

# Verificar se a compactação foi bem-sucedida
if [[ $? -ne 0 ]]; then
    mostrar_erro "Erro ao compactar a pasta. O script será encerrado."
    exit 1
fi

# Criptografar o arquivo tar.gz usando aes256
openssl enc -e -aes256 -pbkdf2 -in "$arquivo_tar" -out "$saida" -pass pass:"$senha"

# Verificar se a criptografia foi bem-sucedida
if [[ $? -ne 0 ]]; then
    mostrar_erro "Erro ao criptografar o arquivo. O script será encerrado."
    # Remover o arquivo temporário
    rm "$arquivo_tar"
    exit 1
fi

# Remover o arquivo temporário tar.gz
rm "$arquivo_tar"

# Notificar o usuário que o processo foi concluído
zenity --info --text="A pasta foi criptografada com sucesso!" --title="Sucesso" 2>/dev/null
