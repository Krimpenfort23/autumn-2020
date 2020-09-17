transcript off
# stop previous simulations
quit -sim

# select a directory for creation of the work directory
cd {C:\Users\User\Documents\College\Senior Year\autumn-2020\ece_444\combo_logic\hmwk1}
vlib work
vmap work work

# compile the program and test-bench files
vcom h1_behavior.vhd
vcom h1_behavior_test.vhd

# initialize the simulation window and add waves to the simulation window
vsim h1_behavior_test
add wave sim:/test_full_adder_2/dev_to_test/*

# define simulation time
run 80 ns
# zoom out
wave zoom full