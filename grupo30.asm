; *********************************************************************************
;  Grupo - 30
;
;  Diogo Pires - 99475
;  Tomás Teixeira - 104165
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************

DISPLAYS		EQU 0A000H

TECLA_0			EQU 0011H
TECLA_1			EQU 0012H
TECLA_2			EQU 0014H
TECLA_3			EQU 0018H
TECLA_4			EQU 0021H
TECLA_5			EQU 0022H
TECLA_6			EQU 0024H
TECLA_7			EQU 0028H
TECLA_8			EQU 0041H
TECLA_9			EQU 0042H
TECLA_A			EQU 0044H
TECLA_B			EQU 0048H
TECLA_C			EQU 0081H
TECLA_D			EQU 0082H
TECLA_E			EQU 0084H
TECLA_F			EQU 0088H

TEC_LIN					EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL					EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
LINHA_TECLADO			EQU 1		; linha a testar (4ª linha, 1000b)
MASCARA					EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_ESQUERDA			EQU 0		; tecla na primeira coluna do teclado (tecla C)
TECLA_DIREITA			EQU 2		; tecla na segunda coluna do teclado (tecla D)

DEFINE_LINHA    		EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H      ; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 			EQU 6002H      ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO EQU 6042H      ; endereço do comando para selecionar uma imagem de fundo
SELECIONA_ECRA			EQU 6004H	   ; endereço do comando para selecionar o ecrã
TOCA_SOM				EQU 605AH      ; endereço do comando para tocar um som
PARA_SOM				EQU 605EH	   ; endereço do comando para parar um som
VOLUME_SOM				EQU 604AH	   ; endereço do comando para volume de um som

ULTIMA_LINHA			EQU 31		   ; valor da última linha do ecrã

LINHA_ROVER     		EQU  28        ; linha do rover (a meio do ecrã))
COLUNA_ROVER			EQU  30        ; coluna do rover (a meio do ecrã)

MIN_COLUNA				EQU  0			; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA				EQU  63			; número da coluna mais à direita que o objeto pode ocupar
ATRASO					EQU	 1000H		; atraso para limitar a velocidade de movimento do rover
ATRASO_EXPLOSAO			EQU	 8000H		; atraso para desenhar a explosão da tela

LARGURA_TIRO			EQU 1			; largura do tiro
ALTURA_TIRO				EQU 1			; altura do tiro
COR_PIXEL_TIRO			EQU 0F0FFH		; cor do pixel do tiro
ATIVADO					EQU 0			; define se o tiro existe na tela ou não

LARGURA_ROVER			EQU	5			; largura do rover
ALTURA_ROVER			EQU 4			; altura do rover
COR_PIXEL_ROVER			EQU	0FF00H		; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)

LARGURA_EXPLOSAO		EQU 5			; largura da explosao
ALTURA_EXPLOSAO			EQU 5			; altura da explosao
COR_PIXEL_EXPLOSAO		EQU 0C0EEH		; cor do pixel: azul claro em ARGB

LARGURA_METEORO_1		EQU 1			; largura do meteoro
ALTURA_METEORO_1		EQU 1			; altura do meteoro

LARGURA_METEORO_2		EQU 2			; largura do meteoro
ALTURA_METEORO_2		EQU 2			; altura do meteoro

LARGURA_METEORO_3		EQU 3			; largura do meteoro
ALTURA_METEORO_3		EQU 3			; altura do meteoro

LARGURA_METEORO_4		EQU 4			; largura do meteoro
ALTURA_METEORO_4		EQU 4			; altura do meteoro

LARGURA_METEORO_5		EQU 5			; largura do meteoro
ALTURA_METEORO_5		EQU 5			; altura do meteoro
COR_PIXEL_METEORO		EQU 0F0F0H		; cor do pixel: verde em ARGB (opaco e verde no máximo, vermelho e azil a 0)

COR_PIXEL_CINZENTO		EQU 0C777H		; cor do pixel cinzento

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H
pilha:
	STACK 100H			; espaço reservado para a pilha 
						; (200H bytes, pois são 100H words)
