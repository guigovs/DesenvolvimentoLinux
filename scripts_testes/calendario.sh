#!/bin/bash

# Capturando a data escolhida pelo usuário a partir de um calendário
data=$(zenity --title="Escolha a data" --calendar)

# Verificando se o usuário escolheu uma data
if [[ -n "$data" ]]
then
  echo "A data escolhida foi: $data"
else
  echo "Usuário não escolheu nenhuma data"
fi
