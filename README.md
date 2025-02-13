## shMTR - ShellMTR para Shell Script

Olá! 

Apresento o shMTR, um utilitário de linha de comando para rastreamento de rotas e testes de ping, totalmente compatível com Shell Script. Ele é inspirado no popular WinMTR, trazendo sua funcionalidade para o mundo do Shell Script.

### Funcionalidades

*   Rastreamento de rotas (traceroute)
*   Testes de ping múltiplos
*   Cálculo de estatísticas de ping (média, perda de pacotes)
*   Opção de timeout configurável
*   Interface de linha de comando interativa
*   Geração de relatórios

## Como usar 
    ```bash
    curl -sL https://raw.githubusercontent.com/junovanfantin/shMTR/refs/heads/main/shMTR.sh | bash -s -- <IP> -n <QTD TESTES> -t <TIMEOUT>
    ```
    
    Exemplo:
    ```bash
    curl -sL https://raw.githubusercontent.com/junovanfantin/shMTR/refs/heads/main/shMTR.sh | bash -s -- 8.8.8.8 -n 5 -t 200
    ```
    
    Para usar o modo Interativo é necessário baixar o script para realizar sua execução manual.

### Como usar manualmente

1.  Clone este repositório:

    ```bash
    git clone https://github.com/seu-nome-de-usuario/shMTR.git
    ```

2.  Navegue até o diretório:

    ```bash
    cd shMTR
    ```

3.  Dê permissão de execução:

    ```bash
    chmod +x shMTR.sh
    ```

4.  Execute o script:

    *   **Com argumentos:**

        ```bash
        ./shMTR.sh 8.8.8.8 -t 100 -n 5
        ```

        Este comando rastreia a rota para 8.8.8.8, usando um timeout de 100ms e realizando 5 testes de ping por IP.

    *   **Interativo:**

        ```bash
        ./shMTR.sh
        ```

        O script irá solicitar o IP e outras informações.

5.  **Exemplo de saída:**

    ```
    shMTR - Rastreando rotas para 8.8.8.8
    ==================================================================================
    Nº | IP              | Último Ping | Média Ping | Pacotes Enviados | Pacotes Perdidos
    ----------------------------------------------------------------------------------
    1   | 192.168.68.1    | 0.874 ms     | 2.46 ms     | 5            | 0 (0%)
    2   | 10.100.100.1    | N/A          | N/A ms      | 5            | 5 (100.00%)
    3   | 187.36.208.1    | 12.4 ms      | 13.54 ms    | 5            | 0 (0%)
    4   | 187.36.197.145  | 11.4 ms      | 12.06 ms    | 5            | 0 (0%)
    5   | 187.36.198.68   | 14.1 ms      | 12.28 ms    | 5            | 0 (0%)
    6   | 200.241.218.33  | 11.6 ms      | 13.20 ms    | 5            | 0 (0%)
    7   | 200.244.140.51  | 26.0 ms      | 24.84 ms    | 5            | 0 (0%)
    8   | 200.244.18.8    | 22.7 ms      | 27.42 ms    | 5            | 0 (0%)
    9   | 200.244.18.8    | 23.5 ms      | 24.02 ms    | 5            | 0 (0%)
    10  | 201.39.52.58    | 23.4 ms      | 24.28 ms    | 5            | 0 (0%)
    ==================================================================================
    ```

### Opções

*   `-t <timeout>`: Define o timeout para ping em ms (padrão: 100ms)
*   `-n <testes>`: Define o número de testes por IP (padrão: 1)
*   `-s`: Salva os resultados em um arquivo shMTR-DATA-IP.txt (padrão: não)
*   `--help | -h`: Exibe este tutorial

### Relatórios

Para gerar um relatório, pressione a opção "-ss" ao executar o script. O relatório será salvo em um arquivo com o nome `shMTR-DATA-IP.txt`.

### Contribuições

Sinta-se à vontade para enviar pull requests com melhorias e sugestões!

### Créditos

Este script foi criado por Junovan Fantin em conjunto com Gemini 2.0 Flash.
