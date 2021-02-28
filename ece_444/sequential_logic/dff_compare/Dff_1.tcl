transcript off
quit -sim
cd {}
vlib work
vmap work work
vcom Dff_1.vhd
vcom test_Dff_1.vhd
vsim test Dff_1
add wave sim:/test_Dff_1/dev_to_test/*
run 166 ns
wave zoom full