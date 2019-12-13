; CRIADORES:

; Guilherme Filipe Feitosa dos Santos - 11275092
; Leila Gomes Ferreira                - 11218581


;---- Inicio do Programa Principal -----

; GLOBAIS
; r4 -> Linha inicial da tela a ser impressa
; r2 -> Cor da tela a ser impressa
; r6 -> Parâmetro de inicio do buraco atual
; r7 -> Fase atual

main:
	call ImprimeTelaInicial
	call AguardaEntradaEspaco
	call ImprimeInstrucoes
	
	fase0:
		loadn r7, #1 ; Contabiliza na fase 0
		loadn r4, #buraco0Linha0		
		loadn r2, #1280
		loadn r6, #184 			
		mov r0, r7
		call JogarFase
		cmp r7, r0
		jgr fase1
		jmp fase0
		
	fase1:
		loadn r4, #buraco1Linha0		
		loadn r2, #1280
		loadn r6, #775	 		
		mov r0, r7
		call JogarFase
		cmp r7, r0
		jgr fase2
		jmp fase0
		
	fase2:
		loadn r4, #buraco2Linha0		
		loadn r2, #1280
		loadn r6, #127	 		
		mov r0, r7
		call JogarFase
		cmp r7, r0
		jgr fase3
		jmp fase0
		
	fase3:
		loadn r4, #buraco3Linha0		
		loadn r2, #1280
		loadn r6, #986	 		
		mov r0, r7
		call JogarFase
		cmp r7, r0
		jgr fase4
		jmp fase0
		
	fase4:
		loadn r4, #buraco4Linha0		
		loadn r2, #1280
		loadn r6, #405	 		
		mov r0, r7
		call JogarFase
		cmp r7, r0
		jgr fim
		jmp fase0
		
	fim:
		loadn r4, #TelaFinalLinha0		
		loadn r2, #3584
		call AguardaEntradaEspaco
		call ImprimeTelaLimpando
		jmp fase0
	
halt

;---- Fim do Programa Principal -----

;---- Inicio das Subrotinas -----

JogarFase:
	call AguardaEntradaEspaco
	call ImprimeTelaLimpando
	call Bolinha
	rts

AguardaEntradaEspaco:
	push r0
	push r1
	loadn r0, #' '		; Espera que a tecla 'space' seja digitada para iniciar o jogo
	
	AguardaEntradaEspacoLoop:
		call DigLetra 		; Le uma letra
		load r1, Letra
		cmp r0, r1
		jne AguardaEntradaEspacoLoop
		
	pop r1
	pop r0
	rts
	
DigLetra:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push r0
	push r1
	loadn r0, #255
	loadn r1, #255	; Se nao digitar nada vem 255

   	DigLetra_Loop:
		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			; Compara r0 com 255
		jeq DigLetra_Loop	; Fica lendo ate' que digite uma tecla valida

	store Letra, r0			; Salva a tecla na variavel global "Letra"
	pop r1
	pop r0
	rts
	
Letra: var #' '
	
Bolinha:
	push r0	; Registrador auxiliar usada para cálculos
	push r2	; Registrador auxiliar usada para armazenar parâmetros de cálculo e comparação
	push r5	; Posição onde a bolinha será colocada e posteriormente retirada
	loadn r5, #1 ;Posição inicial

	BolinhaDesceDireita:
		inc r5
		mov r0, r7
		call MovimentaVerificando
		cmp r0, r7
		jne BolinhaSai
		loadn r0, #1160
		cmp r5, r0
		jeq BolinhaDesceEsquerda
		jgr BolinhaSobeDireita
		loadn r2, #40
		add r5, r5, r2
		mov r0, r5
		inc r0
		mod r0, r0, r2
		loadn r2, #0
		cmp r0, r2
		jz BolinhaDesceEsquerda
		jmp BolinhaDesceDireita

	BolinhaDesceEsquerda:
		dec r5
		mov r0, r7
		call MovimentaVerificando
		cmp r0, r7
		jne BolinhaSai
		loadn r0, #1160
		cmp r5, r0
		jeq BolinhaDesceDireita
		jgr BolinhaSobeEsquerda
		loadn r2, #40
		add r5, r5, r2
		mov r0, r5
		mod r0, r0, r2
		loadn r2, #0
		cmp r0, r2
		jz BolinhaDesceDireita
		jmp BolinhaDesceEsquerda

	BolinhaSobeDireita:
		inc r5
		mov r0, r7
		call MovimentaVerificando
		cmp r0, r7
		jne BolinhaSai
		loadn r0, #40
		cmp r5, r0
		jel BolinhaDesceDireita
		loadn r2, #40
		sub r5, r5, r2
		mov r0, r5
		inc r0
		mod r0, r0, r2
		loadn r2, #0
		cmp r0, r2
		jz BolinhaSobeEsquerda
		jmp BolinhaSobeDireita


	BolinhaSobeEsquerda:
		dec r5
		mov r0, r7
		call MovimentaVerificando
		cmp r0, r7
		jne BolinhaSai
		loadn r0, #39
		cmp r5, r0
		jel BolinhaDesceEsquerda
		loadn r2, #40
		sub r5, r5, r2
		mov r0, r5
		mod r0, r0, r2
		loadn r2, #0
		cmp r0, r2
		jz BolinhaSobeDireita
		jmp BolinhaSobeEsquerda

	BolinhaSai:
		pop r5
		pop r2
		pop r0
		rts
		
