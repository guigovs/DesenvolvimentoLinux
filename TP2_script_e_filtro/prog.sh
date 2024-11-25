#!/bin/bash

# Script para gerar sleep aleatorios

A=$1 # primeiro parametro
B=$2 # segundo parametro
C=$3 # terceiro paramentro

# Função para sleep aleatório
function random_sleep() 
{
    dormindo=$((RANDOM % 10 + 1))
    echo "$dormindo"
    sleep $dormindo
}

function media()
{
  local media=$((($A+$B+$C)/3))
  echo "essa e $media"
}

# Uso da função
media
random_sleep

