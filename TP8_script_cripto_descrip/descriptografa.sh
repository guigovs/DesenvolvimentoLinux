#!/bin/bash

# Nome: Renato Guilherme

# Função para exibir mensagens de erro
function mostrar_erro() {
    zenity --error --text="$1" --title="Erro" 2>/dev/null
}

# Função para exibir o menu de ajuda
mostrar_ajuda() {
    echo "Uso: bash $0 [opções] ou ./$0 [opções]"
    echo
    echo "Opções:"
    echo "  --help       Exibe este menu de ajuda."
    echo
    echo "Este script descriptografa um arquivo criptografado com o algoritmo AES256."
    echo "Após descriptografar, ele extrai o conteúdo e salva em uma pasta especificada pelo usuário."
    echo
    echo "Instruções:"
    echo "1. O script solicita que você selecione um arquivo criptografado."
    echo "2. Em seguida, pede uma senha para descriptografia."
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

# Selecionar o arquivo criptografado
arquivo=$(zenity --file-selection --title="Selecione o arquivo criptografado" 2>/dev/null)
if [[ -z "$arquivo" ]]; then
    mostrar_erro "Nenhum arquivo foi selecionado. O script será encerrado. Execute novamente"
    exit 1
fi

# Solicitar a senha para descriptografar o arquivo
senha=$(zenity --password --title="Digite a senha para descriptografia" 2>/dev/null)
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
arquivo_tar="arquivo_temporario.tar.gz"

# Descriptografar o arquivo usando AES256
openssl enc -d -aes256 -pbkdf2 -in "$arquivo" -out "$arquivo_tar" -pass pass:"$senha"

# Verificar se a descriptografia foi bem-sucedida
if [[ $? -ne 0 ]]; then
    mostrar_erro "Erro ao descriptografar o arquivo. Verifique a senha e tente novamente."
    rm "$arquivo_tar" 2>/dev/null  # Remove o arquivo temporário se existir
    exit 1
fi

# Extrair o conteúdo do arquivo tar.gz
tar -xzf "$arquivo_tar" -C "$destino"

# Verificar se a extração foi bem-sucedida
if [[ $? -ne 0 ]]; then
    mostrar_erro "Erro ao extrair o arquivo. O script será encerrado. Execute novamente em sua totalidade."
    rm "$arquivo_tar"  # Remove o arquivo temporário
    exit 1
fi

# Remover o arquivo temporário tar.gz
rm "$arquivo_tar"

# Notificar o usuário que o processo foi concluído
zenity --info --text="A pasta foi descriptografada e salva em: $destino" --title="Sucesso!!!" 2>/dev/null
