transcript off
# stop previous simulations
quit -sim

# select a directory for creation of the work directory
cd {C:\Users\User\Documents\College\Senior Year\autumn-2020\ece_444\sequential_logic\counter}
vlib work
vmap work work

# compile the program and test-bench files
vcom counter.vhd
vcom test_counter.vhd

# initialize the simulation window and add waves to the simulation window
vsim test_counter
add wave sim:/test_counter/dev_to_test/*

# define simulation time
run 4000 ns
# zoom out
wave zoom full