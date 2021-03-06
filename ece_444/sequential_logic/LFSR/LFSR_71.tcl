transcript off
# stop previous simulations
quit -sim

cd {C:\Users\User\Documents\College\Senior Year\autumn-2020\ece_444\sequential_logic\LFSR}
vlib work
vmap work work

# compile the program and test-bench files
vcom LFSR_71.vhd
vcom test_LFSR_71.vhd

# initializing the simulation window and adding waves to the simulation window.
vsim test_LFSR_71
add wave sim:/test_LFSR_71/dev_to_test/*

# define simulation time
run 20 ms
# zoom out
wave zoom full