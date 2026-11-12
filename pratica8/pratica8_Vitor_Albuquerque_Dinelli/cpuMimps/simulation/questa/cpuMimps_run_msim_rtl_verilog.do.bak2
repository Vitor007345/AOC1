transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/memoriaDados.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/ULA.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/somador.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/parameterAdder.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/extensorSinal.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/decodificador.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/bancoDeReg.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/PC.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/mux.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/cpuMimps.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/memoriaInstrucoes.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/bin2bcd.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/debounce.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/Top_cpu.v}

vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica6/cpuMimps/tb_cpuMimps.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  tb_cpuMimps

add wave *
view structure
view signals
run -all