SP_inicial:				; este é o endereço (1200H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11FEH (1200H-2)
	STACK 100H			; espaço reservado para a pilha do teclado
SP_inicial_teclado:
	
	STACK 100H			; espaço reservado para a pilha dos meteoros
SP_inicial_meteoro:
	
	STACK 100H			; espaço reservado para a pilha do tiro
SP_inicial_tiro:

	STACK 100H			; espaço reservado para a pilha da energia
SP_inicial_energia:


DEF_TIRO:						; tabela que define o tiro (largura, altura, cor, estado)
	WORD		LARGURA_TIRO
	WORD		ALTURA_TIRO
	WORD		COR_PIXEL_TIRO
	WORD		ATIVADO


DEF_ROVER:						; tabela que define o rover (cor, largura, altura, pixels)
	WORD		LARGURA_ROVER
	WORD		ALTURA_ROVER
	WORD		0, 0, COR_PIXEL_ROVER, 0, 0		
	WORD		COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER
	WORD		COR_PIXEL_ROVER, COR_PIXEL_ROVER, COR_PIXEL_ROVER, COR_PIXEL_ROVER, COR_PIXEL_ROVER
	WORD		0, COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER, 0


DEF_EXPLOSAO:					; tabela que define a explosão (cor, largura, altura, pixels)
	WORD		LARGURA_EXPLOSAO
	WORD		ALTURA_EXPLOSAO
	WORD		0, COR_PIXEL_EXPLOSAO, 0, COR_PIXEL_EXPLOSAO, 0
	WORD		COR_PIXEL_EXPLOSAO, 0, COR_PIXEL_EXPLOSAO, 0, COR_PIXEL_EXPLOSAO
	WORD		0, COR_PIXEL_EXPLOSAO, 0, COR_PIXEL_EXPLOSAO, 0
	WORD		COR_PIXEL_EXPLOSAO, 0, COR_PIXEL_EXPLOSAO, 0, COR_PIXEL_EXPLOSAO
	WORD		0, COR_PIXEL_EXPLOSAO, 0, COR_PIXEL_EXPLOSAO, 0


DEF_METEORO_BOM_1:				; tabela que define o primeiro meteoro bom (largura, altura, cor)
	WORD		LARGURA_METEORO_1
	WORD		ALTURA_METEORO_1
	WORD		COR_PIXEL_CINZENTO

DEF_METEORO_BOM_2:				; tabela que define o segundo meteoro bom (largura, altura, cor, pixels)
	WORD		LARGURA_METEORO_2
	WORD		ALTURA_METEORO_2
	WORD		COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO
	WORD		COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO

DEF_METEORO_BOM_3:				; tabela que define o terceiro meteoro bom (largura, altura, cor, pixels)
	WORD		LARGURA_METEORO_3
	WORD		ALTURA_METEORO_3
	WORD		0, COR_PIXEL_METEORO, 0
	WORD		COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO
	WORD		0, COR_PIXEL_METEORO, 0
		
DEF_METEORO_BOM_4:				; tabela que define o quarto meteoro bom (largura, altura, cor, pixels)
	WORD		LARGURA_METEORO_4
	WORD		ALTURA_METEORO_4
	WORD		0, COR_PIXEL_METEORO, COR_PIXEL_METEORO, 0
	WORD		COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO
	WORD		COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO
	WORD		0, COR_PIXEL_METEORO, COR_PIXEL_METEORO, 0

DEF_METEORO_BOM_5:				; tabela que define o quinto meteoro (largura, altura, cor, pixels)
	WORD		LARGURA_METEORO_5
	WORD		ALTURA_METEORO_5
	WORD		0, COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO, 0
	WORD		COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO
	WORD		COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO
	WORD		COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO
	WORD		0, COR_PIXEL_METEORO, COR_PIXEL_METEORO, COR_PIXEL_METEORO, 0

DEF_METEORO_MAU_1:				; tabela que define o primeiro meteoro bmau (largura, altura, cor)
	WORD		LARGURA_METEORO_1
	WORD		ALTURA_METEORO_1
	WORD		COR_PIXEL_CINZENTO

DEF_METEORO_MAU_2:				; tabela que define o segundo meteoro mau (largura, altura, cor, pixels)
	WORD		LARGURA_METEORO_2
	WORD		ALTURA_METEORO_2
	WORD		COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO
	WORD		COR_PIXEL_CINZENTO, COR_PIXEL_CINZENTO

DEF_METEORO_MAU_3:				; tabela que define o terceiro meteoro mau (largura, altura, cor, pixels)
	WORD		LARGURA_METEORO_3
	WORD		ALTURA_METEORO_3
	WORD		COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER
	WORD		0, COR_PIXEL_ROVER, 0
	WORD		COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER
		
DEF_METEORO_MAU_4:				; tabela que define o quarto meteoro mau (largura, altura, cor, pixels)
	WORD		LARGURA_METEORO_4
	WORD		ALTURA_METEORO_4
	WORD		COR_PIXEL_ROVER, 0, 0, COR_PIXEL_ROVER
	WORD		COR_PIXEL_ROVER, 0, 0, COR_PIXEL_ROVER
	WORD		0, COR_PIXEL_ROVER, COR_PIXEL_ROVER, 0
	WORD		COR_PIXEL_ROVER, 0, 0, COR_PIXEL_ROVER

DEF_METEORO_MAU_5:				; tabela que define o quinto meteoro mau (largura, altura, cor, pixels)
	WORD		LARGURA_METEORO_5
	WORD		ALTURA_METEORO_5
	WORD		COR_PIXEL_ROVER, 0, 0, 0, COR_PIXEL_ROVER
	WORD		COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER
	WORD		0, COR_PIXEL_ROVER, COR_PIXEL_ROVER, COR_PIXEL_ROVER, 0
	WORD		COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER, 0, COR_PIXEL_ROVER
	WORD		COR_PIXEL_ROVER, 0, 0, 0, COR_PIXEL_ROVER
	
DEF_ENERGIA:				; Energia do rover em decimal
	WORD		100
	
PERDER:
	WORD		0

linha_rover:				; Linha do rover
	WORD	LINHA_ROVER
coluna_rover:				; Coluna do rover
	WORD	COLUNA_ROVER

linha_tiro:					; Linha do tiro
	WORD	LINHA_ROVER
coluna_tiro:				; Coluna do tiro
	WORD	COLUNA_ROVER

linha_explosao:				
	WORD	0
coluna_explosao:			
	WORD	0
explosao_ativa:
	WORD	0

tipo_meteoro:				; Tabela com os tipos de meteoro
	WORD	0
	WORD	1
	WORD	1
	WORD	0

linhas_meteoro:				; Tabela com as linhas dos meteoros
	WORD	5
	WORD    0
	WORD	8
	WORD	2

colunas_meteoro:			; Tabela com as colunas dos meteoros
	WORD	8
	WORD	16
	WORD	32
	WORD	48

tab:						; Tabela com as interrupções
	WORD rot_int_0
	WORD rot_int_1
	WORD rot_int_2

tecla_carregada:			; Tabela para o evento da tecla carregada
	LOCK 0

evento_meteoro:				; Tabela para o evento de descer meteoros
	LOCK 0

evento_energia:				; Tabela para o evento de diminuir energia
	LOCK 0

evento_tiro:				; Tabela para o evento do tiro
	LOCK 0
	LOCK 0

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                     ; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial		; inicializa SP para a palavra a seguir
							; à última da pilha

	MOV  BTE, tab			; inicializa BTE (registo de Base da Tabela de Exceções)

	MOV R0, 0
	MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV [SELECIONA_CENARIO_FUNDO], R0	; seleciona o ecrã de fundo do jogo
	MOV R6, LINHA_TECLADO				; atribui a primeira linha do teclado a R6

tela_inicio:							; Ciclo que vai esperar que a tecla C seja premida
	MOV R0, 0							; Argumento da rotina teclado
	MOV R10, TECLA_C					; tecla pela qual esperamos
	CALL teclado						; verifica se alguma tecla foi premida
	CMP R0, R10							; Se a tecla premida foi a tecla C, vai continuar o programa,
	JNZ tela_inicio						;	se não, vai voltar ao início do ciclo

	EI0									; Ativa as interrupção 0
	EI1									; Ativa as interrupção 1
	EI2									; Ativa as interrupção 2
	EI									; Liga as Interrupções

	CALL comeca_teclado					; cria o processo do teclado
	CALL desce_meteoro					; cria o processo de descer os meteoros
	CALL processo_tiro					; cria o processo do tiro
	CALL decresce_energia				; cria o processo de decrescer a energia

inicio_pos_processos:					; inicio do programa depois de crias os processos
                       
	MOV	R1, 1							; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV	R7, 1							; valor a somar à coluna do rover, para o movimentar
	MOV R11, ATRASO						; valor do atraso
	MOV R9, 4							; seleciona a música de fundo do jogo
	CALL toca_som_continuamente			; liga a música de fundo do jogo

    
	MOV  R4, DEF_ROVER					; Endereço da tabela do Rover
	MOV  R1, linha_rover				; Endereço da tabela da linha do rover
	MOV  R2, coluna_rover				; Endereço da tabela da coluna do rover
	MOV  R9, 0							; Seleção do ecrã onde desenhar o rover
	CALL desenha_objeto					; desenho inicial do rover

	MOV  R7, 0							; (para não alterar o valor do contador)
	MOV  R4, DEF_ENERGIA				; referência à Energia
	CALL altera_contador				; altera o valor do contador para o valor inicial (100)

	YIELD								

tenta_teclas:
	MOV R0, [tecla_carregada]			; dá LOCK ao evento do teclado, espera

testa_0:
	MOV	R10, TECLA_0		; código da tecla_0
	CMP	R0, R10				; verifica se a tecla_0 foi premida
	JNZ	testa_1				; se a tecla 0 não foi premida, verifica a tecla_1
	MOV R4, DEF_ROVER		; guarda o endereço da tabela do rover
	MOV R1, linha_rover		; Endereço da linha do rover
	MOV R2, coluna_rover	; Endereço da coluna do rover
	MOV	R7, -1				; vai deslocar para a esquerda
	JMP	ve_limites			; verifica se o rover está na borda da janela
testa_1:
	MOV R10, TECLA_1		; código da tecla_1
	CMP R0, R10				; verifica se a tecla_1 foi premida
	JNZ testa_2				; se a tecla_1 não foi premida, verifica a tecla_2
	MOV R4, DEF_TIRO		; guarda o endereço da tebela do tiro
	MOV R10, 6				
	ADD R4, R10				; avança 6 bits na memória até à WORD
	MOV R10, [R4]			; lê a variável que indica se existe um tiro na tela ou não
	CMP R10, 0				; verifica se existe um tiro na tela ou não
	JNZ tenta_teclas		; caso exista, volta a ler teclas
	MOV [evento_tiro], R11	; dá unlock do evento do tiro
	JMP tenta_teclas
testa_2:					
	MOV R10, TECLA_2		; código da tecla_2
	CMP	R0, R10				; verifica se a tecla foi premida 
	JNZ	testa_D			    ; se a tecla 2 não foi premida, verifica a tecla 4
	MOV R4, DEF_ROVER		; guarda o endereço da tabela do rover
	MOV R1, linha_rover	    ; Endereço da linha do rover
	MOV R2, coluna_rover	; Endereço da coluna do rover
	MOV	R7, +1				; vai deslocar para a direita
	JMP ve_limites			; verifica se o rover está na borda da janela
testa_D:
	MOV R10, TECLA_D					; código da tecla D
	CMP R0, R10							; Verifica se a tecla D foi premida
	JNZ testa_E							; Se não foi, verifica a tecla E
	CALL pausa							; Caso tenha sido, coloca o programa em pausa
	MOV R0, 1							; Após sair da pausa, seleciona o cenário de fundo do jogo
	MOV [SELECIONA_CENARIO_FUNDO], R0	; Atualiza o cenário de fundo do jogo
	JMP tenta_teclas					; volta a ler teclas
testa_E:
	MOV R10, TECLA_E			; código da tecla E
	CMP R0, R10					; Verifica se a tecla E foi premida
	JNZ tenta_teclas			; Se não for, volta a tentar teclas
	CALL perder					; Se foi, perde o jogo
	JMP inicio_pos_processos	; Depois de perder, volta ao inicio do jogo
	
ve_limites:	
	MOV	R6, LARGURA_ROVER	; guarda a largura do rover
	CALL testa_limites		; vê se chegou aos limites do ecrã e se sim força R7 a 0
	CMP	R7, 0				
	JZ	tenta_teclas		; se não é para movimentar o objeto, vai ler o teclado de novo
	JMP move_rover

move_rover:
	MOV R4, DEF_ROVER		; guarda o endereço da tabela do meteoro
	MOV R1, linha_rover
	MOV R2, coluna_rover
	MOV R9, 0				; escolhe o ecrã para editar
	CALL apaga_objeto		; apaga o rover
coluna_seguinte:
	MOV R10, [R2]
	ADD R10, R7				; aumenta ou diminui o valor da coluna do rover
	MOV [R2], R10			; insere o novo valor da coluna do rover na tabela do mesmo

	MOV R9, 0
	MOV R1, linha_rover
	MOV R2, coluna_rover
	CALL desenha_objeto		; desenha o rover
	CALL atraso				; atraso
	JMP tenta_teclas

; **********************************************************************
; PROCESSO_TECLADO - Processo que deteta quando se carrega numa tecla
;					
; **********************************************************************
PROCESS SP_inicial_teclado

comeca_teclado:
	MOV R6, LINHA_TECLADO			
espera_tecla:						; Ciclo onde esperamos que uma tecla seja premida

	YIELD							; Esta é uma potencial rotina bloqueante, pelo que tem de ter um
									;	um ponto de fuga (para comutar para outro processo)

	CALL teclado					; Procura por uma tecla premida no teclado
	CMP R0, 0						; Verifica se alguma tecla foi premida
	JZ espera_tecla					; Se não houver uma tecla premida, repete o ciclo

	MOV [tecla_carregada], R0       ; Escreve para o LOCK da tecla_carregada para indicar que se encontrou uma tecla
	JMP espera_tecla				; Salta para o inicio do processo 

; **********************************************************************
; PROCESSO_METEOROS -  Processo que faz um conjunto de 4 meteoros descer ao
;					   longo da tela
; **********************************************************************
PROCESS SP_inicial_meteoro

desce_meteoro:
	MOV R9, 1						
ciclo_meteoro:
	MOV R1, linhas_meteoro			; Endereço das linhas dos meteoros
	MOV R2, colunas_meteoro			; Endereço das colunas dos meteoros
	MOV R5, tipo_meteoro			; Endereços dos tipos de meteoros
	MOV R0, 4						; R0 é um auxiliar para escolher os ecrãs em que desenhar os 
									;	meteoros e para contar o número de ciclos 
desenha_todos_os_meteoros:
	CALL escolhe_meteoro			; Escolhe o tipo de meteoro a desenhar
	MOV R9, R0						; Muda constantemente o ecra para desenhar os meteoros
	CALL desenha_objeto				; Desenha um meteoro
	ADD R1, 2						; Linha do próximo meteoro
	ADD R2, 2						; Coluna do próximo meteoro
	ADD R5, 2						; Tipo do do próximo meteoro
	SUB R0, 1						; Passamos ao próximo ecrã onde desenhar e à próxima iteração do ciclo
	CMP R0, 0						; Verifica se já desenhamos os quatro meteoros
	JNZ desenha_todos_os_meteoros	; Se não, repete o ciclo

	MOV R11, [evento_meteoro]		; Lê do LOCK do evento do meteoro 

continua_desenha_todos_os_meteoros:
	MOV R1, linhas_meteoro			; Endereço das linhas dos meteoros
	MOV R2, colunas_meteoro			; Endereço das colunas dos meteoros
	MOV R5, tipo_meteoro			; Endereços dos tipos de meteoros
	MOV R0, 4						; R0 é um auxiliar para escolher os ecrãs em que desenhar os
									;	meteoros e para contar o número de ciclos
apaga_todos_os_meteoros:
	CALL escolhe_meteoro			; Escolhe o tipo de meteoro a desenhar
	MOV R9, R0						; Seleciona o ecrã onde desenhar o meteoro
	CALL apaga_objeto				; Apaga um meteoro

	MOV R8, [R1]					; passa o meteoro para a próxima linha
	ADD R8, 1						; incrementa a linha
	MOV [R1], R8					; atualiza a linha do meteoro

	MOV R9, [R1]							; Armazena em R9 o valor da linha de um meteoro
	MOV R10, LINHA_ROVER					; Armazena o valor da linha do rover em R10
	SUB R10, R9								; Subtrai a linha do rover à linha do meteoro
	CMP R10, 4								; Verifica se a diferença é maior que 4
	JGT continua_apaga_todos_os_meteoros	; Se a diferença for maior que 4, então não houve colisão
	CMP R10, -4								; Verifica se a diferença é menor que 4
	JLT continua_apaga_todos_os_meteoros	; Se a diferença dor menor que -4, então não houve colisão

	CALL bateu_no_rover						; Asteroide bateu no rover

continua_apaga_todos_os_meteoros:
	ADD R1, 2						; Linha do próximo meteoro
	ADD R2, 2						; Coluna do próximo meteoro
	ADD R5, 2						; Tipo do próximo meteoro	
	SUB R0, 1						; Passamos ao próximo ecrã onde apagar e à próxima iteração do ciclo
	CMP R0, 0						; Verifica se já desenhamos os 4 meteoros
	JNZ apaga_todos_os_meteoros		; Se não, repete o ciclo

	CALL chegou_ao_fim				; Verifica se algum meteoro chegou ao fim do ecrã
	JMP ciclo_meteoro				; Retorna ao início do processo

; **********************************************************************
; BATEU_NO_ROVER - Verifica se um meteoro colidiu com o rover, agindo
;				   de acordo com o tipo de meteoro com o qual houve a colisão
;
; Argumentos: R1 - endereço da linha do meteoro
;			  R2 - endereço da coluna do meteoro
;			  R5 - endereço do tipo do meteoro
; **********************************************************************
bateu_no_rover:
	PUSH R7
	PUSH R6
	PUSH R5
	PUSH R4
	PUSH R2
	PUSH R1

	MOV R6, [R2]				; Armazena em R6 o valor da coluna do meteoro
	MOV R7, [coluna_rover]		; Armazena em R7 o valor da coluna do rover

	SUB R6, R7					; Subtrai à coluna do meteoro a coluna do rover
	CMP R6, 4					; Verifica se a diferença é maior que 4
	JGT fim_bateu_rover			; Se for, não houve colisão
	CMP R6, -4					; Verifica se a diferença é menor que -4
	JLT fim_bateu_rover			; Se for, não houve colisão

	MOV R7, [R5]				; Armazena em R3 o tipo de meteoro
	CMP R7, 1					; Verifica se é um meteoro bom
	JNZ bateu_meteoro_mau		; Se não for um meteoro bom, então salta para as
								;	instruções do meteoro mau
	CALL bateu_meteoro_bom		; Trata das funcionalidades da colisão com um meteoro bom
	JMP continua_bateu_no_rover	

bateu_meteoro_mau:
	MOV R9, 3					; Seleciona o som de colisão com o meteoro mau
	CALL toca_som				; Toca o som de colisão com o meteoro mau
	CALL perder					; Chama a rotina de derrota
	JMP inicio_pos_processos	

continua_bateu_no_rover:
	CALL reset_meteoro			; Dá reset à possição do meteoro, enviando-o para o 
								;	topo do ecrã
fim_bateu_rover:
	POP R1
	POP R2
	POP R4
	POP R5
	POP R6
	POP R7
	RET

; **********************************************************************
; BATEU_METEORO_BOM - Trata das funcionalidades do jogo depois de se 
;					  verificar que houve colisão com um meteoro bom
; **********************************************************************
bateu_meteoro_bom:
	MOV R7, 10				; Valor a incrementar no contador
	MOV R4, DEF_ENERGIA		; Endereço da energia
	MOV R9, 2				; Seleciona o som a tocar
	CALL toca_som			; Toca o som de colisão com meteoro bom
	CALL altera_contador	; Atualiza o contador
	RET

; **********************************************************************
; CHEGOU_AO_FIM  - Verifica se algum dos meteoros chegou ao fim, e coloca
;				   aqueles que chegaram de volta ao topo do ecrã numa
;				   coluna aleatória
; **********************************************************************
chegou_ao_fim:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R5
	PUSH R8
	PUSH R10

	MOV R1, linhas_meteoro		; Endereço da tabela das linhas dos meteoros
	MOV R2, colunas_meteoro		; Endereço da tabela das colunas dos meteoros
	MOV R5, tipo_meteoro		; Endereço da tabela dos tipos dos meteoros
	MOV R8, ULTIMA_LINHA		; Valor da última linha do ecrã
	MOV R0, 4					; R0 é um auxiliar para escolher os ecrãs em que desenhar os 
									;	meteoros e para contar o número de ciclos 

ciclo_chegou_ao_fim:			
	MOV R10, [R1]					; Linha do meteoro
	CMP R10, R8						; Verifica se o metetero está na última linha
	JNZ continuacao_chegou_ao_fim	; Se não estiver, não dá reset

	CALL reset_meteoro				; Dá reset à posição do meteoro, colocando-o no
									;	topo do ecrã numca coluna aleatória
continuacao_chegou_ao_fim:
	ADD R1, 2					; Linha do próximo meteoro
	ADD R2, 2					; Coluna do próximo meteoro
	ADD R5, 2					; Tipo do próximo meteoro
	SUB R0, 1					; Menos um ciclo a tratar
	CMP R0, 0					; Verifica se chegamos ao fim do ciclo
	JNZ ciclo_chegou_ao_fim		; Caso não, repete o ciclo

fim_chegou_ao_fim:
	POP R10
	POP R8
	POP R5
	POP R2
	POP R1
	POP R0
	RET

; **********************************************************************
; RESET_METEORO - Coloca o meteoro de volta à primeira linha e atraibui-lhe
;				  uma nova coluna aleatória
; **********************************************************************
reset_meteoro:
	MOV R10, 0				; Vamos colocar o meteoro na linha 0
	MOV [R1], R10			; Define a coluna do meteoro a 0
	CALL coluna_aleatoria	; Atribui-lhe uma coluna aleatória
	RET

; **********************************************************************
; COLUNA_ALEATORIA - Esta rotina lê do PIN do teclado, lendo os bits mais
;					 significativos que são gerados aleatóriamente.
;	Através deles é gerado o tipo de meteoro (25% Bom e 75% Mau) e a 
;	sua coluna, também gerada aleatoriamente
;
;   Argumentos: R2 - Endereço da coluna do meteoro
;				R5 - Endereço do tipo de meteoro
; **********************************************************************
coluna_aleatoria:
	PUSH R0
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R8

	MOV R3, TEC_COL				; Endereço do Pin do teclado
	MOVB R0, [R3]				; Lê do Pin, para gerar uma coluna aleatória
	SHR R0, 5					; Atribui a R0 os bits mais sgnificativos, gerados aleatoriamente
	MOV R8, 8					; Multiplicador para termos 8 colunas onde fazer surgir os meteoros
	MUL R0, R8					; Multiplicamos pelo valor aleatório para estar enquadrado no nosso ecrã
	MOV [R2], R0				; Atualizamos o valor da coluna do meteoro para o novo valor
		
	MOVB R0, [R3]				; Lê do Pin para gerar o tipo de asteróide aleatório
	SHR R0, 5					; Atribui a R0 os bits mais significativos gerados aleatoriamente
	CMP R0, 1					; Verifica se o valor de 0 a 7 é maior que 1
	JGT escolhe_meteoro_mau		; Se for maior que 1 (75% de probabilidade), então selecionamos um meteoro mau
	JMP escolhe_meteoro_bom		; Caso contrário selecionamos o meteoro bom (25% de probabilidade)

escolhe_meteoro_mau:
	MOV R8, 0					; Valor 0 = meteoro mau
	MOV [R5], R8				; Atualiza o tipo de meteoro para tipo mau
	JMP fim_escolhe_aleatorio	; salta para o fim da rotina
escolhe_meteoro_bom:
	MOV R8, 1					; Valor 1 = meteoro bom
	MOV [R5], R8				; Atualiza o tipo de meteoro para tipo bom
fim_escolhe_aleatorio:
	POP R8
	POP R5
	POP R3
	POP R2
	POP R0
	RET

; **********************************************************************
; ESCOLHE_METEORO -  Decide que tipo de meteoro vai ser desenhado tendo 
;					 em conta a linha em que ele está
; 
;	Argumentos: R1 - Endereço da linha do meteoro
;				R2 - Endereço da coluna do meteoro
;				R5 - Endereço do tipo de meteoro
;
;   Retorno:	R4 - Endereço para o tipo de meteoro 
; **********************************************************************
escolhe_meteoro:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R8

	MOV R0, 0					; Valor de meteoro mau
	MOV R1, [R1]				; Linha do meteoro
	MOV R8, [R5]				; Tipo de meteoro
	CMP R8, R0					; Verifica com que tipo de meteoro estamos a lidar
	JZ tamanhos_meteoros_maus	; Se for 0, é um meteoro mau
	JMP tamanhos_meteoros_bons	; Se for 1, é um meteoro bom

	MOV R0, 2					; linha até onde se desenha um meteoro tipo 1
tamanhos_meteoros_maus:
tamanho_mau_1:
	CMP R1, R0					; Verifica se a linha está abaixo da linha limite 2
	JGT tamanho_mau_2			; Se estiver, vai testar o meteoro bom tipo 2
	MOV R4, DEF_METEORO_MAU_1	; Caso contrário, coloca o endereço da tabela do meteoro bom tipo 1 em R4
	JMP fim_escolhe_meteoro		; Salta para o fim
tamanho_mau_2:
	ADD R0, 3					; Adiciona 3 à linha limite
	CMP R1, R0					; Verifica se a linha está abaixo da linha limite 5
	JGT tamanho_mau_3			; Se estiver, vai testar o meteoro bom tipo 3
	MOV R4, DEF_METEORO_MAU_2	; Caso contrário, coloca o endereço da tabela do meteoro bom tipo 2 em R4
	JMP fim_escolhe_meteoro		; Salta para o fim
tamanho_mau_3:
	ADD R0, 3					; Adiciona 3 à linha limite
	CMP R1, R0					; Verifica se a linha está abaixo da linha limite 8
	JGT tamanho_mau_4			; Se estiver, vai testar o meteoro bom tipo 4
	MOV R4, DEF_METEORO_MAU_3	; Caso contrário, coloca o endereço da tabela do meteoro bom tipo 3 em R4
	JMP fim_escolhe_meteoro		; Salta para o fim
tamanho_mau_4:
	ADD R0, 3					; Adiciona 3 à linha limite
	CMP R1, R0					; Verifica se a linha está abaixo da linha limite 11
	JGT tamanho_mau_5			; Se estiver, vai testar o meteoro bom tipo 5
	MOV R4, DEF_METEORO_MAU_4	; Caso contrário, coloca o endereço da tabela do meteoro bom tipo 4 em R4
	JMP fim_escolhe_meteoro		; Salta para o fim
tamanho_mau_5:
	MOV R4, DEF_METEORO_MAU_5	; Coloca o endereço da tabela do meteoro bom tipo 5 em R4
	JMP fim_escolhe_meteoro		; Salta para o fim

tamanhos_meteoros_bons:
tamanho_bom_1:
	CMP R1, R0					; Verifica se a linha está abaixo da linha limite 2
	JGT tamanho_bom_2			; Se estiver, vai testar o meteoro mau tipo 2
	MOV R4, DEF_METEORO_BOM_1	; Caso contrário, coloca o endereço da tabela do meteoro mau tipo 1 em R4
	JMP fim_escolhe_meteoro		; Salta para o fim
tamanho_bom_2:
	ADD R0, 3					; Adiciona 3 à linha limite
	CMP R1, R0					; Verifica se a linha está abaixo da linha limite 5
	JGT tamanho_bom_3			; Se estiver, vai testar o meteoro mau tipo 3
	MOV R4, DEF_METEORO_BOM_2	; Caso contrário, coloca o endereço da tabela do meteoro mau tipo 2 em R4
	JMP fim_escolhe_meteoro		; Salta para o fim
tamanho_bom_3:
	ADD R0, 3					; Adiciona 3 à linha limite
	CMP R1, R0					; Verifica se a linha está abaixo da linha limite 8
	JGT tamanho_bom_4			; Se estiver, vai testar o meteoro mau tipo 4
	MOV R4, DEF_METEORO_BOM_3	; Caso contrário, coloca o endereço da tabela do meteoro mau tipo 3 em R4
	JMP fim_escolhe_meteoro		; Salta para o fim
tamanho_bom_4:
	ADD R0, 3					; Adiciona 3 à linha limite
	CMP R1, R0					; Verifica se a linha está abaixo da linha limite 11
	JGT tamanho_bom_5			; Se estiver, vai testar o meteoro mau tipo 5
	MOV R4, DEF_METEORO_BOM_4	; Caso contrário, coloca o endereço da tabela do meteoro mau tipo 4 em R4
	JMP fim_escolhe_meteoro		; Salta para o fim
tamanho_bom_5:
	MOV R4, DEF_METEORO_BOM_5	; Coloca o endereço da tabela do meteoro mau tipo 1 em R4

fim_escolhe_meteoro:
	POP R8
	POP R5
	POP R3
	POP R2
	POP R1
	POP R0
	RET

; **********************************************************************
; PROCESSO_TIRO - Processo que trata de fazer o tiro andar e testar as 
;				  colisões do mesmo com os diversos meteoros
; **********************************************************************
PROCESS SP_inicial_tiro

processo_tiro:
	MOV R4, DEF_TIRO					; Endereço da tabela do tiro
	
	MOV R10, 6							; Valor a somar para chegar ao endereço de ativação do tiro
	ADD R4, R10							; Anda 3 espaços na memória para chegar ao endereço de ativação do tiro
	MOV R10, 0							; Valor a colocar na ativação do tiro
	MOV [R4], R10						; Coloca o valor de ativação a 0 (Não há tiro na tela)

processo_tiro_lock:
	MOV R11, [evento_tiro]				; Lê do LOCK para esperar até o botão de disparar ser pressionado

	MOV R9, 0							; Seleciona o Som de disparo
	CALL toca_som						; Toca o som de disparo

	MOV R7, -5							; Valor a somar (ou subtrair) à energia do rover
	MOV R4, DEF_ENERGIA					; Endereço da energia do rover
	CALL altera_contador				; Atualiza o valor da energia

	MOV R4, DEF_TIRO					; Endereço do Tiro
	MOV R6, coluna_rover				; Valor da coluna do rover
	MOV R1, linha_tiro					; Valor da linha do tiro
	MOV R2, coluna_tiro					; Valor da coluna do tiro
	MOV R10, [R6]						; Guarda o valor da coluna do rover em R10
	ADD R10, 2							; Adiciona 2 ao valor da coluna do rover, para ajustar o tiro a partir do centro do rover
	MOV [R2], R10						; Atualiza o valor da coluna do rover

	MOV R9, 1							; Ecrã em que desenhar o tiro
	MOV R3, 16							; Linha limite do tiro
	MOV R10, 6							; Valor a somar para chegar à ativação do tiro
	ADD R4, R10							; Salta para o endereço da ativação do tiro
	MOV R10, 1							; Coloca a ativação a 1 (ativada)
	MOV [R4], R10						; Atualiza o valor de ativação do tiro 

move_tiro:
	MOV R4, DEF_TIRO					; Endereço do Tiro
	MOV R1, linha_tiro					; Endereço da linha do tiro
	MOV R2, coluna_tiro					; Endereço da coluna do tiro

	MOV R10, [R4 + 6]					; Valor de ativação do tiro
	CMP R10, 0							; Verifica se o tiro está desativado
	JZ processo_tiro_lock				; Se estiver desativado, damos LOCK ao evento

	MOV R4, DEF_TIRO					; Endereço do Tiro
	CALL desenha_objeto					; Desenha o tiro

	MOV R11, [evento_tiro + 2]			; LOCK que espera pela interrupção do tiro para fazê-lo andar

	CALL apaga_objeto					; Apaga tiro
	MOV R10, [R1]						; Valor da linha do tiro
	SUB R10, 1							; Subtrai uma linha ao tiro (mover para cima)
	MOV [R1], R10						; Atualiza o valor do tiro
	CMP R10, R3							; Verifica se o tiro atingiu a linha limite
	JNZ fim_ciclo_move_tiro				; Caso tenha atingido, damos reset ao tiro

	CALL reset_tiro
	JMP processo_tiro

fim_ciclo_move_tiro:
	CALL colisoes_tiro					; Verifica se o tiro colidiu com um meteoro
	JMP move_tiro						; volta ao início do ciclo


; **********************************************************************
; RESET_TIRO -  Dá reset à linha do tiro, e à ativação do mesmo
;
; **********************************************************************
reset_tiro:
	MOV R4, DEF_TIRO			; Endereço do tiro
	MOV R1, linha_tiro			; Endereço da linha do tiro
	MOV R10, LINHA_ROVER		; Linha do rover	
	MOV [R1], R10				; Atualiza a linha do tiro para a linha do rover
	MOV R10, 6					; Valor a adicionar para chegar ao endereço da ativação do tiro
	ADD R4, R10					; Soma 6 para chegar ao valor de ativação do tiro
	MOV R10, 0					; Valor a colocar na ativação
	MOV [R4], R10				; Atualiza o valor da ativação para 0
	RET

; **********************************************************************
; COLISOES TIRO
;
; **********************************************************************
colisoes_tiro:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10

	MOV R1, linhas_meteoro				; Endereço das linhas do meteoro
	MOV R2, colunas_meteoro				; Endereço das colunas do meteoro
	MOV R5, tipo_meteoro				; Endereço dos tipos de meteoros
	MOV R6, [linha_tiro]				; Valor da linha do tiro
	MOV R8, [coluna_tiro]				; Valor da coluna do tiro
	MOV R0, 4							; Variável que conta o número de ciclos
	MOV R9, 4							; 

ciclo_colisoes_tiro:
	CALL meteoro_encontrado_hipotese	; Verifica se encontramos um meteoro
ciclo_colisoes_tiro_continuacao:
	ADD R1, 2							; Linha do meteoro seguinte
	ADD R2, 2							; Coluna do meteoro seguinte
	ADD R5, 2							; Tipo do meteoro seguinte
	SUB R9, 1							; Ecrã em que modificar os meteoros
	SUB R0, 1							; Menos um ciclo
	CMP R0, 0							; Verifica se já fizemos 4 ciclos
	JZ fim_colisoes_tiro				; Se sim, saltamos para o fim da rotina
	JMP ciclo_colisoes_tiro				; Caso contrário, repetimos o ciclo

fim_colisoes_tiro:
	POP R10
    POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R2
	POP R1
	POP R0
	RET


; **********************************************************************
; METEORO_ENCONTRADO_HIPOTESE - Verifica se o tiro está na linha do meteoro
;								
; **********************************************************************
meteoro_encontrado_hipotese:
	MOV R10, R6								; Guarda o valor da linha do tiro
	MOV R7, [R1]							; Valor da linha do rover
	SUB R10, R7								; Subtrai o valor da linha do tiro à do rover
	CMP R10, 4								; Verifica se é maior que 4
	JGT fim_meteoro_encontrado_hipotese 	; Se for, então não colidiu. Salta para o fim da rotina
	CMP R10, 0								; Verifica se é menor que 0
	JLT fim_meteoro_encontrado_hipotese		; Se for, então não colidiu. Salta para o fim da rotina
	CALL meteoro_encontrado_linha			; Caso esteja entre 0 e 4, então está no intervalo de linhas
											;	certo e deve testar a coluna
fim_meteoro_encontrado_hipotese:
	RET

; **********************************************************************
; METEORO_ENCONTRADO_LINHA - Verifica se o tiro está na mesma coluna do meteoro
;
; **********************************************************************
meteoro_encontrado_linha:
	MOV R7, [R2]							; Guarda o valor da coluna do rover
	MOV R10, R8								; Guarda o valor da coluna do tiro
	SUB R10, R7								; Subtrai o valor da coluna do tiro à do rover
	CMP R10, 4								; Verifica se é maior que 4
	JGT fim_meteoro_encontrado_linha		; Se for, então não colidiu. Salta para o fim da rotina
	CMP R10, 0								; Verifica se é menor que 0
	JLT fim_meteoro_encontrado_linha		; Se for, então não colidiu. Salta para o fim da rotina
	JMP meteoro_encontrado					; Caso esteja entre 0 e 4, então há um meteoro que colidiu 

fim_meteoro_encontrado_linha:
	RET

; **********************************************************************
; METEORO_ENCONTRADO -  Dá reset ao meteoro e ao tiro, agindo de acordo 
;						o tipo de meteoro encontrado
; **********************************************************************
meteoro_encontrado:
	CALL escolhe_meteoro					; Escolhe que meteoro apagar
	CALL apaga_objeto						; Apaga meteoro

	CALL desenha_explosao					; Mostra momentaneamente uma explosão na tela
	CALL apaga_explosao

	MOV R10, [R5]							; Valor do tipo de meteoro
	CMP R10, 0								; Verifica se é um meteoro mau
	JNZ	continua_meteoro_encontrado			; Se não for, salta para a continuação da rotina

	CALL incrementa_energia_5				; Se for, incrementa a energia em 5
continua_meteoro_encontrado:				
	MOV R9, 1								; Escolhe o som de destruir meteoro mau
	CALL toca_som							; Toca som de destruir meteoro mau
	CALL reset_meteoro						; Reset do meteoro
	CALL reset_tiro							; Reset do Tiro
	RET

; **********************************************************************
; INCREMENTA_ENERGIA_5 - Incrementa a energia do rover em 5
;
; **********************************************************************
incrementa_energia_5:
	MOV R7, 5								; Valor a somar à energia
	MOV R4, DEF_ENERGIA						; Endereço da energia
	CALL altera_contador					; Atualiza o display
	RET

; **********************************************************************
; DESENHA_EXPLOSAO -  Desenha explosão na tela
;
;   Argumentos: R1 - Endereço da linha do meteoro
;				R2 - Endereço da coluna do meteoro
; **********************************************************************
desenha_explosao:
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R9

	MOV R4, DEF_EXPLOSAO			; Endereço da Explosão
	MOV R9, 7						; Ecrã em que desenhar a explosão
	MOV R5, [R1]					; Valor da linha do meteoro
	MOV R6, [R2]					; Valor da coluna do meteoro
	MOV [linha_explosao], R5		; Define a linha em que desenhar a explosão
	MOV [coluna_explosao], R6		; Define a coluna em que desenhar a explosão

	CALL desenha_objeto				; Desenha a explosão

	MOV R4, ATRASO_EXPLOSAO			; Atraso para desenhar a explosão e deixá-la na tela
ciclo_fim_desenha_explosao:
	SUB R4, 1						; Subtrai 1 ao valor do atraso
	CMP R4, 0						; Verifica se chegamos ao fim do ciclo
	JNZ ciclo_fim_desenha_explosao	; Caso não, repete o ciclo

	POP R9
	POP R6
	POP R5
	POP R4
	POP R2
	POP R1
	RET

; **********************************************************************
; APAGA_EXPLOSAO -  Apaga a explosão
;
;   Argumentos: R1 - Endereço da linha do meteoro
;				R2 - Endereço da coluna do meteoro
; **********************************************************************
apaga_explosao:
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R9
			
	MOV R4, DEF_EXPLOSAO			; Endereço da explosão
	MOV R9, 7						; Ecrã onde apagar a explosão
	CALL apaga_objeto				; Apaga a explosão

	POP R9
	POP R4
	POP R2
	POP R1
	RET

; **********************************************************************
; PROCESSO_ENERGIA - Processo que diminui a energia cada vez que a
;					 interrupção permite este evento
; **********************************************************************
PROCESS SP_inicial_energia

decresce_energia:
	MOV R11, [evento_energia]		; Lê do LOCK para esperar até a interrupção desbloquear o processo

	CALL diminui_energia			
	MOV R4, DEF_ENERGIA				; Endereço da energia
	MOV R0, [R4]					; Valor de energia em R0
	CMP R0, 0						; Verifica se a energia está a 0
	JZ energia_nula					; Se for, então salta para perder
	JMP decresce_energia			; Caso contrário, repete o ciclo

energia_nula:
	CALL perder						; Chama a rotina "perder"
	JMP inicio_pos_processos		; Após sair da mesma, volta ao início do programa

; **********************************************************************
; DIMINUI_ENERGIA - Rotina que diminui a energia do rover em 5 unidades
;
; **********************************************************************
diminui_energia:
	PUSH R7
	PUSH R4
	PUSH R0

	MOV R7, -5					; Valor a somar (ou subtrair) à energia
	MOV R4, DEF_ENERGIA			; Endereço da energia do rover
	CALL altera_contador		; Atualiza o valor da energia

	POP R0
	POP R4
	POP R7
	RET

; **********************************************************************
; ROTINA_INT_0 - Rotina dos meteoros que informa o programa para
;				 invocar a rotina do evento para descer meteoros
; **********************************************************************
rot_int_0:
	MOV [evento_meteoro], R11
	RFE

; **********************************************************************
; ROTINA_INT_1 - Rotina dos tiros que informa o processo dos tiros de 
;				 que pode avançar o tiro para a próxima linha
; **********************************************************************
rot_int_1:
	MOV [evento_tiro + 2], R11
	RFE

; **********************************************************************
; ROTINA_INT_2 - Rotina da energia que informa o processo da energia de
;				 que pode decrementar o valor do display em 5 unidades
; **********************************************************************
rot_int_2:
	MOV [evento_energia], R1
	RFE

; **********************************************************************
; DESENHA_OBJETO - rotina mãe para desenhar uma dada figura
; Argumentos:	R4 - tabela do objeto a desenhar
;				R9 - ecrã onde desenhar
; **********************************************************************
desenha_objeto:
	PUSH R1
	PUSH R2
	CALL seleciona_ecra
	CALL posicao_objeto
	CALL desenha
	POP R2
	POP R1
	RET

; **********************************************************************
; APAGA_OBJETO - rotina mãe para apagar uma dada figura
; Argumentos:	R4 - tabela do objeto a apagar
;				R9 - ecrã onde apagar
; **********************************************************************
apaga_objeto:
	PUSH R1
	PUSH R2
	CALL seleciona_ecra
	CALL posicao_objeto
	CALL apaga
	POP R2
	POP R1
	RET

; **********************************************************************
; SELECIONA_ECRA - rotina que seleciona o ecrã em que se desenha uma figura
; Argumentos:	R9 - ecrã que vamos selcionar
;
; **********************************************************************
seleciona_ecra:
	PUSH R4
	MOV R4, SELECIONA_ECRA		; endereço da instrução para selecionar o ecrã
	MOV [R4], R9				; seleção do ecrã
	POP  R4
	RET

; **********************************************************************
; POSICAO_OBJETO - seleciona a linha e a coluna em que um objeto vai
;				   ser desenhado
; Argumentos:	R4 - endereço da tabela do objeto a ser desenhado
;
; Retorno:		R1 - linha do objeto
;				R2 - coluna do objeto
; **********************************************************************
posicao_objeto:
	MOV R1, [R1]		; obtém linha do objeto
	MOV R2, [R2]		; obtém coluna do objeto
	RET

; **********************************************************************
; DESENHA - Desenha uma figura com a linha e coluna indicadas
;			  com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define a figura
;
; **********************************************************************
desenha:
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R8
	PUSH	R9

	MOV R5, [R4]				; obtém a largura da figura
	MOV R10, R5					; salva o endereço para a largura
	ADD R4, 2					; endereço da altura
	MOV R8, [R4]				; obtém a altura da figura
	MOV R9, R8					; guarda a altura numa variavel auxiliar
	ADD	R4, 2					; endereço da cor do 1º pixel (2 porque a largura é uma word)
desenha_pixels:       			; desenha os pixels da figura a partir da tabela
	MOV R5, R10					; reset à largura
desenha_pixels_linha:       	; desenha os pixels da figura a partir da tabela
	MOV	R3, [R4]				; obtém a cor do próximo pixel da figura
	CALL escreve_pixel			; escreve cada pixel da figura
	ADD	R4, 2					; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD R2, 1               	; próxima coluna
    SUB R5, 1					; menos uma coluna para tratar
    JNZ desenha_pixels_linha    ; continua até percorrer toda a largura do objeto
	SUB R2, R10					; volta à coluna inicial de desenho
	ADD R1, 1					; próxima linha 
	SUB R8, 1					; altura - 1
	JNZ desenha_pixels			; continua até percorrer todas as linhas do objeto
	SUB R1, R9					; dá reset aa R1 para estar na linha do primeiro pixel

	POP R9
	POP R8
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	RET

; **********************************************************************
; APAGA - Apaga figura na linha e coluna indicadas
;		  com a forma definida na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define a figura
;
; **********************************************************************
apaga:
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH    R8
	PUSH    R9
	
	MOV	R5, [R4]				; obtém a largura da figura
	MOV R10, R5					; salva o endereço de memória da largura
	ADD	R4, 2					; endereço da altura
	MOV R8, [R4]				; obtém altura do figura
	MOV R9, R8					; guarda a altura numa variável auxiliar
	ADD R4, 2					; endereço da cor do 1º pixel (2 porque a largura é uma word)
apaga_pixels:					; apaga os pixeis da figura passada
	MOV R5, R10		            ; reset à largura
apaga_pixels_linha:       		; desenha os pixels do figura a partir da tabela
	MOV	R3, 0					; cor para apagar o próximo pixel do figura
	CALL  escreve_pixel			; escreve cada pixel do figura
	ADD	R4, 2					; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD R2, 1               	; próxima coluna
    SUB R5, 1					; menos uma coluna para tratar
    JNZ  apaga_pixels_linha     ; continua até percorrer toda a largura do objeto
	SUB R2, R10					; volta à coluna inicial de desenho
	ADD R1, 1					; próxima linha
	SUB R8, 1					; altura - 1
	JNZ  apaga_pixels			; continua até percorrer todas as linhas do figura
	SUB R1, R9	                ; da reset a R1 para estar na linha do primeiro pixel
	
	POP R9
	POP R8
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	RET

; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA], R1		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna já selecionadas
	RET

