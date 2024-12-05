#!/bin/bash

# Função para exibir o menu
menu() {
  echo "---- CRON MANAGER ----"
  echo "1) Listar tarefas agendadas"
  echo "2) Adicionar nova tarefa"
  echo "3) Remover uma tarefa"
  echo "4) Sair"
  echo "----------------------"
}

# Função para listar tarefas agendadas
listar_tarefas() {
  echo "Tarefas agendadas:"
  # || Funciona igual uma operacao ou, se o primeiro comando funcionar o segundo nao e utilizado
  crontab -l || echo "Nenhuma tarefa agendada."
  echo
}

# Função para adicionar nova tarefa
adicionar_tarefa() {
  echo "Digite a tarefa que deseja agendar (formato cron):"
  read nova_tarefa
  (crontab -l 2>/dev/null; echo "$nova_tarefa") | crontab -
  echo "Tarefa adicionada com sucesso!"
  echo
}

# Função para remover uma tarefa
remover_uma_tarefa() {
  tarefas=$(crontab -l)
  
  if [ -z "$tarefas" ]; then
    echo "Nenhuma tarefa agendada."
    return
  fi

  echo "Tarefas agendadas:"
  
  # Listar as tarefas numeradas
  IFS=$'\n' read -r -d '' -a tarefas_array <<< "$tarefas"
  for i in "${!tarefas_array[@]}"; do
    echo "$((i + 1))) ${tarefas_array[$i]}"
  done

  echo "Escolha o número da tarefa que deseja remover:"
  read tarefa_num

  # Validar a entrada do usuário
  if ! [[ "$tarefa_num" =~ ^[0-9]+$ ]] || [ "$tarefa_num" -lt 1 ] || [ "$tarefa_num" -gt "${#tarefas_array[@]}" ]; then
    echo "Número inválido."
    return
  fi

  # Remover a tarefa escolhida
  unset 'tarefas_array[tarefa_num-1]'

  # Recriar o crontab com as tarefas restantes
  printf "%s\n" "${tarefas_array[@]}" | crontab -
  echo "Tarefa removida com sucesso!"
  echo
}

# Loop para exibir o menu e ler a opção do usuário
while true; do
  menu
  echo -n "Escolha uma opção: "
  read opcao

  case $opcao in
    1)
      listar_tarefas
      ;;
    2)
      adicionar_tarefa
      ;;
    3)
      remover_uma_tarefa
      ;;
    4)
      echo "Saindo..."
      exit 0
      ;;
    *)
      echo "Opção inválida, tente novamente."
      ;;
  esac
done
