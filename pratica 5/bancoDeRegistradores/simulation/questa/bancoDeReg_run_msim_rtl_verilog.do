transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica\ 5/bancoDeRegistradores {/home/oem/Documentos/AOC/AOC1/pratica 5/bancoDeRegistradores/decodificador.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica\ 5/bancoDeRegistradores {/home/oem/Documentos/AOC/AOC1/pratica 5/bancoDeRegistradores/bancoDeReg.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica\ 5/bancoDeRegistradores {/home/oem/Documentos/AOC/AOC1/pratica 5/bancoDeRegistradores/top_bancoDeReg.v}

vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica\ 5/bancoDeRegistradores {/home/oem/Documentos/AOC/AOC1/pratica 5/bancoDeRegistradores/tb_bancoDeReg.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  tb_bancoDeReg

add wave *
view structure
view signals
run -all