; **********************************************************************
; ATRASO - Executa um ciclo para implementar um atraso.
; Argumentos:   R11 - valor que define o atraso
;
; **********************************************************************
atraso:
	PUSH	R11

ciclo_atraso:
	SUB	R11, 1					; atraso - 1
	JNZ	ciclo_atraso			; verifica se chegamos ao fim do ciclo

	POP	R11
	RET

; **********************************************************************
; TESTA_LIMITES - Testa se o rover chegou aos limites do ecrã e nesse caso
;				  impede o movimento (força R7 a 0)
; Argumentos:	R2 - coluna em que o objeto está
;				R6 - largura do rover
;				R7 - sentido de movimento do rover (valor a somar à coluna
;				em cada movimento: +1 para a direita, -1 para a esquerda)
;
; Retorna: 	R7 - 0 se já tiver chegado ao limite, inalterado caso contrário	
; **********************************************************************
testa_limites:
	PUSH	R5
	PUSH	R6
	PUSH	R8
testa_limite_esquerdo:			; vê se o rover chegou ao limite esquerdo
	MOV	R5, MIN_COLUNA
	MOV R8, [R2]
	CMP	R8, R5					; verifica se estamos na coluna esquerda
	JGT	testa_limite_direito	; se não, testa o limite direito
	CMP	R7, 0					; passa a deslocar-se para a direita
	JGE	sai_testa_limites
	JMP	impede_movimento		; entre limites. Mantém o valor do R7