MovimentaVerificando:		;Função auxiliar para movimentar adequadamente a bolinha e conferir se a tecla ESPAÇO foi pressionada
	push r0	; Registrador auxiliar usada para rmazenar entrada fornecida pelo jogador
	push r1 ; Registrador auxiliar usada para verificar critério de parada
	push r2	; Registrador auxiliar que guarda parâmetro de posição da tela da fase a ser restaurada
	push r3
	loadn r1, #' '
	loadn r3, #'O'
	
	outchar r3, r5
	call Delay
	inchar r0
	cmp r0, r1
	ceq VerificaPos
	jeq MovimentaVerificandoSai
	
	Movimenta:
		mov r2, r4
		add r2, r2, r5
		loadn r0, #40
		div r0, r5, r0
		add r2, r2, r0
		loadn r0, #1280
		loadi r2, r2
		add r2, r2, r0
		outchar r2, r5
		
	MovimentaVerificandoSai:
		pop r3
		pop r2
		pop r1
		pop r0
		rts

VerificaPos:	; Verifica se a posicao da bolinha quando o space foi apertado era dentro do buraco ou nao; r5 está com a posicao da bolinha
	push r1		; Registrador auxiliar usado para avaliar posição relativa entre a bolinha e o buraco
	push r2		; Registrador auxiliar usado para cálculos
	push r3		; Registrador auxiliar usado para contabilizar Loop
	push r4		; Registrador auxiliar usado para limitar Loop
	push r5		; Posição atual da bolinha
	mov r1, r6	; inicio do buraco
	loadn r3, #5	; Contador do Loop com relação à altura do buraco (5 linhas)
	loadn r4, #0

	VerificaPosLoop:
		cmp r5, r1
		jle VerificaPosImprimeTelaErro
		loadn r2, #6
		add r1, r1, r2
		cmp r5, r1
		jle VerificaPosImprimeTelaSucesso
		loadn r2, #34
		add r1, r1, r2
		dec r3
		cmp r3, r4
		jgr VerificaPosLoop
				
	VerificaPosImprimeTelaErro:
		loadn r4, #TelaErroLinha0 		; Define como parâmetro início da tela de erro
		loadn r2, #2304					; Define cor vermelha da tela a ser exibida
		loadn r7, #0					; Inicia jogo na fase 0
		jmp VerificaPosSai
		
	VerificaPosImprimeTelaSucesso:
		loadn r4, #TelaSucessoLinha0 	; Define como parâmetro início da tela de sucesso
		loadn r2, #512					; Define cor verde da tela a ser exibida
		inc r7							; Pula para a próxima fase
		
	VerificaPosSai:
		call ImprimeTelaLimpando	
		pop r5
		pop r4
		pop r3
		pop r2
		pop r1
		rts

ImprimeTelaInicial:
	push r4
	push r2
	loadn r4, #parte0TelaInicial0
	loadn r2, #3584
	call ImprimeTela
	loadn r4, #parte1TelaInicial0
	loadn r2, #0
	call ImprimeTela
	pop r2
	pop r4

	rts
	
ImprimeInstrucoes:
	push r4
	push r2
	loadn r4, #Instrucoes0Linha0
	loadn r2, #3584
	call ImprimeTelaLimpando
	loadn r4, #Instrucoes1Linha0
	loadn r2, #0
	call ImprimeTela
	loadn r4, #Instrucoes2Linha0
	loadn r2, #1280
	call ImprimeTela
	pop r2
	pop r4

	rts
	
