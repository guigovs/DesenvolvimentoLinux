#!/bin/bash

function menu_escolha(){

menu=$(zenity --list \
  --title="Choose the Bugs You Wish to View" \
  --column="Bug Number" --column="Severity" \
  1 "Entre para agendar uma tarefa" \
  2 "Entre para deletar uma tarefa" \
  3 "Sair"
)

# Verifica se alguma opção foi selecionada
if [ $? -eq 0 ]; then
    # Exibe a string completa da opção selecionada
    echo "Você escolheu: $menu"
else
    echo "Nenhuma opção foi selecionada."
fi
}


