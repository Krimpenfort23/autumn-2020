transcript off
# stop previous simulations
quit -sim

cd {C:\Users\User\Documents\College\Senior Year\autumn-2020\ece_444\sequential_logic\LFSR}
vlib work
vmap work work

# compile the program and test-bench files
vcom LFSR_18.vhd
vcom test_LFSR_18.vhd

# initializing the simulation window and adding waves to the simulation window.
vsim test_LFSR_18
add wave sim:/test_LFSR_18/dev_to_test/*

# define simulation time
run 5242890 ns
# zoom out
wave zoom full