#!/bin/bash

# shMTR - Rastreando rotas com estilo!
# Criado por Junovan Fantin em conjunto com Gemini 2.0 Flash

# Variáveis
timeout_padrao=100  # Timeout padrão
timeout=$timeout_padrao # Timeout inicial
num_testes=1 # Número de testes por IP
declare -A ip_data # Array associativo para dados de IP
salvar_resultados=false # Variável para controlar se os resultados serão salvos

# Função para calcular estatísticas de ping
calculate_ping_stats() {
    local ip=$1
    local total_time=0
    local lost_packets=0
    local sent_packets=0
    local last_ping="N/A"

    # Recupera dados existentes (se houver)
    if [[ -v ip_data[$ip] ]]; then
        IFS='|' read -r stored_total_time stored_lost_packets stored_sent_packets stored_last_ping <<< "${ip_data[$ip]}"
        total_time="$stored_total_time"
        lost_packets="$stored_lost_packets"
        sent_packets="$stored_sent_packets"
        last_ping="$stored_last_ping"
    fi

    # Loop de testes de ping
    for i in $(seq 1 $num_testes); do
        sent_packets=$((sent_packets + 1))
        ping_result=$(ping -c 1 -W 1 -t "$timeout" "$ip" | grep 'time=' | awk '{print $7}' | cut -d '=' -f 2)
        if [ -z "$ping_result" ]; then
            lost_packets=$((lost_packets + 1))
        else
            total_time=$(echo "$total_time + $ping_result" | bc)
            last_ping="$ping_result ms"
        fi
    done

    # Calcula estatísticas
    if [ "$sent_packets" -eq "$lost_packets" ]; then
        ip_data[$ip]="$total_time|$lost_packets|$sent_packets|$last_ping"
        average_time="N/A"
        loss_percentage="100.00"
    else
        average_time=$(echo "scale=2; $total_time / ( $sent_packets - $lost_packets )" | bc)
        loss_percentage=$(echo "scale=2; ($lost_packets / $sent_packets) * 100" | bc)
        ip_data[$ip]="$total_time|$lost_packets|$sent_packets|$last_ping"
    fi

    # Retorna resultados
    echo "$last_ping|$average_time ms|$sent_packets|$lost_packets ($loss_percentage%)"
}

# Função para exibir tabela de traceroute
update_table() {
    clear
    echo "shMTR - Rastreando rotas para $target_ip"
    echo "=================================================================================="
    printf "%-3s | %-15s | %-12s | %-11s | %-15s | %s\n" "Nº" "IP" "Último Ping" "Média Ping" "Pacotes Enviados" "Pacotes Perdidos"
    echo "----------------------------------------------------------------------------------"

    count=0
    ips=($(traceroute -n -m 20 "$target_ip" -q 1 -N 100 | awk '{print $2}' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"))

    for ip in "${ips[@]}"; do
        printf "%-3d | %-15s | " "$((++count))" "$ip"
        IFS='|' read -r last_ping average_time sent_packets lost_packets <<< "$(calculate_ping_stats "$ip")"
        printf "%-12s | %-11s | %-12s | %s\n" "$last_ping" "$average_time" "$sent_packets" "$lost_packets"
    done

    echo "=================================================================================="
}

# Função para salvar resultados em arquivo
save_results() {
    local target_ip=$1
    local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    local filename="shMTR-${timestamp}-${target_ip}.txt" # Nome do arquivo fixo

    # Captura a saída do comando update_table
    saida_tabela=$(update_table)

    # Escreve a saída capturada no arquivo
    echo "$saida_tabela" > "$filename"

    echo "Resultados salvos em $filename"
}

# Função para exibir tutorial de uso
exibir_tutorial() {
    echo "shMTR - Rastreie rotas com estilo!"
    echo "Uso: shMTR [IP] [OPÇÕES]"
    echo ""
    echo "Opções:"
    echo "-t <timeout>  Define o timeout para ping em ms (padrão: $timeout_padrao ms)"
    echo "-n <testes>   Define o número de testes por IP (padrão: 1)"
    echo "-s            Salva os resultados em um arquivo shMTR-DATA-IP.txt"
    echo "--help | -h   Exibe este tutorial"
    echo ""
    echo "Exemplos:"
    echo "shMTR 8.8.8.8 -t 200 -n 5 -s"
    echo "shMTR 192.168.1.1"
}

# Verifica argumentos de linha de comando
while [[ $# -gt 0 ]]; do
    case "$1" in
        -t)
            timeout="$2"
            shift 2
            ;;
        -n)
            num_testes="$2"
            shift 2
            ;;
        -s)
            salvar_resultados=true
            shift
            ;;
        --help|-h)
            exibir_tutorial
            exit 0
            ;;
        *)
            target_ip="$1"
            shift
            ;;
    esac
done

# Timeout padrão
if [[ -z "$timeout" ]]; then
    timeout="$timeout_padrao"
fi

# Loop para IP (se não fornecido na linha de comando)
if [[ -z "$target_ip" ]]; then
    while [[ -z "$target_ip" ]]; do
        read -p "Digite o IP para rastrear (ou pressione Ctrl+C para sair): " target_ip
        if [[ -z "$target_ip" ]]; then
            echo "Por favor, digite um IP válido."
        fi
    done
fi

# Pergunta se o usuário quer salvar o arquivo (se não especificado por parâmetro)
if [[ -z "$salvar_resultados" ]]; then
    read -p "Deseja salvar os resultados em shMTR-DATA-IP.txt? (s/n): " salvar
    if [[ "$salvar" == "s" || "$salvar" == "S" ]]; then
        salvar_resultados=true
    fi
fi

# Executa o rastreamento
update_table

# Salva resultados (se solicitado)
if [[ "$salvar_resultados" == true ]]; then
    save_results "$target_ip"
fi