ImprimeTela: 	; Rotina de Impresao de Cenario na Tela Inteira que apenas subescreve posições com conteúdo / r1 = endereco onde comeca a primeira linha do Cenario / r2 = cor do Cenario para ser impresso
	push r0 ; protege o r3 na pilha para ser usado na subrotina
	push r1 ; protege o r1 na pilha para preservar seu valor
	push r2 ; protege o r1 na pilha para preservar seu valor
	push r3 ; protege o r3 na pilha para ser usado na subrotina
	push r5 ; protege o r4 na pilha para ser usado na subrotina

	mov r1, r4
	loadn r0, #0   	; posicao inicial tem que ser o comeco da tela!
	loadn r3, #40   ; Incremento da posicao da tela!
	loadn r5, #1200 ; Limite da tela!

	ImprimeTelaLoop:
		call ImprimeStr
		add r0, r0, r3   ; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r3
		inc r1  ; Incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5 ; Compara r0 com 1200
		jne ImprimeTelaLoop ; Enquanto r0 < 1200

	ImprimeTelaSai:
		pop r5 ; Resgata os valores dos registradores utilizados na Subrotina da Pilha
		pop r3
		pop r2
		pop r1
		pop r0
		rts

ImprimeTelaLimpando: 	; Rotina de Impresao de Cenario na Tela Inteira / r1 = endereco onde comeca a primeira linha do Cenario / r2 = cor do Cenario para ser impresso
	push r0 ; protege o r3 na pilha para ser usado na subrotina
	push r1 ; protege o r1 na pilha para preservar seu valor
	push r2 ; protege o r1 na pilha para preservar seu valor
	push r3 ; protege o r3 na pilha para ser usado na subrotina
	push r5 ; protege o r4 na pilha para ser usado na subrotina

	mov r1, r4
	loadn r0, #0   	; Posicao inicial tem que ser o comeco da tela!
	loadn r3, #40   ; Incremento da posicao da tela!
	loadn r5, #1200 ; Limite da tela!

	ImprimeTelaLimpandoLoop:
		call ImprimeStrLimpando
		add r0, r0, r3   	; Incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r3
		inc r1   			; Incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5 			; Compara r0 com 1200
		jne ImprimeTelaLimpandoLoop ; Enquanto r0 < 1200

	ImprimeTelaLimpandoSai:
		pop r5 ; Resgata os valores dos registradores utilizados na Subrotina da Pilha
		pop r3
		pop r2
		pop r1
		pop r0
		rts

ImprimeStr: ; Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0 ; protege o r0 na pilha para preservar seu valor
	push r1 ; protege o r1 na pilha para preservar seu valor
	push r2 ; protege o r2 na pilha para preservar seu valor
	push r3 ; protege o r3 na pilha para ser usado na subrotina
	push r4 ; protege o r4 na pilha para ser usado na subrotina
	push r5

	loadn r3, #'\0' ; Criterio de parada
	loadn r5, #' ' ; Criterio de desvio

	ImprimeStrLoop:
		loadi r4, r1
		cmp r4, r3 ; If (Char == \0)  Vai embora
		jeq ImprimeStrSai
		cmp r4, r5 ; If (Char == ' ')  Desvia
		jeq ImprimeStrDesvio
		add r4, r2, r4 ; Soma a Cor
		outchar r4, r0 ; Imprime o caractere na tela
	ImprimeStrDesvio:
		inc r0 ; Incrementa a posicao na tela
		inc r1 ; Incrementa o ponteiro da String
		jmp ImprimeStrLoop

	ImprimeStrSai:
		pop r5
		pop r4 ; Resgata os valores dos registradores utilizados na Subrotina da Pilha
		pop r3
		pop r2
		pop r1
		pop r0
		rts

ImprimeStrLimpando: ;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0 ; protege o r0 na pilha para preservar seu valor
	push r1 ; protege o r1 na pilha para preservar seu valor
	push r2 ; protege o r2 na pilha para preservar seu valor
	push r3 ; protege o r3 na pilha para ser usado na subrotina
	push r4 ; protege o r4 na pilha para ser usado na subrotina

	loadn r3, #'\0' ; Criterio de parada

	ImprimeStrLimpandoLoop:
		loadi r4, r1
		cmp r4, r3 ; If (Char == \0)  Vai embora
		jeq ImprimeStrLimpandoSai
		add r4, r2, r4 ; Soma a Cor
		outchar r4, r0 ; Imprime o caractere na tela
		inc r0 ; Incrementa a posicao na tela
		inc r1 ; Incrementa o ponteiro da String
		jmp ImprimeStrLimpandoLoop

	ImprimeStrLimpandoSai:
		pop r4 ; Resgata os valores dos registradores utilizados na Subrotina da Pilha
		pop r3
		pop r2
		pop r1
		pop r0
		rts
	
