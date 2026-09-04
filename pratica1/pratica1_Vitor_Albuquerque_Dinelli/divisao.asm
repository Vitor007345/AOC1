.data
dividentoTxt: .asciiz "Dividendo: "
divisorTxt: .asciiz "Divisor: "
quocienteTxt: .asciiz " (quociente) "
restoTxt: .asciiz " (resto)"
barraTxt: .asciiz " / "
igualTxt: .asciiz " = "
.text

#printar texto dividendo
la $a0, dividentoTxt
addi $v0, $zero, 4
syscall

#ler dividendo
addi $v0, $zero, 5
syscall
add $s0, $zero, $v0

#printar texto divisor
la $a0, divisorTxt
addi $v0, $zero, 4
syscall

#ler divisor
addi $v0, $zero, 5
syscall
add $s1, $zero, $v0

addi $s2, $zero, 0 #quociente = 0
add $t0, $zero, $s0 #x = dividendo

loop: slt $t1, $t0, $s1
bne $t1, $zero, endLoop
	sub $t0, $t0, $s1 # x = x - divisor
	addi $s2, $s2, 1 #quociente = quociente + 1
	j loop
endLoop:

add $s3, $zero, $t0 #resto = x

#print(f"{dividendo} / {divisor} = {quociente} (quociente) {resto} (resto)")
add $a0, $zero, $s0
addi $v0, $zero, 1
syscall

la $a0, barraTxt
addi $v0, $zero, 4
syscall

add $a0, $zero, $s1
addi $v0, $zero, 1
syscall

la $a0, igualTxt
addi $v0, $zero, 4
syscall

add $a0, $zero, $s2
addi $v0, $zero, 1
syscall

la $a0, quocienteTxt
addi $v0, $zero, 4
syscall

add $a0, $zero, $s3
addi $v0, $zero, 1
syscall

la $a0, restoTxt
addi $v0, $zero, 4
syscall

#finalizar programa
addi $v0, $zero, 10
syscall




