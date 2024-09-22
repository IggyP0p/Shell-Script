#!/bin/bash
#
# tabela.sh (shell script)
#
# AUTOR: IggyP0p (github)
#
# Objetivo: monitorar letras, palavras e numeros mais comuns em arquivos
#
# Versao 1.0
#


#####################################
####Testando permissão de leitura####
#####################################

teste_leitura(){

ERRO=$(ls -l $1 | cut -c2)
if [ "$ERRO" != "r" ];
then
	echo -e "\033[31m \n ERRO: NAO E POSSIVEL LER O ARQUIVO \033[m"
	echo -e "\033[31m \n tentar mudar a permissao de leitura?[y/n] \033[m"
        read ANS

	if [ "$ANS" = "y" ];
	then
		chmod u+r $1

                ERRO=$(ls -l $1 | cut -c2)
                if [ "$ERRO" != "r" ];
                then
                	echo -e "\033[31m \n ERRO: NAO FOI POSSIVEL MUDAR A PERMISSAO DO ARQUIVO \033[m"
                        exit
                else
                        echo "permissão alterada com sucesso!"
                        sleep 2
                        clear
                fi

	else
        	echo "saindo do programa!"
                exit
        fi
fi

}


##########################################
####Loop infinito testando o hash code####
##########################################

loop_infinito(){

HASH_OLD=$(md5sum $1 | awk -F " " '{print $1}')
AUX=0

while [ $AUX -eq 0 ];
do
        HASH_NEW=$(md5sum $1 | awk -F " " '{print $1}')
        sleep 3
        if [ $HASH_OLD != $HASH_NEW ];
        then
		AUX=1
        fi

done

}


#########################################################################
#### EXIBE TODOS OS NUMEROS DE UM ARQUIVO E A QUANTIDADE DE CADA UMA ####
#########################################################################

funcao_contaNumero(){

        #Inicializando variaveis
        cont="0"
        N2="a"
	unset NUM

        teste_leitura $1

        #Pegando as palavras e as listando com a quantidade
	echo -e "\n----------------------------------------------------------------"
        while [ "$N2" != "$NUMERO" ];
        do
        	cont=$(( $cont + 1 ))
                N2=$NUMERO

                [[ -n $NUM ]] && echo -e "Numero:$NUMERO\t      | Freq: $NUM"

		if [ "$3" = "-i" ];
                then
                	VALOR=$(sed 's/[-%:@#$,.;?!a-zA-Z()]//g' $1 | sed 's/ /\n/g' |
                	sed '/^$/d' | sort -n | uniq -ic | sort -rn | tail -n $cont)
		else
			VALOR=$(sed 's/[-%:@#$,.;?!a-zA-Z()]//g' $1 | sed 's/ /\n/g' |
                        sed '/^$/d' | sort -n | uniq -ic | sort -n | tail -n $cont)
		fi

		NUM=$(echo $VALOR | awk -F " " '{ print $1 }')
                NUMERO=$(echo $VALOR | awk -F " " '{ print $2 }')

		[[ -z $2 ]] || if [ "$cont" -gt "$2" ];then
                                break
                               fi

	done
	echo -e "----------------------------------------------------------------\n"

	loop_infinito $1

        funcao_contaNumero $1 $2 $3

}


##########################################################################
#### EXIBE TODAS AS PALAVRAS DE UM ARQUIVO E A QUANTIDADE DE CADA UMA ####
##########################################################################

funcao_contaPalavra(){

	#Inicializando variaveis
	cont="0"
	P2="a"
	unset NUM

	teste_leitura $1

	#Pegando as palavras e as listando com a quantidade
	echo -e "\n----------------------------------------------------------------"
	while [ "$P2" != "$PALAVRA" ];
	do
		cont=$(( $cont + 1 ))
		P2=$PALAVRA

		[[ -n $NUM ]] && echo -e "Palavra:$PALAVRA\t      | Freq: $NUM"

		if [ "$3" = "-i" ];
                then
        		VALOR=$(sed 's/[-%:@#$,.;?!0-9()]//g' $1 | sed 's/ /\n/g' |
			sed '/^$/d' | sort -n | uniq -ic | sort -rn | tail -n $cont)
		else
			VALOR=$(sed 's/[-%:@#$,.;?!0-9()]//g' $1 | sed 's/ /\n/g' |
                        sed '/^$/d' | sort -n | uniq -ic | sort -n | tail -n $cont)
		fi

		NUM=$(echo $VALOR | awk -F " " '{ print $1 }')
        	PALAVRA=$(echo $VALOR | awk -F " " '{ print $2 }')

		[[ -z $2 ]] || if [ "$cont" -gt "$2" ];then
                                break
                               fi

	done
	echo -e "----------------------------------------------------------------\n"

	loop_infinito $1

        funcao_contaPalavra $1 $2 $3
}