Delay: 					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	push r0
	push r1

	loadn r1, #20 ;a
	Delay2:
		loadn r0, #80000 ;b
		Delay1:
			dec r0
			jnz Delay1
		dec r1
		jnz Delay2

	pop r1
	pop r0
	rts

;---- Fim das Subrotinas -----

;---------------------------------------------------------------
; TELA INICIAL - PARTE 0
;---------------------------------------------------------------

parte0TelaInicial0  : string "                                        "
parte0TelaInicial1  : string "                                        "
parte0TelaInicial2  : string "                                        "
parte0TelaInicial3  : string "                                        "
parte0TelaInicial4  : string "           ___________________          "
parte0TelaInicial5  : string "           |                 |          "
parte0TelaInicial6  : string "           |   QUASE GOLFE   |          "
parte0TelaInicial7  : string "           |_________________|          "
parte0TelaInicial8  : string "                                        "
parte0TelaInicial9  : string "                                        "
parte0TelaInicial10 : string "     PRESSIONE ESPACO PARA INICIAR      "
parte0TelaInicial11 : string "                                        "
parte0TelaInicial12 : string "                                        "
parte0TelaInicial13 : string "                                        "
parte0TelaInicial14 : string "                                        "
parte0TelaInicial15 : string "                                        "
parte0TelaInicial16 : string "                                        "
parte0TelaInicial17 : string "                                        "
parte0TelaInicial18 : string "                                        "
parte0TelaInicial19 : string "                                        "
parte0TelaInicial20 : string "                                        "
parte0TelaInicial21 : string "                                        "
parte0TelaInicial22 : string "                                        "
parte0TelaInicial23 : string "                                        "
parte0TelaInicial24 : string "                                        "
parte0TelaInicial25 : string "                                        "
parte0TelaInicial26 : string "                                        "
parte0TelaInicial27 : string "                                        "
parte0TelaInicial28 : string "                                        "
parte0TelaInicial29 : string "                                        "

;---------------------------------------------------------------
; TELA INICIAL - PARTE 1
;---------------------------------------------------------------

parte1TelaInicial0  : string "                                        "
parte1TelaInicial1  : string "                                        "
parte1TelaInicial2  : string "                                        "
parte1TelaInicial3  : string "                                        "
parte1TelaInicial4  : string "                                        "
parte1TelaInicial5  : string "                                        "
parte1TelaInicial6  : string "                                        "
parte1TelaInicial7  : string "                                        "
parte1TelaInicial8  : string "                                        "
parte1TelaInicial9  : string "                                        "
parte1TelaInicial10 : string "                                        "
parte1TelaInicial11 : string "                                        "
parte1TelaInicial12 : string "      ~                                 "
parte1TelaInicial13 : string "      ~                                 "
parte1TelaInicial14 : string "      ~                                 "
parte1TelaInicial15 : string "      ~                                 "
parte1TelaInicial16 : string "      ~                                 "
parte1TelaInicial17 : string "      ~                                 "
parte1TelaInicial18 : string "      ~                                 "
parte1TelaInicial19 : string "      ~                                 "
parte1TelaInicial20 : string "      ~                                 "
parte1TelaInicial21 : string "      ~                                 "
parte1TelaInicial22 : string "      ~                                 "
parte1TelaInicial23 : string "      OOOO                              "
parte1TelaInicial24 : string "      OOOOOO                            "
parte1TelaInicial25 : string "      OOOOOOO                           "
parte1TelaInicial26 : string "       OOOOO                            "
parte1TelaInicial27 : string "                                        "
parte1TelaInicial28 : string "                                        "
parte1TelaInicial29 : string "                                        "

;---------------------------------------------------------------
; TELA DE INSTRUÇÕES - PARTE 0
;---------------------------------------------------------------

