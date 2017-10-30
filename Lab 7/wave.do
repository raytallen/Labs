onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testcpu/DUT/clk
add wave -noupdate /testcpu/DUT/reset
add wave -noupdate /testcpu/DUT/FSM/present_state
add wave -noupdate /testcpu/DUT/reset_pc
add wave -noupdate /testcpu/DUT/load_pc
add wave -noupdate /testcpu/DUT/prog/next_pc
add wave -noupdate /testcpu/DUT/prog/PC_out
add wave -noupdate /testcpu/DUT/mem_cmd
add wave -noupdate /testcpu/DUT/addr_sel
add wave -noupdate /testcpu/DUT/mem_addr
add wave -noupdate /testcpu/DUT/FSM/present_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {130 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 188
configure wave -valuecolwidth 88
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {561 ps}
