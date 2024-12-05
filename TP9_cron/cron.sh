#!/bin/bash

# Nome: Renato e Guilherme

# Função para agendar tarefas
function faz_tarefa()
{
    # Captura a saída do formulário em uma variável
    output=$(zenity --forms --title="Agendador de tarefas - CRON" \
        --text="Entre com as informacoes das tarefas" \
        --separator="," \
        --add-entry="Comando" \
        --add-entry="Minutos (0 .. 59)" \
        --add-entry="Hora (0 .. 23)" \
        --add-entry="Semana (0=Sun .. 6=Sat)"\
        --add-calendar="Dia e mes"\
    )

    # Verifica o status de saída do Zenity
    case $? in
        0)
            # Separa a string capturada em variáveis (usando vírgula como separador)
            comando=$(echo "$output" | cut -d',' -f1)
            minutos_c=$(echo "$output" | cut -d',' -f2)
            hora_c=$(echo "$output" | cut -d',' -f3)
            semana_c=$(echo "$output" | cut -d',' -f4)
            data_c=$(echo "$output" | cut -d',' -f5)
            dia_c=$(echo "$data_c" | cut -d'/' -f1)
            mes_c=$(echo "$data_c" | cut -d'/' -f2)

            # Remove zeros à esquerda dos dias e meses usando substituição no Bash
            dia_c=$(echo $((10#$dia_c)))  # Remove zero à esquerda do dia
            mes_c=$(echo $((10#$mes_c)))  # Remove zero à esquerda do mês

            # Criar lista de valores separados por espaço
            lista="$minutos_c $hora_c $dia_c $mes_c $semana_c $comando"

            # Exibindo barra de progresso
            barra_prog

            # Lista as tarefas existentes e adiciona a nova tarefa ao crontab
            (crontab -l 2>/dev/null; echo "$lista") | crontab -

            ;;
        1)
            echo "Tela fechada sem escolha"
            ;;
        -1)
            echo "Ocorreu um erro"
            ;;
    esac
}

# Função para exibir uma barra de progresso
function barra_prog()
{
(
echo "10" ; sleep 1
echo "# Aguarde o processo" ; sleep 1
echo "20" ; sleep 1
echo "# Isso pode demorar um pouco" ; sleep 1
echo "50" ; sleep 1
echo "# Tarefa sendo escalonada" ; sleep 1
echo "75" ; sleep 1
echo "# Processo Concluido com Sucesso!" ; sleep 1
echo "100" ; sleep 1
) |
zenity --progress \
  --title="Criando tarefa" \
  --text="..." \
  --percentage=0

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Cancelamento inesperado"
fi
}

# Função para deletar uma tarefa específica do crontab
function deletar_tarefa() {
    # Listar todas as tarefas do crontab
    tarefas=$(crontab -l 2>/dev/null)

    if [ -z "$tarefas" ]; then
        zenity --info --text="Nenhuma tarefa agendada."
        return
    fi

    # Mostrar as tarefas em uma lista para o usuário escolher
    tarefa_escolhida=$(echo "$tarefas" | zenity --list --text="Selecione a tarefa que deseja deletar:" --column="Tarefas" 2>/dev/null)

    # Se o usuário cancelar a seleção, retorna ao menu
    if [ -z "$tarefa_escolhida" ]; then
        zenity --info --text="Nenhuma tarefa foi selecionada."
        return
    fi

    # Remover a tarefa selecionada do crontab
    novas_tarefas=$(echo "$tarefas" | grep -v "$tarefa_escolhida")

    # Atualizar o crontab com as tarefas restantes
    echo "$novas_tarefas" | crontab -

    zenity --info --text="Tarefa removida com sucesso!"
}

function visualizar_tarefas() {
    # Captura as tarefas agendadas no crontab
    tarefas=$(crontab -l 2>/dev/null)

    # Verifica se existem tarefas agendadas
    if [ -z "$tarefas" ]; then
        # Se não houver tarefas, exibe uma mensagem de alerta
        zenity --warning \
            --title="Tarefas agendadas" \
            --text="Não há tarefas agendadas no crontab" \
            2>/dev/null
    else
        # Exibe as tarefas em uma caixa de texto
        zenity --text-info \
            --title="Tarefas agendadas" \
            --width=600 \
            --height=400 \
            --filename=<(echo "$tarefas") \
            2>/dev/null
    fi
}

# Função para exibir o menu e tratar a escolha do usuário
function menu_escolha()
{
    while true; do
        menu=$(zenity --list \
          --title="Agendador de Tarefas - Menu" \
          --column="Opção" --column="Descrição" \
          1 "Agendar uma tarefa" \
          2 "Deletar uma tarefa" \
          3 "Listar tarefas" \
          4 "Sair"
        )

        # Verifica a escolha do usuário
        case $menu in
            1)
                faz_tarefa
                ;;
            2)
                deletar_tarefa
                ;;
            3)  
                visualizar_tarefas
                ;;
            4)  
                echo "Programa fechado com sucesso!"
                exit 0
                ;;
            *)
                # Se o usuário fechar a janela ou cancelar, o menu será exibido novamente
                if [ -z "$menu" ]; then
                    echo "Nenhuma opção foi selecionada. Retornando ao menu"
                else
                    echo "Opção inválida!"
                fi
                ;;
        esac
    done
}

# Executa o menu
menu_escolha