Instrucoes0Linha0  : string "                                        "
Instrucoes0Linha1  : string "                                        "
Instrucoes0Linha2  : string "               INSTRUCOES               "
Instrucoes0Linha3  : string "                                        "
Instrucoes0Linha4  : string "                                        "
Instrucoes0Linha5  : string "                                        "
Instrucoes0Linha6  : string "                                        "
Instrucoes0Linha7  : string "                                        "
Instrucoes0Linha8  : string "                                        "
Instrucoes0Linha9  : string "                                        "
Instrucoes0Linha10 : string "                                        "
Instrucoes0Linha11 : string "                                        "
Instrucoes0Linha12 : string "                                        "
Instrucoes0Linha13 : string "                                        "
Instrucoes0Linha14 : string "                                        "
Instrucoes0Linha15 : string "                                        "
Instrucoes0Linha16 : string "                                        "
Instrucoes0Linha17 : string "                                        "
Instrucoes0Linha18 : string "                                        "
Instrucoes0Linha19 : string "                                        "
Instrucoes0Linha20 : string "                                        "
Instrucoes0Linha21 : string "                                        "
Instrucoes0Linha22 : string "                                        "
Instrucoes0Linha23 : string "               BOM JOGO!                "
Instrucoes0Linha24 : string "                                        "
Instrucoes0Linha25 : string "                                        "
Instrucoes0Linha26 : string "     PRESSIONE 'ESPACO' PARA JOGAR      "
Instrucoes0Linha27 : string "                                        "
Instrucoes0Linha28 : string "                                        "
Instrucoes0Linha29 : string "                                        "

;---------------------------------------------------------------
; TELA DE INSTRUÇÕES - PARTE 1
;---------------------------------------------------------------

Instrucoes1Linha0  : string "                                        "
Instrucoes1Linha1  : string "                                        "
Instrucoes1Linha2  : string "                                        "
Instrucoes1Linha3  : string "                                        "
Instrucoes1Linha4  : string "                                        "
Instrucoes1Linha5  : string "         PARA JOGAR QUASE GOLFE         "
Instrucoes1Linha6  : string "         VOCE PRECISA ACERTAR A         "
Instrucoes1Linha7  : string "            BOLINHA NO BURACO           "
Instrucoes1Linha8  : string "                                        "
Instrucoes1Linha9  : string "                                        "
Instrucoes1Linha10 : string "       PARA ISSO, APERTE 'ESPACO'       "
Instrucoes1Linha11 : string "        QUANDO A BOLINHA ESTIVER        "
Instrucoes1Linha12 : string "            DENTRO DO BURACO            "
Instrucoes1Linha13 : string "                                        "
Instrucoes1Linha14 : string "                                        "
Instrucoes1Linha15 : string "                                        "
Instrucoes1Linha16 : string "                                        "
Instrucoes1Linha17 : string "                                        "
Instrucoes1Linha18 : string "                                        "
Instrucoes1Linha19 : string "                                        "
Instrucoes1Linha20 : string "                                        "
Instrucoes1Linha21 : string "                                        "
Instrucoes1Linha22 : string "                                        "
Instrucoes1Linha23 : string "                                        "
Instrucoes1Linha24 : string "                                        "
Instrucoes1Linha25 : string "                                        "
Instrucoes1Linha26 : string "                                        "
Instrucoes1Linha27 : string "                                        "
Instrucoes1Linha28 : string "                                        "
Instrucoes1Linha29 : string "                                        "

;---------------------------------------------------------------
; TELA DE INSTRUÇÕES - PARTE 2
;---------------------------------------------------------------

Instrucoes2Linha0  : string "                                        "
Instrucoes2Linha1  : string "                                        "
Instrucoes2Linha2  : string "                                        "
Instrucoes2Linha3  : string "                                        "
Instrucoes2Linha4  : string "                                        "
Instrucoes2Linha5  : string "                                        "
Instrucoes2Linha6  : string "                                        "
Instrucoes2Linha7  : string "                                        "
Instrucoes2Linha8  : string "                                        "
Instrucoes2Linha9  : string "                                        "
Instrucoes2Linha10 : string "                                        "
Instrucoes2Linha11 : string "                                        "
Instrucoes2Linha12 : string "                                        "
Instrucoes2Linha13 : string "                                        "
Instrucoes2Linha14 : string "                                        "
Instrucoes2Linha15 : string "              SERAO 5 FASES             "
Instrucoes2Linha16 : string "                                        "
Instrucoes2Linha17 : string "                                        "
Instrucoes2Linha18 : string "      SE VOCE PERDER, VOLTARA PARA      "
Instrucoes2Linha19 : string "             A FASE INICIAL             "
Instrucoes2Linha20 : string "                                        "
Instrucoes2Linha21 : string "                                        "
Instrucoes2Linha22 : string "                                        "
Instrucoes2Linha23 : string "                                        "
Instrucoes2Linha24 : string "                                        "
Instrucoes2Linha25 : string "                                        "
Instrucoes2Linha26 : string "                                        "
Instrucoes2Linha27 : string "                                        "
Instrucoes2Linha28 : string "                                        "
Instrucoes2Linha29 : string "                                        "



;---------------------------------------------------------------
; PARÂMETRO AUXILIAR E TELA DA FASE 0
;---------------------------------------------------------------

