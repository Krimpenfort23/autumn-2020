transcript off
# stop previous simulations
quit -sim

# select a directory for creation of the work directory
cd {C:\Users\User\Documents\College\Senior Year\autumn-2020\ece_444\sequential_logic\mult_2}
vlib work
vmap work work

# compile the program and test-bench files
vcom sim_mem_init.vhd
vcom mult.vhd
vcom test_mult.vhd

# initialize the simulation window and add waves to the simulation window
vsim test_mult
add wave sim:/test_mult/dev_to_test/*

# define simulation time
run 970 ns
# zoom out
wave zoom full