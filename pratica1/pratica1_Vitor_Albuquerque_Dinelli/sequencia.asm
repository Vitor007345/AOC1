.data
msg: .asciiz "Digite um número: "
espaco: .asciiz " "
.text

#printar msg
la $a0, msg
addi $v0, $zero, 4
syscall

#ler valor
addi $v0, $zero, 5
syscall

#salvar valor
add $s0, $zero, $v0

slt $t0, $zero, $s0
beq $t0, $zero, endProgram

addi $a0, $zero, 1
addi $v0, $zero, 1
syscall

la $a0, espaco
addi $v0, $zero, 4
syscall

add $s0, $s0, -1
addi $s1, $zero, 2


loop: beq $s0, $zero, endProgram
add $v0, $zero, 1
add $a0, $zero, $s1
syscall

la $a0, espaco
addi $v0, $zero, 4
syscall

addi $s1, $s1, 2
addi $s0, $s0, -1
j loop


endProgram: add $v0, $zero, 10
syscall
