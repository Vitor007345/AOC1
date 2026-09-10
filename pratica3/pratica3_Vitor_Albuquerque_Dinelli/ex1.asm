.data
msgNum: .asciiz "Digite um Número: "
msgResposta: .asciiz "O resultado é: "
.text

#printar msg
la $a0, msgNum
addi $v0, $zero, 4
syscall

#ler  o valor
addi $v0, $zero, 5
syscall

#executar a função
add $a0, $zero, $v0
jal f

add $s0, $zero, $v0 #salvar retorno da função

#printar msg resposta
la $a0, msgResposta
addi $v0, $zero, 4
syscall

#printar resultado
add $a0, $zero, $s0
addi $v0 $zero, 1
syscall

#finalizar o programa
addi $v0 $zero, 10
syscall






f: #n salvo em #a0, retorno em $v0

	#caso base
	addi $t0, $zero, 3
	slt $t0, $a0, $t0
	bne $t0, $zero, base
	
	#salvar registradores usados na pilha
	addi $sp, $sp, -16
	sw $a0, 12($sp)
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	
	
	#primeira recursividade
	addi $a0, $a0, -2
	jal f
	add $s0, $zero, $v0
	
	#segunda recursividade
	addi $a0, $a0, -1 #faz -1 pois ele já estava n-2 pra ficar n-3
	jal f
	add $s1, $zero, $v0
	
	
	#volta o $a0, pra ser n
	addi $a0, $a0, 3
	
	#operações da função
	add $s1, $s1, $s1 #multiplica H(N-3) * 2
	add $s1, $s1, $a0 #soma com N
	
	
	add $v0, $s0, $s1 #soma o H(N-2) com o resto
	
	#carrehar registradores usados da pilha
	lw $a0, 12($sp)
	lw $s0, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra
	
	base:
		add $v0, $a0, $a0
		addi $v0, $v0, 1
		jr $ra
	
