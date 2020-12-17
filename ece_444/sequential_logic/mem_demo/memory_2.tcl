transcript off
# stop previous simulations
quit -sim

# select a directory for creation of the work directory
cd {C:\Users\User\Documents\College\Senior Year\autumn-2020\ece_444\sequential_logic\mem_demo}
vlib work
vmap work work

# compile the program and test-bench files
vcom sim_mem_init.vhd
vcom memory_2.vhd
vcom test_memory_2.vhd

# initialize the simulation window and add waves to the simulation window
vsim test_memory_2
add wave sim:/test_memory_2/dev_to_test/*

# define simulation time
run 5120 ns
# zoom out
wave zoom full