;buraco0Init : var #184 

buraco0Linha0  : string "                                        "
buraco0Linha1  : string "                                        "
buraco0Linha2  : string "                                        "
buraco0Linha3  : string "                                        "
buraco0Linha4  : string "                        ____            "
buraco0Linha5  : string "                       |    |           "
buraco0Linha6  : string "                       |    |           "
buraco0Linha7  : string "                       |    |           "
buraco0Linha8  : string "                       |____|           "
buraco0Linha9  : string "                                        "
buraco0Linha10 : string "                                        "
buraco0Linha11 : string "                                        "
buraco0Linha12 : string "                                        "
buraco0Linha13 : string "                                        "
buraco0Linha14 : string "                                        "
buraco0Linha15 : string "                                        "
buraco0Linha16 : string "                                        "
buraco0Linha17 : string "                                        "
buraco0Linha18 : string "                                        "
buraco0Linha19 : string "                                        "
buraco0Linha20 : string "                                        "
buraco0Linha21 : string "                                        "
buraco0Linha22 : string "                                        "
buraco0Linha23 : string "                                        "
buraco0Linha24 : string "                                        "
buraco0Linha25 : string "                                        "
buraco0Linha26 : string "                                        "
buraco0Linha27 : string "                                        "
buraco0Linha28 : string "                                        "
buraco0Linha29 : string "                                        "

;---------------------------------------------------------------
; PARÂMETRO AUXILIAR E TELA DA FASE 1
;---------------------------------------------------------------

;buraco1Init : var #775 

buraco1Linha0  : string "                                        "
buraco1Linha1  : string "                                        "
buraco1Linha2  : string "                                        "
buraco1Linha3  : string "                                        "
buraco1Linha4  : string "                                        "
buraco1Linha5  : string "                                        "
buraco1Linha6  : string "                                        "
buraco1Linha7  : string "                                        "
buraco1Linha8  : string "                                        "
buraco1Linha9  : string "                                        "
buraco1Linha10 : string "                                        "
buraco1Linha11 : string "                                        "
buraco1Linha12 : string "                                        "
buraco1Linha13 : string "                                        "
buraco1Linha14 : string "                                        "
buraco1Linha15 : string "                                        "
buraco1Linha16 : string "                                        "
buraco1Linha17 : string "                                        "
buraco1Linha18 : string "                                        "
buraco1Linha19 : string "               ____                     "
buraco1Linha20 : string "              |    |                    "
buraco1Linha21 : string "              |    |                    "
buraco1Linha22 : string "              |    |                    "
buraco1Linha23 : string "              |____|                    "
buraco1Linha24 : string "                                        "
buraco1Linha25 : string "                                        "
buraco1Linha26 : string "                                        "
buraco1Linha27 : string "                                        "
buraco1Linha28 : string "                                        "
buraco1Linha29 : string "                                        "

;---------------------------------------------------------------
; PARÂMETRO AUXILIAR E TELA DA FASE 2
;---------------------------------------------------------------

;buraco2Init : var #127 

buraco2Linha0  : string "                                        "
buraco2Linha1  : string "                                        "
buraco2Linha2  : string "                                        "
buraco2Linha3  : string "       ____                             "
buraco2Linha4  : string "      |    |                            "
buraco2Linha5  : string "      |    |                            "
buraco2Linha6  : string "      |    |                            "
buraco2Linha7  : string "      |____|                            "
buraco2Linha8  : string "                                        "
buraco2Linha9  : string "                                        "
buraco2Linha10 : string "                                        "
buraco2Linha11 : string "                                        "
buraco2Linha12 : string "                                        "
buraco2Linha13 : string "                                        "
buraco2Linha14 : string "                                        "
buraco2Linha15 : string "                                        "
buraco2Linha16 : string "                                        "
buraco2Linha17 : string "                                        "
buraco2Linha18 : string "                                        "
buraco2Linha19 : string "                                        "
buraco2Linha20 : string "                                        "
buraco2Linha21 : string "                                        "
buraco2Linha22 : string "                                        "
buraco2Linha23 : string "                                        "
buraco2Linha24 : string "                                        "
buraco2Linha25 : string "                                        "
buraco2Linha26 : string "                                        "
buraco2Linha27 : string "                                        "
buraco2Linha28 : string "                                        "
buraco2Linha29 : string "                                        "

;---------------------------------------------------------------
; PARÂMETRO AUXILIAR E TELA DA FASE 3
;---------------------------------------------------------------

;buraco3Init : var #986 

