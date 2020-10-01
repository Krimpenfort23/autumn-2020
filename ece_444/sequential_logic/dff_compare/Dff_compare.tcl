transcript off
quit -sim
cd {}
vlib work
vmap work work
vcom Dff_1.vhd
vcom Dff_2.vhd
vcom Dff_compare.vhd
vcom test_Dff_compare.vhd
vsim test Dff_1
add wave sim:/test_Dff_compare/dev_to_test/*
run 300 ns
wave zoom full