testa_limite_direito:			; vê se o rover chegou ao limite direito
	MOV R8, [R2]
	ADD	R6, R8					; posição a seguir ao extremo direito do rover
	MOV	R5, MAX_COLUNA			
	CMP	R6, R5					; verifica se estamos na coluna direita - largura do rover
	JLE	sai_testa_limites		; entre limites. Mantém o valor do R7
	CMP	R7, 0					; passa a deslocar-se para a direita
	JGT	impede_movimento		; caso R7 seja maior
	JMP	sai_testa_limites
impede_movimento:
	MOV	R7, 0					; impede o movimento, forçando R7 a 0
sai_testa_limites:	
	POP R8
	POP	R6
	POP	R5
	RET

; **********************************************************************
; ESPERA_NAO_TECLA - espera que nenhuma tecla esteja a ser premida no 
;					 teclado
; **********************************************************************
espera_nao_tecla:
ciclo:	MOV  R6, LINHA_TECLADO	; linha a testar no teclado
		CALL teclado			; leitura às teclas
		CMP	 R0, 0				; verifica se foi premida uma tecla
		JNZ	 ciclo				; espera, enquanto não houver tecla
		RET

; **********************************************************************
; TECLADO - Faz uma leitura às teclas de uma linha do teclado e retorna 
;			o valor lido
; Argumentos:	R6 - linha a testar (em formato 1, 2, 4 ou 8)
;
; Retorna: 	R0 - valor da coluna e linha no formato LLCC
; **********************************************************************
teclado:
	PUSH	R2
	PUSH	R3
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R8


	MOV  R8, 16				; registo para verificar qunado chegamos ao fim do teclado
