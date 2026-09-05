.data
msgNum: .asciiz "Digite um número: "
msgResposta: .asciiz "O resultado é: "
.text

#printar a msg
la $a0, msgNum
addi $v0, $zero, 4
syscall

#ler e guardar o valor
addi $v0, $zero, 5
syscall
add $a0, $zero, $v0

jal f

add $s0, $zero, $v0

#printar resposta
la $a0, msgResposta
addi $v0, $zero, 4
syscall

add $a0, $zero, $s0
addi $v0, $zero, 1
syscall


addi $v0, $zero, 10
syscall




f:	#valor de entrada em $a0
	
	#testar se é o caso base
	addi $t0, $zero, 4
	slt $t0, $a0, $t0
	bne $t0, $zero, base
	
	#slvar valores na pilha
	addi $sp, $sp, -8
	sw $a0, 4($sp)
	sw $ra, 0($sp)
	
	addi $a0, $a0, -4
	jal f #chama f(N - 4)
	add $v0, $v0, $v0 #multiplica por 2
	addi $v0, $v0, 5 #soma 5
	
	#carregar valores da pilha
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra
	base:
		add $v0, $a0, $a0
		add $v0, $v0, $a0
		jr $ra
