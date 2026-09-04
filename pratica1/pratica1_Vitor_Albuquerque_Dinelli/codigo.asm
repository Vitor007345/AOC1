.data
vetor: .word 0:19  #vetor de 20 posições
msgNum: .asciiz "Informe um número "
msgNovosValor: .asciiz "Novos valores de V: "
espaco: .asciiz " "
.text

la $s0, vetor

#for
addi $s1, $zero, 0
addi $s2, $zero, 20
loop: slt $t0, $s1, $s2
beq $t0, $zero, endLoop
	#multiplicar por 4
	add $t1, $s1, $s1
	add $t1, $t1, $t1
	add $t1, $t1, $s0 #somar no endereço

	#imprime texto pra informar o valor
	la $a0, msgNum
	addi $v0, $zero, 4
	syscall

	#ler valor digitado
	addi $v0, $zero, 5 
	syscall

	sw $v0, 0($t1) #salvar valor digitado


	addi $s1, $s1, 1
	j loop
endLoop:

addi $s1, $zero, 0
addi $s2, $zero, 0
addi $s3, $zero, 20

#while
loop2: slt $t0, $s1, $s3
beq $t0, $zero, endLoop2
	#acessar posição n-1 (19)
	addi $t1, $s3, -1
	add $t1, $t1, $t1
	add $t1, $t1, $t1
	add $t1, $t1, $s0
	
	#x = x + v[n-1]
	lw $t2, 0($t1)
	add $s2, $s2, $t2
	
	#acessar posição i
	add $t1, $s1, $s1
	add $t1, $t1, $t1
	add $t1, $t1, $s0
	
	#v[i] = x;
	sw $s2, 0($t1)
	
	
	addi $s1, $s1, 1
	j loop2
endLoop2:

la $a0, msgNovosValor
addi $v0, $zero, 4
syscall

addi $s1, $zero, 0
addi $s2, $zero, 20
loop3: slt $t0, $s1, $s2
beq $t0, $zero, endLoop3
	#acessar posição i
	add $t1, $s1, $s1
	add $t1, $t1, $t1
	add $t1, $t1, $s0
	
	lw $a0, 0($t1) #carregar valor
	addi $v0, $zero, 1 #imprime valor
	syscall
	
	#imprime espaço
	la $a0, espaco
	addi $v0, $zero, 4
	syscall

	addi $s1, $s1, 1
	j loop3
endLoop3:

addi $v0, $zero, 10
syscall



