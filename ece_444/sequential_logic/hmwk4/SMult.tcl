transcript off
# stop previous simulations
quit -sim

# select a directory for creation of the work directory
cd {C:\Users\User\Documents\College\Senior Year\autumn-2020\ece_444\sequential_logic\hmwk4}
vlib work
vmap work work

# compile the program and test-bench files
vcom sim_mem_init.vhd
vcom SMult.vhd
vcom test_SMult.vhd

# initialize the simulation window and add waves to the simulation window
vsim test_SMult
add wave sim:/test_SMult/dev_to_test/*

# define simulation time
run 2010 ns
# zoom out
wave zoom full