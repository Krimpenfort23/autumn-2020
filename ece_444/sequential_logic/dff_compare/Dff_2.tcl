transcript off
quit -sim
cd {}
vlib work
vmap work work
vcom Dff_2.vhd
vcom test_Dff_2.vhd
vsim test Dff_2
add wave sim:/test_Dff_2/dev_to_test/*
run 166 ns
wave zoom full