transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/memoriaDados.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/ULA.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/somador.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/parameterAdder.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/extensorSinal.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/decodificador.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/bancoDeReg.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/PC.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/cpuMimps.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/memoriaInstrucoes.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/bin2bcd.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/debounce.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/Top_cpu.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/ULActrl.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/control.v}

vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/tb_cpuMimps.v}
vlog  -work work +incdir+/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps {/home/oem/Documentos/AOC/AOC1/pratica8/pratica8_Vitor_Albuquerque_Dinelli/cpuMimps/cpuMimps.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  tb_cpuMimps

add wave *
view structure
view signals
run -all
