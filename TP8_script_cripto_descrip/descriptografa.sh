#!/bin/bash

# Nome: Renato Guilherme

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
    echo "Este script descriptografa uma pasta criptografada com o algoritmo AES256."
    echo "Após descriptografar, ele extrai o conteúdo e salva em uma pasta especificada pelo usuário."
    echo
    echo "Instruções:"
    echo "1. O script solicita que você selecione uma pasta criptografada, como a sugerida secure.cript."
    echo "2. Em seguida, pede uma senha para descriptografar."
    echo "3. Finalmente, você escolhe uma pasta de destino onde os arquivos serão extraídos."
    echo
    echo "Dependencias:"
    echo "1. Neste script são utilizadas algumas ferramentas como ponto chave para a realização de seu proposito"
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

# Selecionar a pasta criptografada
arquivo=$(zenity --file-selection --title="Selecione a pasta criptografada" 2>/dev/null)
if [[ -z "$arquivo" ]]; then
    mostrar_erro "Nenhuma pasta foi selecionada. O script será encerrado. Execute novamente"
    exit 1
fi

# Solicitar a senha para descriptografar a pasta
senha=$(zenity --password --title="Digite a senha para a descriptografia" 2>/dev/null)
if [[ -z "$senha" ]]; then
    mostrar_erro "Nenhuma senha foi fornecida. O script será encerrado. Execute novamente em sua totalidade."
    exit 1
fi

# Solicitar o local para salvar a pasta descriptografada
destino=$(zenity --file-selection --directory --title="Selecione o local para salvar a pasta descriptografada" 2>/dev/null)
if [[ -z "$destino" ]]; then
    mostrar_erro "Nenhum local foi selecionado. O script será encerrado. Execute novamente em sua totalidade."
    exit 1
fi

# Nome do arquivo temporário após descriptografia
arquivo_zip="arquivo_temporario.zip"

# Descriptografar o arquivo usando AES256
openssl enc -d -aes256 -pbkdf2 -in "$arquivo" -out "$arquivo_zip" -pass pass:"$senha"

# Verificar se a descriptografia foi bem-sucedida
if [[ $? -ne 0 ]]; then
    mostrar_erro "Erro ao descriptografar a pasta. Verifique a senha e tente novamente."
    rm "$arquivo_zip" 2>/dev/null  # Remove o arquivo temporário se existir
    exit 1
fi

# Extrair o conteúdo do arquivo zip
tar -xzf "$arquivo_zip" -C "$destino"

# Verificar se a extração foi bem-sucedida
if [[ $? -ne 0 ]]; then
    mostrar_erro "Erro ao extrair o arquivo. O script será encerrado. Execute novamente em sua totalidade."
    rm "$arquivo_zip"  # Remove o arquivo temporário
    exit 1
fi

# Remover o arquivo temporário zip
rm "$arquivo_zip"

# Notificar o usuário que o processo foi concluído
zenity --info --text="A pasta foi descriptografada e salva em: $destino" --title="Sucesso!!!" 2>/dev/null
