.data
arr: .word 0:9
msgNum: .asciiz "Digite um número: "
msgResposta: .asciiz "O maior é: "

.text


la $s0, arr
addi $s1, $zero, 10 #tamanho

addi $t0, $zero, 0
loop0: slt $t1, $t0, $s1
beq $t1, $zero, fimLoop0
	
	#multiplica $t0 por 4
	add $t1, $t0, $t0
	add $t1, $t1, $t1
	add $t1, $t1, $s0 #carrega o endereço da posição do vetor 
	
	#printa a msg
	la $a0, msgNum
	addi $v0, $zero, 4
	syscall
	
	#le e salva no vetor o número
	addi $v0, $zero, 5
	syscall
	sw $v0, 0($t1)
	
	addi $t0, $t0, 1
	j loop0
fimLoop0:

#cahamando a função passando $s0 e $s1
add $a0, $zero, $s0
add $a1, $zero, $s1
jal max
add $s2, $zero, $v0 #salvando resultado da função

#printa a msgResposta
la $a0, msgResposta
addi $v0, $zero, 4
syscall

#printa o max
add $a0, $zero, $s2
addi $v0, $zero, 1
syscall

#encerra o programa
addi $v0, $zero, 10
syscall




max: #$a0 vetor $a1, tamanho

	#caso base
	addi $t0, $zero, 1
	bne $a1, $t0, fimIf
	
		lw $v0, 0($a0) #retorna v[0]
		jr $ra
	
	fimIf:
	
	#salvar na pilha
	addi $sp, $sp, -8
	sw $a1, 4($sp)
	sw $ra, 0($sp)
	
	addi $a1, $a1, -1 #chamar a função com n-1
	jal max
	
	#carregar valores da pilha
	lw $a1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	add $t0, $zero, $v0 #salva o valore de retorno da função em $t0
	
	#carrega a posição v[n-1]
	addi $t1, $a1, -1
	add $t1, $t1, $t1
	add $t1, $t1, $t1
	add $t1, $t1, $a0
	lw $t1, 0($t1)
	
	
	slt $t2, $t0, $t1
	beq $t2, $zero, anteriorMaior
		add $v0, $zero, $t1
		jr $ra
	anteriorMaior:
		add $v0, $zero, $t0
		jr $ra
		