buraco3Linha0  : string "                                        "
buraco3Linha1  : string "                                        "
buraco3Linha2  : string "                                        "
buraco3Linha3  : string "                                        "
buraco3Linha4  : string "                                        "
buraco3Linha5  : string "                                        "
buraco3Linha6  : string "                                        "
buraco3Linha7  : string "                                        "
buraco3Linha8  : string "                                        "
buraco3Linha9  : string "                                        "
buraco3Linha10 : string "                                        "
buraco3Linha11 : string "                                        "
buraco3Linha12 : string "                                        "
buraco3Linha13 : string "                                        "
buraco3Linha14 : string "                                        "
buraco3Linha15 : string "                                        "
buraco3Linha16 : string "                                        "
buraco3Linha17 : string "                                        "
buraco3Linha18 : string "                                        "
buraco3Linha19 : string "                                        "
buraco3Linha20 : string "                                        "
buraco3Linha21 : string "                                        "
buraco3Linha22 : string "                                        "
buraco3Linha23 : string "                                        "
buraco3Linha24 : string "                          ____          "
buraco3Linha25 : string "                         |    |         "
buraco3Linha26 : string "                         |    |         "
buraco3Linha27 : string "                         |    |         "
buraco3Linha28 : string "                         |____|         "
buraco3Linha29 : string "                                        "

;---------------------------------------------------------------
; PARÂMETRO AUXILIAR E TELA DA FASE 4
;---------------------------------------------------------------

;buraco4Init : var #405 

buraco4Linha0  : string "                                        "
buraco4Linha1  : string "                                        "
buraco4Linha2  : string "                                        "
buraco4Linha3  : string "                                        "
buraco4Linha4  : string "                                        "
buraco4Linha5  : string "                                        "
buraco4Linha6  : string "                                        "
buraco4Linha7  : string "                                        "
buraco4Linha8  : string "                                        "
buraco4Linha9  : string "                                        "
buraco4Linha10 : string "     ____                               "
buraco4Linha11 : string "    |    |                              "
buraco4Linha12 : string "    |    |                              "
buraco4Linha13 : string "    |    |                              "
buraco4Linha14 : string "    |____|                              "
buraco4Linha15 : string "                                        "
buraco4Linha16 : string "                                        "
buraco4Linha17 : string "                                        "
buraco4Linha18 : string "                                        "
buraco4Linha19 : string "                                        "
buraco4Linha20 : string "                                        "
buraco4Linha21 : string "                                        "
buraco4Linha22 : string "                                        "
buraco4Linha23 : string "                                        "
buraco4Linha24 : string "                                        "
buraco4Linha25 : string "                                        "
buraco4Linha26 : string "                                        "
buraco4Linha27 : string "                                        "
buraco4Linha28 : string "                                        "
buraco4Linha29 : string "                                        "

;---------------------------------------------------------------
; BASE PARA NOVA FASE
;---------------------------------------------------------------

;buracoXInit : var #127 

buracoXLinha0  : string "                                        "
buracoXLinha1  : string "                                        "
buracoXLinha2  : string "                                        "
buracoXLinha3  : string "                                        "
buracoXLinha4  : string "                                        "
buracoXLinha5  : string "                                        "
buracoXLinha6  : string "                                        "
buracoXLinha7  : string "                                        "
buracoXLinha8  : string "                                        "
buracoXLinha9  : string "                                        "
buracoXLinha10 : string "                                        "
buracoXLinha11 : string "                                        "
buracoXLinha12 : string "                                        "
buracoXLinha13 : string "                                        "
buracoXLinha14 : string "                                        "
buracoXLinha15 : string "                                        "
buracoXLinha16 : string "                                        "
buracoXLinha17 : string "                                        "
buracoXLinha18 : string "                                        "
buracoXLinha19 : string "                                        "
buracoXLinha20 : string "                                        "
buracoXLinha21 : string "                                        "
buracoXLinha22 : string "                                        "
buracoXLinha23 : string "                                        "
buracoXLinha24 : string "                                        "
buracoXLinha25 : string "                                        "
buracoXLinha26 : string "                                        "
buracoXLinha27 : string "                                        "
buracoXLinha28 : string "                                        "
buracoXLinha29 : string "                                        "


;---------------------------------------------------------------
; TELA DE ERRO
;---------------------------------------------------------------