le_linha_teclado:
	MOV  R2, TEC_LIN		; endereço do periférico das linhas
	MOV  R3, TEC_COL		; endereço do periférico das colunas
	MOV  R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOVB [R2], R6			; escrever no periférico de saída (linhas)
	MOVB R0, [R3]			; ler do periférico de entrada (colunas)
	AND  R0, R5				; elimina bits para além dos bits 0-3
	CMP	 R0, 0				; verifica se leu alguma tecla da linha que estamos a ler
	JZ	 prox_linha_teclado ; próxima linha do teclado
	SHL  R6, 4				; ajusta o valor da linha para juntar ao da coluna
	OR	 R0, R6				; junta a linha e a coluna num só valor 00clH
	JMP	 fim_teclado		; salta para o fim da rotina
	
prox_linha_teclado:			; passa para a leitura da próxima linha do teclado
	SHL  R6, 1				; passa para a próxima linha
	CMP  R6, R8				; verifica se chegámos à última linha
	JNZ  le_linha_teclado	; salta para ler a nova linha

fim_teclado:
	POP R8
	POP R7
	POP R6
	POP	R5
	POP	R3
	POP	R2
	RET

; **********************************************************************
; ALTERA_CONTADOR -  Soma ou subtrai uma unidade do display de 7
;					 segmentos, apenas em decimal.
;					 Display = A + B + C
; Argumentos:	R7 - valor +1 ou -1 (somar ou subtrair energia) 
;
; **********************************************************************
altera_contador:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R6
	PUSH R8

	MOV R2, [R4]		; valor da energia atual
	ADD R2, R7			; altera o valor no registo
	MOV R7, 100			; define R7 a 100 para comparar com o valor de R2
	CMP R2, R7			; compara o valor que ficará no display com 100
	JLT comeca_calculo	; se for maior, teremos de ficar só com o 100, pois não pode ser maior que isso
	MOV R2, 100			; define o valor do contador para 100


