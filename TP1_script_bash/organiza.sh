#!/bin/bash

# Nomes: Renato e Guilherme

pasta_origem=$1
pasta_destino=$2
caminho_com_aspas_origem="${pasta_origem//\'/\'\'}"
caminho_com_aspas_destino="${pasta_destino//\'/\'\'}"


function ajuda_usuario()
{
	echo "Esse script tem a finalidade de um organizador de arquivos"
	echo "Digite o nome do script, mais a pasta de origem e pasta de destino"
	echo "Sera criada uma pasta e os arquivos da extensao escolhida serao movidos para dentro do mesmo"
	echo "Caso o arquivo nao tenha extensao, sera criada uma pasta vazia e o arquivo sera movido para o mesmo"
	echo "Para melhor funcionamento do script, lembre-se de utilizar \ caso deu diretorio tenha mais de um nome separado por espacos"
	echo "Exemplo de uso: organiza /home/user/ /home/user/Pasta_Organizada"
	echo "Exemplo de uso diretorio com espacos: organiza /home/user\ AlgumaCoisa/ /home/user\ AlgumaCoisa/Pasta\ Organizada"

}

function cria_pasta()
{   
	# variavel que sera chamada como parametro da funcao
    local novo_diretorio="$1"
    local ultimo_diretorio=$(basename "$novo_diretorio") # pega o ultimo nome do path

    if [[ ! -d "${ultimo_diretorio}" ]]; then
        # O diretório não existe, cria ele
        mkdir "$ultimo_diretorio"
    fi
}

function mover()
{
	local path_origem="$1"
	local path_destino="$2"

	for file in "$path_origem"/*; do
        # Verificar se é um arquivo regular (não uma pasta)
            if [ -f "$file" ]; then
                # Obter a extensão do arquivo

                if [[ "$file" =~ \. ]]; then
  					#echo "O arquivo tem extensão"
  					local extension="${file##*.}"
  					# Criar uma pasta com o nome da extensão
  					cria_pasta "$extension"
  					# Mover o arquivo para a pasta correspondente
                	mv "$file" "$pasta_destino/$extension/"
                	echo "Arquivo movido: $(basename "$file") -> $extension"
				else
					local pasta_vazia="vazia"
  					#echo "O arquivo não tem extensão"
  					# Criar uma pasta com o nome da extensão
  					cria_pasta "$pasta_vazia"
  					# Mover o arquivo para a pasta correspondente
                	mv "$file" "$pasta_destino/$pasta_vazia/"
                	echo "Arquivo movido: $(basename "$file") -> vazia"
				fi
        
                
            fi
        done
}

function organiza_em_pastas()
{   
	local diretorio_origem="$1"
    local diretorio_destino="$2"
    
    cd "$diretorio_destino"
    #cria_pasta "$diretorio_destino"
    mover "$diretorio_origem" "$diretorio_destino"


}
if [ $# -eq 0 ]; then
    echo "Erro: Não foram fornecidos argumentos"
    echo "Utilize o comando --help para obter ajuda, exemplo: organiza.sh --help"
    exit 1

elif [[ "${pasta_origem}" == "--help" ]]; then
	ajuda_usuario

else
	organiza_em_pastas "$caminho_com_aspas_origem" "$caminho_com_aspas_destino"
fi


