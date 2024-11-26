#!/bin/bash

# Função para exibir mensagens de erro
mostrar_erro() {
    zenity --error --text="$1" --title="Erro" 2>/dev/null
}

# Selecionar o arquivo criptografado
arquivo=$(zenity --file-selection --title="Selecione o arquivo criptografado (.bf)" 2>/dev/null)
if [[ -z "$arquivo" ]]; then
    mostrar_erro "Nenhum arquivo foi selecionado. O script será encerrado."
    exit 1
fi

# Solicitar a senha para descriptografar o arquivo
senha=$(zenity --password --title="Digite a senha para descriptografia" 2>/dev/null)
if [[ -z "$senha" ]]; then
    mostrar_erro "Nenhuma senha foi fornecida. O script será encerrado."
    exit 1
fi

# Solicitar o local para salvar a pasta descriptografada
destino=$(zenity --file-selection --directory --title="Selecione o local para salvar a pasta descriptografada" 2>/dev/null)
if [[ -z "$destino" ]]; then
    mostrar_erro "Nenhum local foi selecionado. O script será encerrado."
    exit 1
fi

# Nome do arquivo temporário após descriptografia
arquivo_tar="arquivo_temporario.tar.gz"

# Descriptografar o arquivo usando Blowfish
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
    mostrar_erro "Erro ao extrair o arquivo. O script será encerrado."
    rm "$arquivo_tar"  # Remove o arquivo temporário
    exit 1
fi

# Remover o arquivo temporário tar.gz
rm "$arquivo_tar"

# Notificar o usuário que o processo foi concluído
zenity --info --text="A pasta foi descriptografada e salva em: $destino" --title="Sucesso" 2>/dev/null
