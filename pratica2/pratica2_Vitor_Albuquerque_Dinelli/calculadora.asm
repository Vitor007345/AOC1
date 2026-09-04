.data
msgNum: .asciiz "Digite um número: "
msgOp: .asciiz "1-soma - 2-subtração - 3-multiplicação - 4-exponencial\nDigite uma opção: "
erroMsg: .asciiz "operação invalida\n"
endl: .asciiz "\n"

operacoes:
	.word soma
	.word subtracao
	.word multi
	.word expo

.text


jal lerDigito
add $s0, $zero $v0
jal lerDigito
add $s1, $zero, $v0

la $a0 endl
addi $v0, $zero, 4
syscall

doWhile:
	jal lerOpcao
	
	#carregar os valores nos parametros
	add $a2, $zero, $v0
	add $a0, $zero, $s0
	add $a1, $zero, $s1
	jal executarOp #executar a operação
	
	add $s2, $zero, $v0
	
	la $a0 endl
	addi $v0, $zero, 4
	syscall
		
	bne $v1, $zero, fimDoWhile #verificar se a operação foi valida
	
	#printar msg de erro e voltar no loop
	la $a0 erroMsg
	addi $v0, $zero, 4
	syscall
	j doWhile
		
fimDoWhile:

#printar o resultado da operação
add $a0, $zero, $s2
jal printNum

#encerrar o programa
addi $v0, $zero, 10
syscall



lerValorComTexto: #texto em $a0
	#printar texto
	addi $v0, $zero, 4
	syscall
	
	#ler valor
	addi $v0, $zero, 5
	syscall
	
	jr $ra

lerDigito:
	#salvar na pilha
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	
	la $a0, msgNum
	jal lerValorComTexto
	
	#carregar da pilha
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra

lerOpcao:
	#salvar na pilha
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	
	la $a0, msgOp
	jal lerValorComTexto
	
	#carregar da pilha
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
executarOp: #a0->num1 a1->num2 a2->op $v0<-resultado $v1<-operaçãoValida
	
	
	#salvar na pilha
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	#testar validade das opções
	slt $t0, $zero, $a2
	beq $t0, $zero, opInvalida
	addi $t0, $zero, 5
	slt $t0, $a2, $t0
	beq $t0, $zero, opInvalida
	
	#escolher e realizar a operação
	la $s0, operacoes
	addi $t0, $a2, -1
	add $t0, $t0, $t0
	add $t0, $t0, $t0
	add $t0, $t0, $s0
	lw $t0, 0($t0)
	jalr $t0
	
	addi $v1, $zero, 1 #settar a flag como 1(operação valida)
	sair:
	#carregar da pilha
	lw $ra, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
	
	opInvalida:
		addi $v1, $zero, 0 #settar a flag como 0(operação invalida)
		j sair
	

soma:
	add $v0, $a0, $a1
	jr $ra

subtracao:
	sub $v0, $a0, $a1
	jr $ra

multi:
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $v0, $zero, 0
	addi $t0, $zero, 0
	loop0: slt $t1, $t0, $a1
	beq $t1, $zero, fimLoop0
		add $v0, $v0, $a0 #realiza sucetivas somas salvando em $v0
		addi $t0, $t0, 1
		j loop0
	fimLoop0:
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
expo:
	#salvar o valores antigos dos registradores usados
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)

	add $s0, $zero, $a0
	add $s1, $zero, $a1
	
	addi $v0, $zero, 1
	addi $t0, $zero, 0
	loop1: slt $t1, $t0, $s1
	beq $t1, $zero, fimLoop1
		
		#realiza sucetivas multiplicações salvando em $v0
		add $a0, $zero, $v0
		add $a1, $zero, $s0
		jal multi
		
		addi $t0, $t0, 1
		j loop1
	fimLoop1:
	
	#carregar o valores antigos dos registradores usados
	lw $ra, 16($sp)
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	lw $s0, 4($sp)
	lw $s1, 0($sp)
	addi $sp, $sp, 20
	
	jr $ra
		
	
printNum:
	addi $v0, $zero, 1
	syscall
	jr $ra
	
	
	
