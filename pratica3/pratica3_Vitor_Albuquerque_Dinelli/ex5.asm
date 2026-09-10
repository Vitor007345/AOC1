.data
msgNum: .asciiz "Entre com um número: "
msgResp0: .asciiz "A série de Fibonacci para "
msgResp1: .asciiz " elementos é:\n"
virgulaEspaco: .asciiz ", "
ok: .asciiz "\nOk"
.text

#printa a msg
la $a0, msgNum
addi $v0, $zero, 4
syscall

#le o número e salva em $s0
addi $v0, $zero, 5
syscall
add $s0, $zero, $v0

#printa a resposta0
la $a0, msgResp0
addi $v0, $zero, 4
syscall

#printa o numero
add $a0 $zero, $s0
addi $v0, $zero, 1
syscall

#printa a resposta1
la $a0, msgResp1
addi $v0, $zero, 4
syscall

#for pra printar a sequencia
addi $s0, $s0, 1 #soma 1 pra simular o <=
addi $s1, $zero, 1 #$s1 representa o i do for
loop: slt $t0, $s1, $s0
beq $t0, $zero, fimLoop
	#cahama a função com $s1
	add $a0, $zero, $s1
	jal fibonacci
	
	#printa o resultado da função
	add $a0, $zero, $v0
	addi $v0, $zero, 1
	syscall
	
	#printa a virgula e o espaco
	la $a0, virgulaEspaco
	addi $v0, $zero, 4
	syscall
	
	addi $s1, $s1, 1
	j loop


fimLoop:

#printa o ok
la $a0, ok
addi $v0, $zero, 4
syscall

#encerra o programa
addi $v0, $zero, 10
syscall



fibonacci: #$a0 é o n
	
	#testar se é, o caso base
	addi $t0, $zero, 1
	addi $t1, $zero, 2
	beq $a0, $t0, base
	beq $a0, $t1, base
	
	#salvar registradores usados na pilha
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	sw $a0, 0($sp)
	
	#chama a função com n-1
	addi $a0, $a0, -1
	jal fibonacci
	add $s0, $zero, $v0
	
	lw $a0, 0($sp) #carrega valor de $a0 da pilha pois ele foi alterado
	
	#cahama a função com n-2
	addi $a0, $a0, -2
	jal fibonacci
	
	#atualiza para o valor correto de retorno
	add $v0, $s0, $v0
	
	#carrega registradores usados da pilha
	lw $ra, 8($sp)
	lw $s0, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra
	
	
	base:
		addi $v0, $zero, 1
		jr $ra