transcript off
#stop previous simulations
quit -sim	

# select a directory for creation of the work directory
cd {C:\_Eric\UD\Teaching\ECE501\Designs\Advanced_Designs\Encryption}
vlib work
vmap work work

# compile the program and test-bench files
vcom ../../Sequential_Logic/sim_mem_init/sim_mem_init.vhd
vcom decrypt-students.vhd
vcom test_decrypt.vhd

# initializing the simulation window and adding waves to the simulation window
vsim test_decrypt
add wave sim:/test_decrypt/dev_to_test/*
 
# define simulation time
run 5120 ns
# zoom out
wave zoom full