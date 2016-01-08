#!/bin/bash
# usuarios.sh - v1.0.1
#
# Mostra os logins e nomes de usuários do sistema
# Obs.: Lé dados do arquivo /etc/passwd
#
# ins3ct, Junho de 2015
#
 
# Variaveis
 
ordenar=0
inverter=0
maiusculas=0
delim='\t'
 
versao=$(grep '^# Versão ' $(basename $0) | tail -1 | cut -d : -f 1 | tr -d \#)
 
 
# Output
 
AJUDA="
OPÇÕES:
 
        -d, --delimiter C       Usa o caractere C como delimitador
        -r, --reverse           Inverte a listagem
        -s, --sort              Ordena a listagem alfabeticamente.
        -u, --uppercase         Mostra a listagem em MAIÚSCULAS
        -h, --help              Mostra a tela de ajuda.
        -V, --version           Mostra a versão do programa.
 
"
 
DADOS="
[+] $(basename $0) 1.0.3
 
# Versão 1.0.1: Mostra os logins/nomes de usuários do sistema
# Versão 1.0.2: Adicionado suporte -h
# Versão 1.0.3: Adicionado suporte -V e opções invalidas
# Versão 1.0.4: Arrumado bug quando não tem opções, basename
#               no nome do programa, -V extraindo direto dos cabeçalhos,
#               adicionadas opções --help e --version
# Versão 1.0.5: Adicionadas opções -s e --sort
# Versão 1.0.6: Adicionadas opções -r, --reverse, -u, --uppercase
#               leitura de múltiplas opções (loop)
# Versão 1.0.7: Melhorias no código para que fique mais legível,
#               adicionadas opções -d e --delimiter
 
[+] ins3ct, Junho 2015.
 
"
ERRO="
Opção inválida: $1
Para obter ajuda use: bash $(basename $0) --help
"
 
# Loop
 
while test -n "$1"
do
        case "$1" in
                -h | --help)
                        echo "$AJUDA"
                        exit 0
                ;;
 
                -V | --version)
                        echo "Versão do $(basename $0):$versao"
                        exit 0
                ;;
 
                # Chaves
                -s | --sort     ) ordenar=1    ;;
                -r | --reverse  ) inverter=1   ;;
                -u | --uppercase) maiusculas=1 ;;
 
                -d | --delimiter)      
                        shift
                        delim="$1"
                        if test -z "$delim"
                        then
                                echo "Faltou o argumento para a -d"
                                exit 1
                        fi
                ;;
 
                *)
                        if test -n "$1"
                        then
                                echo "$ERRO"
                                exit 0
                        fi
                ;;
        esac
        shift
done
 
# Extrai a listagem
lista=$(cut -d : -f 1,5 /etc/passwd)
 
# Ordena, inverte ou converte para maiúsculas (se necessário)
test "$ordenar"    = 1 && lista=$(echo "$lista" | sort)
test "$inverter"   = 1 && lista=$(echo "$lista" | tac)
test "$maiusculas" = 1 && lista=$(echo "$lista" | tr a-z A-Z)
 
# Mostra o resultado para o usuário
echo "$lista" | tr : "$delim"
