transcript on
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work ../../rtl/vhdl/uart_clock.vhd
vcom -2008 -work work ../../rtl/vhdl/uartus.vhd
vcom -2008 -work work ../main.vhd

vcom -2008 -work work ../test_ram_component/test_ram.vhd
vcom -2008 -work work ../tb/main_tb.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclone10lp -L rtl_work -L work -voptargs="+acc"  main_tb

# add wave *
#add wave sim:/main_tb/uut/global_control_inst/*

# add wave sim:/main_tb/uut/UART/uart_memory_addr_counter_inst/*
# add wave sim:/main_tb/uut/neural_network_inst/nn_network_controller_inst/*
add wave sim:/main_tb/uut/*
view structure
view signals
run 40 ms