TelaErroLinha0  : string "                                        "
TelaErroLinha1  : string "                                        "
TelaErroLinha2  : string "                                        "
TelaErroLinha3  : string "                                        "
TelaErroLinha4  : string "                                        "
TelaErroLinha5  : string "                                        "
TelaErroLinha6  : string "                                        "
TelaErroLinha7  : string "                                        "
TelaErroLinha8  : string "                                        "
TelaErroLinha9  : string "                                        "
TelaErroLinha10 : string "                                        "
TelaErroLinha11 : string "        QUE PENA, VOCE ERROU :(         "
TelaErroLinha12 : string "                                        "
TelaErroLinha13 : string "                                        "
TelaErroLinha14 : string "      APERTE 'ESPACO' PARA VOLTAR       "
TelaErroLinha15 : string "                                        "
TelaErroLinha16 : string "                                        "
TelaErroLinha17 : string "                                        "
TelaErroLinha18 : string "                                        "
TelaErroLinha19 : string "                                        "
TelaErroLinha20 : string "                                        "
TelaErroLinha21 : string "                                        "
TelaErroLinha22 : string "                                        "
TelaErroLinha23 : string "                                        "
TelaErroLinha24 : string "                                        "
TelaErroLinha25 : string "                                        "
TelaErroLinha26 : string "                                        "
TelaErroLinha27 : string "                                        "
TelaErroLinha28 : string "                                        "
TelaErroLinha29 : string "                                        "

;---------------------------------------------------------------
; TELA DE SUCESSO
;---------------------------------------------------------------

TelaSucessoLinha0  : string "                                        "
TelaSucessoLinha1  : string "                                        "
TelaSucessoLinha2  : string "                                        "
TelaSucessoLinha3  : string "                                        "
TelaSucessoLinha4  : string "                                        "
TelaSucessoLinha5  : string "                                        "
TelaSucessoLinha6  : string "                                        "
TelaSucessoLinha7  : string "                                        "
TelaSucessoLinha8  : string "                                        "
TelaSucessoLinha9  : string "                                        "
TelaSucessoLinha10 : string "                                        "
TelaSucessoLinha11 : string "             VOCE ACERTOU!!             "
TelaSucessoLinha12 : string "                                        "
TelaSucessoLinha13 : string "                                        "
TelaSucessoLinha14 : string "     APERTE 'ESPACO' PARA CONTINUAR     "
TelaSucessoLinha15 : string "                                        "
TelaSucessoLinha16 : string "                                        "
TelaSucessoLinha17 : string "                                        "
TelaSucessoLinha18 : string "                                        "
TelaSucessoLinha19 : string "                                        "
TelaSucessoLinha20 : string "                                        "
TelaSucessoLinha21 : string "                                        "
TelaSucessoLinha22 : string "                                        "
TelaSucessoLinha23 : string "                                        "
TelaSucessoLinha24 : string "                                        "
TelaSucessoLinha25 : string "                                        "
TelaSucessoLinha26 : string "                                        "
TelaSucessoLinha27 : string "                                        "
TelaSucessoLinha28 : string "                                        "
TelaSucessoLinha29 : string "                                        "

;---------------------------------------------------------------
; TELA FINAL
;---------------------------------------------------------------

TelaFinalLinha0  : string "                                        "
TelaFinalLinha1  : string "                                        "
TelaFinalLinha2  : string "                                        "
TelaFinalLinha3  : string "                                        "
TelaFinalLinha4  : string "                                        "
TelaFinalLinha5  : string "                                        "
TelaFinalLinha6  : string "                                        "
TelaFinalLinha7  : string "                                        "
TelaFinalLinha8  : string "        VOCE GANHOU, PARABENS!!         "
TelaFinalLinha9  : string "                                        "
TelaFinalLinha10 : string "                                        "
TelaFinalLinha11 : string "                                        "
TelaFinalLinha12 : string "                                        "
TelaFinalLinha13 : string "                                        "
TelaFinalLinha14 : string "      CONTINUE ASSIM E VOCE VAI SE      "
TelaFinalLinha15 : string "          TORNAR UM MESTRE DO           "
TelaFinalLinha16 : string "              QUASE GOLFE               "
TelaFinalLinha17 : string "                                        "
TelaFinalLinha18 : string "                                        "
TelaFinalLinha19 : string "                                        "
TelaFinalLinha20 : string "                                        "
TelaFinalLinha21 : string "                                        "
TelaFinalLinha22 : string "                                        "
TelaFinalLinha23 : string "                                        "
TelaFinalLinha24 : string "                                        "
TelaFinalLinha25 : string "                                        "
TelaFinalLinha26 : string "                                        "
TelaFinalLinha27 : string "                                        "
TelaFinalLinha28 : string "                                        "
TelaFinalLinha29 : string "                                        "