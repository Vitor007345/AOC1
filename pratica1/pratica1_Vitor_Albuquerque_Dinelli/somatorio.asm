.data
msg: .asciiz "Digite um número: "
msg2:.asciiz "O resultado é: "
.text

#printar a msg
la $a0, msg
addi $v0, $zero, 4
syscall

#ler o valor
addi $v0, $zero, 5
syscall

#salvar o valor
add $s0, $zero, $v0 


#calcular somatorio
addi $s1, $s0, -1

loop: slt $t0, $zero, $s1
beq $t0, $zero, end

add $s0, $s0, $s1
addi $s1, $s1, -1

j loop
end: la $a0, msg2
addi $v0, $zero, 4
syscall

#printar resultado
add $a0, $zero, $s0
addi $v0, $zero, 1
syscall

#finalizar programa
addi $v0, $zero, 10
syscall




