#!/bin/bash

# Verifica se o número de argumentos é correto
if [ $# -ne 2 ]; then
  echo "Uso: $0 <arquivo_configuracao> <arquivo_saida>"
  exit 1
fi

CONFIG_FILE=$1
OUTPUT_FILE=$2

# Verifica se o arquivo de configuração existe
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Arquivo de configuração $CONFIG_FILE não encontrado!"
  exit 1
fi

# Inicializa variáveis para armazenar os fatores e o comando
declare -A FACTORS
COMMAND=""

# Lê o arquivo de configuração
while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]*FATORES: ]]; then
    # Ignora a linha de cabeçalho dos fatores
    continue
  elif [[ "$line" =~ ^[[:space:]]*COMANDO: ]]; then
    # Lê o comando
    read -r COMMAND
  elif [[ "$line" =~ ^[[:space:]]*ENS[[:upper:]] ]]; then
    # Inicia a leitura dos ensaios
    break
  elif [[ "$line" =~ ^[[:space:]]*([A-Z])\ *=\ *\((.*)\)$ ]]; then
    # Extrai o fator e seus níveis
    FACTOR=${BASH_REMATCH[1]}
    LEVELS=${BASH_REMATCH[2]}
    FACTORS["$FACTOR"]=$LEVELS
  fi
done < "$CONFIG_FILE"

# Gera as combinações dos ensaios
awk -v factors="${!FACTORS[*]}" -v levels="${FACTORS[*]}" -v cmd="$COMMAND" '
BEGIN {
  split(factors, factor_list, " ");
  split(levels, level_list, " ");
  for (i in factor_list) {
    split(level_list[i], factor_levels[factor_list[i]], ",");
  }
}
{
  for (a in factor_levels["A"]) {
    for (b in factor_levels["B"]) {
      for (c in factor_levels["C"]) {
        gsub("\\$A", factor_levels["A"][a], cmd);
        gsub("\\$B", factor_levels["B"][b], cmd);
        gsub("\\$C", factor_levels["C"][c], cmd);
        print cmd;
      }
    }
  }
}' > "$OUTPUT_FILE"

echo "Processamento concluído. Saída salva em $OUTPUT_FILE."

