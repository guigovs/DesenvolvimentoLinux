#!/bin/bash

arquivos=($1)

ajuda_usuario()
{
	echo "Esse script tem a finalidade de um organizador de arquivos"
	echo "Digite o nome dele e como parametro a extensao do arquivo"
	echo "Sera criada uma pasta e os arquivos da extensao escolhida serao movidos para dentro do mesmo"
	echo "Exemplo de uso: $0 py"
	echo "Sera criada uma pasta com o nome py e os arquivos .py serao movidos para esse diretorio"

}

organiza_em_pastas()
{

	if test -d "${arquivos}"; then
		mv *.${arquivos} ${arquivos}
    
	else
	    mkdir ${arquivos}
		sleep 1
		mv *.${arquivos} ${arquivos}
	fi

}

if [ $# -eq 0 ]; then
    echo "Erro: Não foram fornecidos argumentos."
    echo "Utilize o comando -help para obter ajuda, exemplo: $0 -help"
    exit 1

elif [[ "${arquivos}" == "-help" ]]; then
	
	ajuda_usuario

else
	organiza_em_pastas
fi


