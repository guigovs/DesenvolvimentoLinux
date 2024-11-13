#!/bin/bash

A=$1
B=$2
C=$3

# Redireciona stderr (onde o time escreve) para uma variável, enquanto stdout do script é exibido normalmente
real_time=$( { time bash prog.sh "$A" "$B" "$C"; } 2> >(grep real | awk '{print $2}') )

# Exibe o tempo real após o script rodar
echo "Tempo real: $real_time"