comeca_calculo:
	MOV [R4], R2		; atualiza o valor na tabela da energia
calculo_A:				; Calcula o valor de A = (in//100) * 256
	MOV  R2, 100        ; R2 = 100
	MOV  R3, [R4]		; R3 = in
	DIV  R3, R2			; R3 = in//100
	MOV  R2, 256		; R2 = 256
	MUL  R3, R2			; R3 = (in//100) *  256  (valor de A)
calculo_provisorio_C:	; Calcula o valor provisório de C = in % 10
	MOV  R2, 100		; R2 = 100
	MOV  R1, [R4]		; R1 = in
	MOD  R1, R2			; R1 = in % 10  (valor de A)
calculo_B:				; Calcula o valor de B = (C//10) * 16
	MOV  R2, 10         ; R2 = 10
	MOV  R6, R1			; R6 = C
	DIV  R6, R2			; R6 = C//10
	MOV  R2, 16			; R2 = 16
	MUL  R6, R2			; R6 = (C//10) * 16  (valor de B)
calculo_C:				; Calcula o valor de C = C % 10
	MOV  R2, 10			; R2 = 10
	MOD  R1, R2			; R1 = C % 10  (valor de C)
soma_ABC:
	MOV  R8, 0			; R8 = 0
	ADD  R8, R3			; R8 = A
	ADD  R8, R1			; R8 = A + B
	ADD  R8, R6			; R8 = A + B + C

	MOV R5, DISPLAYS	; endereço do comando para o Display de 7 segmentos
	MOV [R5], R8		; atualizar o valor do display

fim_altera_contador:
	POP  R8
	POP  R6
	POP  R5
	POP  R3
	POP  R2
	POP  R1
	RET

; **********************************************************************
; TOCA_SOM - Toca o som passado, apenas uma vez
;
; Argumentos: R9 - som
; **********************************************************************
toca_som:
	MOV [TOCA_SOM], R9		; toca o som
	MOV [PARA_SOM], R9		; para o som
	RET

; **********************************************************************
; TOCA_SOM_CONTINUAMENTE - Toca o som de fundo
;
; Argumentos: R9 - som
; **********************************************************************
toca_som_continuamente:
	MOV [TOCA_SOM], R9		; toca o som
	MOV R9, 25				; define R9 a 25 para mudar o volume
	MOV [VOLUME_SOM], R9	; altera o volume
	RET

; **********************************************************************
; PARA_SOM - Para o som passado
;
; Argumentos: R9 - som
; **********************************************************************
para_som:
	MOV [PARA_SOM], R9		; Para de tocar o som
	RET

; **********************************************************************
; PERDER - Rotina que trata do cenário em que o jogador perde, mostrando
;		   o ecrã de derrota e esperando pelo comando de recomeço
; **********************************************************************
perder:
	MOV R1, 3							; Seleciona o fundo de derrota
	MOV [SELECIONA_CENARIO_FUNDO], R1	; Define o fundo para o fundo de derrota
	MOV [APAGA_ECRÃ], R1				; Apaga todos os elementos do ecrã
	MOV R10, TECLA_C					; Armazena em R10 o valor da Tecla C
	MOV R6, LINHA_TECLADO				; Armazena em R6 o valor inicial da linha do teclado

	MOV R9, 4							; Seleciona o som de derrota
	CALL para_som						; Toca o som de derrota

	CALL espera_nao_tecla				; Espera que nenhuma tecla esteja a ser premida
ciclo_perder:							; Neste ciclo esperamos o comando para reiniciar o jogo
	CALL teclado						; Procura por uma tecla premida
	CMP R0, R10							; Verifica se a tecla premida foi a tecla C
	JNZ ciclo_perder					; Se não for a tecla C, repete o ciclo. Se for, continua 

	CALL espera_nao_tecla				; Espera que nenhuma tecla esteja a ser premida
	CALL reset_jogo						; Chama a rotina que dá reset às posições dos objetos do jogo

fim_perder:
	RET

; **********************************************************************
; PAUSA -  Rotina que trata do cenário em que o jogador prime a Telca D
;		   para pausar o jogo, mostrando uma tela de pausa e desativando
;		   o jogo temporariamente
; **********************************************************************
pausa:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R6
	PUSH R10

	MOV [APAGA_ECRÃ], R0				; Apaga todos os componentes no ecrã
	MOV R0, 2							; Escolhe o cenário de fundo de pausa
	MOV [SELECIONA_CENARIO_FUNDO], R0	; Define o cenário de fundo para o cenário de pausa
	MOV R10, TECLA_D					; Armazena o valor da tecla D em R10
	MOV R6, LINHA_TECLADO				; Armazena o valor da primeira linha do teclado em R6
	
	CALL espera_nao_tecla				; Espera que nenhuma tecla esteja a ser premida

ciclo_pausa:							; Ciclo que espera o jogador clicar na tecla D para continuar o jogo
	CALL teclado						; Procura por uma tecla premida
	CMP R0, R10							; Verifica se a tecla premida é a tecla D
	JNZ ciclo_pausa						; Se não for, repete o ciclo. Se for, continua

	CALL espera_nao_tecla				; Espera que nenhuma tecla esteja a ser premida

fim_pausa:								; Define Registos para redesenhar o rover que não é 
	MOV R1, linha_rover					;	desenhado automaticamente ao continuar o programa
	MOV R2, coluna_rover
	MOV R4, DEF_ROVER
	CALL desenha_objeto

	POP R10
	POP R6
	POP R4
	POP R2
	POP R1
	POP R0
	RET

; **********************************************************************
; RESET_JOGO - Rotina que trata de redefinir os valores inicias das
;			   compoentes do jogo, como a energia e as posições inicias
;			   dos meteoros
; **********************************************************************
reset_jogo:
	MOV R4, DEF_ENERGIA			; Endereço para a tabela de energia
	MOV R2, 100					; Registo que armazena o novo valor da energia
	MOV [R4], R2				; Define a energia a 100

	MOV R4, linha_rover			; Endereço para a tabela da linha do rover

	MOV R2, LINHA_ROVER			; Armazena em R2 a linha inicial do rover
	MOV [R4], R2				; Define a linha do rover para a sua linha inicial
	ADD R4, 2					; Salta para o próximo endereço
	MOV R2, COLUNA_ROVER		; Armazena em R2 a coluna inicial do rover
	MOV [R4], R2				; Define a coluna do rover para a sua coluna inicial no centro do ecrã

	MOV R4, tipo_meteoro		; Endereço para a tabela dos tipos de meteoros

	MOV R2, 0					; Primeiro meteoro é mau
	MOV [R4], R2				; Define o primeiro meteoro como mau
	ADD R4, 2					; Salta para o próximo meteoro
	MOV R2, 1					; Segundo meteoro é bom
	MOV [R4], R2				; Define o segundo meteoro como bom
	ADD R4, 2					; Salta para o próximo meteoro
	MOV R2, 1					; Terceiro meteoro é bom
	MOV [R4], R2				; Define o terceiro meteoro como bom
	ADD R4, 2					; Salta para o próximo meteoro
	MOV R2, 0					; Quarto meteoro é mau
	MOV [R4], R2				; Define o quarto meteoro como mau
	
	MOV R4, linhas_meteoro		; Endereço para a tabela das linhas dos meteoros

	MOV R2, 5					; Primeiro meteoro na linha 5
	MOV [R4], R2				; Define a linha do primeiro meteoro para a linha 5
	ADD R4, 2					; Salta para a linha do próximo meteoro
	MOV R2, 0					; Segundo meteoro na linha 0
	MOV [R4], R2				; Define a linha do segundo meteoro para a linha 0
	ADD R4, 2					; Salta para a linha do próximo meteoro
	MOV R2, 8					; Terceiro meteoro na linha 8
	MOV [R4], R2				; Define a linha do terceiro meteoro para a linha 8
	ADD R4, 2					; Salta para a linha do próximo meteoro
	MOV R2, 2					; Quarto meteoro na linha 4
	MOV [R4], R2				; Define a linha do quarto meteoro para a linha 2

	MOV R4, colunas_meteoro		; Endereço para a tabela das colunas dos meteoros

	MOV R2, 8					; Primeiro meteoro na coluna 8
	MOV [R4], R2				; Define a coluna do primeiro meteoro para a coluna 5
	ADD R4, 2					; Salta para a coluna do próximo meteoro
	MOV R2, 16					; Segundo meteoro na coluna 16
	MOV [R4], R2				; Define a coluna do segundo meteoro para a coluna 16
	ADD R4, 2					; Salta para a coluna do próximo meteoro
	MOV R2, 32					; Terceiro meteoro na coluna 32
	MOV [R4], R2				; Define a coluna do terceiro meteoro para a coluna 32
	ADD R4, 2					; Salta para a coluna do próximo meteoro
	MOV R2, 48					; Quarto meteoro na coluna 48
	MOV [R4], R2				; Define a coluna do quarto meteoro para a coluna 48

	RET


