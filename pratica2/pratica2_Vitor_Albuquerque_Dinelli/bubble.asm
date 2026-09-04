.data
arr: .word 0:9
msgNum: .asciiz "Digite um número: "
espaco: .asciiz " "
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


add $a0, $zero, $s0
add $a1, $zero, $s1
jal bSort

#printar o arr
addi $t0, $zero, 0
loop1: slt $t1, $t0, $s1
beq $t1, $zero, fimLoop1
	
	#multiplica $t0 por 4
	add $t1, $t0, $t0
	add $t1, $t1, $t1
	add $t1, $t1, $s0 #carrega o endereço da posição do vetor 
	
	
	
	#carrega e printa os valores do vetor
	lw $a0, 0($t1)
	addi $v0, $zero, 1
	syscall
	
	#printa um espaço
	la $a0, espaco
	addi $v0, $zero, 4
	syscall
	
	addi $t0, $t0, 1
	j loop1
fimLoop1:

addi $v0, $zero, 10
syscall






bSort:	#a0 vetor #a1 tamanho
	
	#salvar registradores usados na pilha
	addi $sp, $sp, -12
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	
	
	addi $s0, $zero, 0 #flag
	
	while: bne $s0, $zero, fimWhile #repete até q a flag seja 1(até q esteja ordenado)
		
		addi $s0, $zero, 1 #supoem q está ordenado
		
		addi $t0, $zero, 0
		addi $t1, $a1, -1
		
		for: slt $t2, $t0, $t1
		beq $t2, $zero, fimFor
			
			#multiplica por 4
			add $s1, $t0, $t0
			add $s1, $s1, $s1
			addi $s2, $s1, 4#pega o proximo valor
			
			#carrega os valores
			add $s1, $s1, $a0
			add $s2, $s2, $a0
			lw $t3, 0($s1)
			lw $t4, 0($s2)
			
			#comparar qual é maior
			slt $t2, $t3, $t4
			beq $t2, $zero, fimIf
				
				#troca os 2
				sw $t4, 0($s1)
				sw $t3, 0($s2)
				
				addi $s0, $zero, 0 #muda a flag para falso, não terminou de ordenar
			
			fimIf:
			
			
		
			addi $t0, $t0, 1
			j for
		fimFor:
		
		j while
	fimWhile:
	
	#carregar registradores usado de volta
	lw $s0, 8($sp)
	lw $s1, 4($sp)
	lw $s2, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra
	
	
	