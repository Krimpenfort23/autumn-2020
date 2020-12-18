transcript off
# stop previous simulations
quit -sim

# select a directory for creation of the work directory
cd {C:\Users\User\Documents\College\Senior Year\autumn-2020\ece_444\advanced_designs\hmwk5}
vlib work
vmap work work

# compile the program and test-bench files
vcom hex_to_7_seg.vhd
vcom RC_receiver_students.vhd
vcom test_RC_receiver.vhd

# initialize the simulation window and add waves to the simulation window
vsim test_RC_receiver
add wave sim:/test_RC_receiver/dev_to_test/*

# define simulation time
run 5248210 ns
# zoom out
wave zoom full