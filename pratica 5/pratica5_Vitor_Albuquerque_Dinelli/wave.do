onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_bancoDeReg/Read1
add wave -noupdate /tb_bancoDeReg/Read2
add wave -noupdate /tb_bancoDeReg/WriteReg
add wave -noupdate /tb_bancoDeReg/WriteData
add wave -noupdate /tb_bancoDeReg/RegWrite
add wave -noupdate /tb_bancoDeReg/clock
add wave -noupdate /tb_bancoDeReg/Data1
add wave -noupdate /tb_bancoDeReg/Data2
add wave -noupdate /tb_bancoDeReg/fase
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 195
configure wave -valuecolwidth 41
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
WaveRestoreZoom {0 ps} {420 ns}
