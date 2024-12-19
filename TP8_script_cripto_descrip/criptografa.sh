#!/bin/bash

# Nome: Renato e Guilherme

# Função para exibir mensagens de erro
function mostrar_erro() {
    zenity --error --text="$1" --title="Erro" 2>/dev/null
}

# Função para exibir o menu de ajuda
function mostrar_ajuda() {
    echo "Uso: bash $0 [opções] ou ./$0 [opções]"
    echo
    echo "Opções:"
    echo "  --help       Exibe um menu de ajuda."
    echo
    echo "Este script criptografa uma pasta alvo com o algoritmo AES256."
    echo "Após a criptografia, ele criará um arquivo.zip, e em seguida um arquivo criptografado com o nome escolhido pelo usuário."
    echo
    echo "Instruções:"
    echo "1. O script solicitará que você selecione uma pasta a ser criptografada."
    echo "2. Em seguida, pede uma senha para criptografar."
    echo "3. Finalmente, você escolhe uma pasta de destino onde o arquivo criptografado irá"
    echo
    echo "Dependencias:"
    echo "1. Neste script são utilizadas algumas ferramentas como ponto chave para a realização de seu propósito"
    echo "2. São elas:"
    echo "3. Zenity"
    echo "4. Openssl"
    echo "5. Verifique em seu sistema operacional a existência de tais ferramentas para o funcionamento completo do script"
    exit 0
}

# Verificar se o parâmetro --help foi passado
if [[ "$1" == "--help" ]]; then
    mostrar_ajuda
fi

# Selecionar a pasta para criptografar
pasta=$(zenity --file-selection --directory --title="Selecione a pasta para criptografar" 2>/dev/null)
if [[ -z "$pasta" ]]; then
    mostrar_erro "Nenhuma pasta foi selecionada. O script será encerrado."
    exit 1
fi

# Solicitar o nome da pasta de saída
saida=$(zenity --file-selection --save --confirm-overwrite --title="Salvar a pasta criptografada como" --filename="secure.cript" 2>/dev/null)
if [[ -z "$saida" ]]; then
    mostrar_erro "Nenhum nome para a pasta foi especificado. O script será encerrado."
    exit 1
fi

# Solicitar uma senha para criptografia
senha=$(zenity --password --title="Digite a senha para criptografar" 2>/dev/null)
if [[ -z "$senha" ]]; then
    mostrar_erro "Nenhuma senha foi fornecida. O script será encerrado."
    exit 1
fi

# Compactar a pasta em um arquivo zip temporario
arquivo_zip="pasta_temporaria.zip"
tar -czf "$arquivo_zip" -C "$(dirname "$pasta")" "$(basename "$pasta")"

# Verificar se a compactação foi bem-sucedida
if [[ $? -ne 0 ]]; then
    mostrar_erro "Erro ao compactar a pasta. O script será encerrado."
    exit 1
fi

# Criptografar a pasta usando AES256
openssl enc -e -aes256 -pbkdf2 -in "$arquivo_zip" -out "$saida" -pass pass:"$senha"

# Verificar se a criptografia foi bem-sucedida
if [[ $? -ne 0 ]]; then
    mostrar_erro "Erro ao criptografar a pasta. O script será encerrado."
    # Remover o arquivo temporário
    rm "$arquivo_zip"
    exit 1
fi

# Remover o arquivo temporário tar.gz
rm "$arquivo_zip"

# Notificar o usuário que o processo foi concluído
zenity --info --text="A pasta foi criptografada com sucesso!" --title="Sucesso!!!" 2>/dev/null
