.data
msgNum: .asciiz "Digite um número: "
espaco: .asciiz " "
.text

#printa a msg
la $a0, msgNum
addi $v0, $zero, 4
syscall

#le o número
addi $v0, $zero, 5
syscall

#chama a função com o valor lido
add $a0, $zero, $v0
jal imp_ordem_decrescente

#encerrar o programa
addi $v0, $zero, 10
syscall




imp_ordem_decrescente: #a0 é n
	#se 0 < n for falso sair
	slt $t0, $zero, $a0
	beq $t0, $zero, sair
	
	#salva registradores usados na pilha
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $v0, 4($sp)
	sw $a0, 0($sp)
	
	#printa o valor
	addi $v0, $zero, 1
	syscall
	
	#printa um espaço
	la $a0, espaco
	addi $v0, $zero, 4
	syscall
	
	#carrega o a0 de volta pois ele foi alterado
	lw $a0, 0($sp)
	
	#chama a função com n-1
	addi $a0, $a0 -1
	jal imp_ordem_decrescente
	
	#carrega registradores usados da pilha
	lw $ra, 8($sp)
	lw $v0, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 12
	
	sair:
	jr $ra