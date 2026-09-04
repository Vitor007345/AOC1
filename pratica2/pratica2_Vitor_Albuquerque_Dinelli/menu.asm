.data

menuText: .asciiz "Escolha uma das opções a seguir\n1 - primeiro número digitado é maior do que a subtração do maior número pelo menor?\n2 - Somatório\n3 - Sequencia"
opcaoText: .asciiz "\nDigite a opção: "
erroText: .asciiz "\nNúmero invalido digite numeros de 1 a 3"

numText1: .asciiz "Digite o primeiro número: "
numText2: .asciiz "Digite o segundo numero: "

somaMsg1: .asciiz "Digite um número: "
somaMsg2: .asciiz "O resultado é: "

espaco: .asciiz " "

.text


la $a0, menuText
addi $v0, $zero, 4
syscall

doWhile:
	la $a0, opcaoText
	addi $v0, $zero, 4
	syscall
	
	addi $v0, $zero, 5
	syscall
	add $s0, $zero, $v0
	slti $t0, $s0, 1
	bne $t0, $zero, valorErrado
	addi $t1, $zero, 3
	slt $t0, $t1, $s0
	bne $t0, $zero, valorErrado
	
	
	j endDoWhile
	
	valorErrado:
		la $a0, erroText
		addi $v0, $zero, 4
		syscall
		j doWhile
endDoWhile:



#switchcase
addi $t0, $zero, 1
addi, $t1, $zero, 2
addi, $t2, $zero, 3
beq, $s0, $t0, case1
beq $s0, $t1, case2
beq $s0, $t2, case3

case1:
	la $a0, numText1
	addi $v0, $zero, 4
	syscall
	
	addi $v0, $zero, 5
	syscall
	add $s1, $zero, $v0
	
	la $a0, numText2
	addi $v0, $zero, 4
	syscall
	
	addi $v0, $zero, 5
	syscall
	add $s2, $zero, $v0
	
	add $a0, $zero, $s1
	add $a1, $zero, $s2
	
	jal numeros
	
	add $a0, $zero, $v0
	addi $v0, $zero, 1
	syscall
	j endCase
case2:
	la $a0, somaMsg1
	addi $v0, $zero, 4
	syscall
	
	addi $v0, $zero, 5
	syscall
	add $a0, $zero, $v0
	
	jal somatorio
	
	add $s1, $zero, $v0
	
	la $a0, somaMsg2
	addi $v0, $zero, 4
	syscall
	
	add $a0, $zero, $s1
	addi $v0, $zero, 1
	syscall
	
	j endCase
case3:
	la $a0, somaMsg1
	addi $v0, $zero, 4
	syscall
	
	addi $v0, $zero, 5
	syscall
	add $a0, $zero, $v0
	
	jal sequencia
	
	j endCase

endCase:



addi $v0, $zero, 10
syscall



#rotinas

numeros:
	slt $t0, $a0, $a1
	beq $t0, $zero primeiroMaior
		sub $t1, $a1, $a0
		j endIf
	primeiroMaior:
		sub $t1, $a0, $a1
	endIf:
	slt $v0, $t1, $a0
	jr $ra
	
	
somatorio:
	add $t0, $zero, $a0
	addi $t1, $t0, -1
	loop: 
		slt $t3, $zero, $t1
		beq $t3, $zero, end

		add $t0, $t0, $t1
		addi $t1, $t1, -1

		j loop
	end: 
	add $v0, $zero, $t0
	jr $ra

		
sequencia:
	#salvar coisas na pilha
	addi, $sp, $sp, -16
	sw $a0, 12($sp)
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $v0, 0($sp)
	
	#relizar as coisa da função
	add $s0, $zero, $a0
	
	slt $t0, $zero, $s0
	beq $t0, $zero, endFunc

	addi $a0, $zero, 1
	addi $v0, $zero, 1
	syscall

	la $a0, espaco
	addi $v0, $zero, 4
	syscall

	add $s0, $s0, -1
	addi $s1, $zero, 2


	loop2: beq $s0, $zero, endFunc
		add $v0, $zero, 1
		add $a0, $zero, $s1
		syscall

		la $a0, espaco
		addi $v0, $zero, 4
		syscall

		addi $s1, $s1, 2
		addi $s0, $s0, -1
		j loop2

	endFunc:
	
	#carregar valores da pilha
	lw $a0, 12($sp)
	lw $s0, 8($sp)
	lw $s1, 4($sp)
	lw $v0, 0($sp)
	addi, $sp, $sp, 16
	#sair
	jr $ra


