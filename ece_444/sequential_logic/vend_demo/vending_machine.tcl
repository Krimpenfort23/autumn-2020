transcript off
# stop previous simulations
quit -sim

# select a directory for creation of the work directory
cd {C:\Users\User\Documents\College\Senior Year\autumn-2020\ece_444\sequential_logic\vend_demo}
vlib work
vmap work work

# compile the program and test-bench files
vcom sim_mem_init.vhd
vcom vending_machine.vhd
vcom test_vending_machine.vhd

# initialize the simulation window and add waves to the simulation window
vsim test_vending_machine
add wave sim:/test_vending_machine/dev_to_test/*

# define simulation time
run 1290 ns
# zoom out
wave zoom full