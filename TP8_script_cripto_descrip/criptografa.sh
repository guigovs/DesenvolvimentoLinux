#!/bin/bash

# Nome: Renato e Guilherme

# Função para exibir mensagens de erro
mostrar_erro() {
    zenity --error --text="$1" --title="Erro" 2>/dev/null
}

# Função para exibir o menu de ajuda
mostrar_ajuda() {
    echo "Uso: bash $0 [opções] ou ./$0 [opções]"
    echo
    echo "Opções:"
    echo "  --help       Exibe este menu de ajuda."
    echo
    echo "Este script criptografa um arquivo com o algoritmo AES256."
    echo "Após a criptografia, ele criará um arquivo.tar.gz, e em seguida um arquivo criptografado com o nome escolhido pelo usuário."
    echo
    echo "Instruções:"
    echo "1. O script solicita que você selecione um arquivo a ser criptografado."
    echo "2. Em seguida, pede uma senha para criptografia."
    echo "3. Finalmente, você escolhe uma pasta de destino onde os arquivos serão extraídos."
    echo
    echo "Dependencias:"
    echo "1. Caso o usuário esteja utilizando o sistema operacional Linux baseados em Debian"
    echo "2. Utilize o comando ( sudo apt install zenity )"
    echo "3. Esse comando irá instalar a ferramenta zenity, que será necessaria para a visualização da parte gráfica do script"
    echo
    echo "4. Caso o usuário tenha utilizando sistema MacOs"
    echo "5. Utilize o comando ( brew install zenity )"
    echo "6. Esse comando irá instalar a ferramenta zenity, que será necessaria para a visualização da parte gráfica do script"
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