########################################################################
#### EXIBE TODAS AS LETRAS DE UM ARQUIVO E A QUANTIDADE DE CADA UMA ####
########################################################################

funcao_contaLetra(){

	#Inicializando variaveis
        cont="0"
        L2="0"
	unset NUM

	teste_leitura $1

	echo -e "\n----------------------------------------------------------------"
        #Pegando as letras e as listando com a quantidade
        while [ "$L2" != "$LETRA" ];
        do
                cont=$(( $cont + 1 ))
                L2=$LETRA

                [[ -n $NUM ]] && echo -e "Letra:$LETRA\t      | Freq: $NUM"

		if [ "$3" = "-i" ];
		then
			VALOR=$(sed 's/[-%:@#$,.;?!0-9() ]//g' $1 | sed 's/./&\n/g' |
      			sort -n | uniq -ic | sed '1d' | sort -rn | tail -n $cont);
		else
			VALOR=$(sed 's/[-%:@#$,.;?!0-9() ]//g' $1 | sed 's/./&\n/g' |
      			sort -n | uniq -ic | sed '1d' | sort -n | tail -n $cont);
		fi


#                VALOR=$(sed 's/[-%:@#$,.;?!0-9() ]//g' $1 | sed 's/./&\n/g' |
#                 sort -n | uniq -ic | sed '1d' | sort -n | tail -n $cont)

                NUM=$(echo $VALOR | awk -F " " '{ print $1 }')
                LETRA=$(echo $VALOR | awk -F " " '{ print $2 }')

		[[ -z $2 ]] || if [ "$cont" -gt "$2" ];then
                                break
                               fi

        done
	echo -e "----------------------------------------------------------------\n"

	loop_infinito $1

	funcao_contaLetra $1 $2 $3
}


##########################################
################## CASE ##################
##########################################

[ -z "$1" ] && echo "Ofereça uma opção qualquer, use -h para obter ajuda" && exit 1

NOME_HELP="NOME\n\t
$(basename $0) [ -h | --help | -p | -n | -l | -i | <parametro> <arquivo> <numero> ]\n\t
"
DESCRICAO_HELP="DESCRIÇÃO\n\t
Esse shell script foi feito para gerar uma tabela com dados e a frequência em que esses dados
se repetem em arquivos, podendo esses dados ser palavras, numeros ou letras.\n\t
"
PARAMETROS_HELP="PARÂMETROS\n\t
	-h --help Exibe a tela de ajuda do script\n\t
	-p --palavras seleciona as palavras do arquivo para a tabela\n\t
	-n --numeros seleciona os numeros do arquivo para a tabela\n\t
	-l --letras seleciona cada letra do arquivo para a tabela\n\t
	-i inverte a ordem fazendo aparecer os dados com menor frequencia\n\t
	<numero> passar um numero limita quantos dados devem aparecer\n\t
"
EXEMPLOS_HELP="EXEMPLOS DE USO\n\t
	~$ histograma.sh -p <arquivo>\n\t
	~$ histograma.sh -n <arquivo>\n\t
	~$ histograma.sh -l <arquivo>\n\t
	~$ histograma.sh -ni <arquivo>\n\t
	~$ histograma.sh -li <arquivo> <numero>\n\t
	~$ histograma.sh -p <arquivo> <numero>\n\t
"

HELP="$NOME_HELP\n$DESCRICAO_HELP\n$PARAMETROS_HELP\n$EXEMPLOS_HELP"

case $1 in
        -h | --help) ##Exite as instruções do shell script
                echo -e $HELP
                exit 0
        ;;
        -p | --palavras) ##Ativa a função palavras
                funcao_contaPalavra $2 $3
        ;;
	-n | --numeros) ##Ativa a função numeros
		funcao_contaNumero $2 $3
	;;
	-l | --letras) ##Ativa a função letras
		funcao_contaLetra $2 $3
	;;
	-pi) ##Ativa o inverso de palavras
		[[ -z $3 ]] && funcao_contaPalavra $2 50 -i

		funcao_contaPalavra $2 $3 -i
	;;
	-ni) ##Ativa o inverso de numeros
		[[ -z $3 ]] && funcao_contaNumero $2 50 -i

		funcao_contaNumero $2 $3 -i
	;;
	-li) ##Ativa o inverso de letras
		[[ -z $3 ]] && funcao_contaLetra $2 50 -i

		funcao_contaLetra $2 $3 -i
	;;
        *) ## Erro, opção desconhecida
                echo "Erro: opcao $1 desconhecida"
                exit 1
esac
