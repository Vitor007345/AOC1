transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica4/ex2 {/home/oem/Documentos/AOC/AOC1/pratica4/ex2/memoriaDados.v}

vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica4/ex2 {/home/oem/Documentos/AOC/AOC1/pratica4/ex2/tb_memoriaDados.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  tb_memoriaDados

add wave *
view structure
view signals
run -all
