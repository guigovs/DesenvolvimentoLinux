#!/bin/bash

# Verifica se um arquivo foi passado como parâmetro
if [ $# -eq 0 ]; then
  echo "Uso: $0 <arquivo.txt>"
  exit 1
fi

# Nome do arquivo de entrada
input_file="$1"

# Variáveis para armazenar os dados
fatores=()                  # Array para armazenar os fatores
comando=""                  # Variável para armazenar o comando
ensaios=()                  # Array para armazenar os ensaios

# Flags para controlar as seções
reading_fatores=false
reading_comando=false
reading_ensaios=false

# Lê o arquivo linha por linha
while IFS= read -r line || [[ -n "$line" ]]; do
  # Remove espaços em branco no início e no fim da linha
  line=$(echo "$line" | xargs)

  # Ignora linhas vazias ou comentários
  if [[ -z "$line" || "$line" =~ ^## ]]; then
    continue
  fi

  # Verifica início e fim das seções
  if [[ "$line" == "FATORES:" ]]; then
    reading_fatores=true
    reading_comando=false
    reading_ensaios=false
    continue
  elif [[ "$line" == "COMANDO:" ]]; then
    reading_fatores=false
    reading_comando=true
    reading_ensaios=false
    continue
  elif [[ "$line" == "ENSAIOS:" ]]; then
    reading_fatores=false
    reading_comando=false
    reading_ensaios=true
    continue
  fi

  # Processa cada seção separadamente
  if $reading_fatores; then
    # Lê os fatores no formato "A = (5, 7.6, 10)"
    if [[ "$line" =~ ^([A-Za-z]+)\ =\ \((.+)\)$ ]]; then
      fator="${BASH_REMATCH[1]}"
      valores="${BASH_REMATCH[2]}"
      # Remove espaços e salva os valores do fator
      valores=$(echo "$valores" | tr -d ' ')
      fatores+=("$fator=$valores")
    fi

  elif $reading_comando; then
    # Lê o comando no formato "prog A B C"
    comando="$line"

  elif $reading_ensaios; then
    # Lê os ensaios no formato "1 = 5, 10, *"
    ensaios+=("$line")
  fi

done < "$input_file"

# Exibe os resultados (para verificação)
echo "FATORES:"
for fator in "${fatores[@]}"; do
  echo "$fator"
done

echo ""
echo "COMANDO:"
echo "$comando"

echo ""
echo "ENSAIOS:"
for ensaio in "${ensaios[@]}"; do
  echo "$ensaio"
done
