transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica4/ex4 {/home/oem/Documentos/AOC/AOC1/pratica4/ex4/extensorSinal.v}

vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica4/ex4 {/home/oem/Documentos/AOC/AOC1/pratica4/ex4/tb_extensorSinal.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  tb_extensorSinal

add wave *
view structure
view signals
run -all
