transcript off
# stop previous simulations
quit -sim

# select a directory for creation of the work directory
cd {C:\Users\User\Documents\College\Senior Year\autumn-2020\ece_444\combo_logic\hmwk2}
vlib work
vmap work work

# compile the program and test-bench files
vcom Alu.vhd
vcom test_Alu.vhd

# initialize the simulation window and add waves to the simulation window
vsim test_Alu
add wave sim:/test_Alu/dev_to_test/*

# define simulation time
run 1600 us
# zoom out
wave zoom full