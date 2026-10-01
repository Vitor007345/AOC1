onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_memoriaDados/address
add wave -noupdate /tb_memoriaDados/memWrite
add wave -noupdate /tb_memoriaDados/memRead
add wave -noupdate /tb_memoriaDados/clock
add wave -noupdate /tb_memoriaDados/writeData
add wave -noupdate /tb_memoriaDados/readData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 227
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {84 ns}
