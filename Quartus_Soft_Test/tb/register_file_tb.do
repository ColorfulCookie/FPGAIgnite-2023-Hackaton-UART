transcript on
vlib rtl_work
vmap work rtl_work


vcom -2008 -work work ../submodules/register_file.vhd
vcom -2008 -work work ../tb/register_file_tb.vhd

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclone10lp -L rtl_work -L work -voptargs="+acc"  register_file_tb

# add wave *
#add wave sim:/main_tb/uut/global_control_inst/*

add wave sim:/register_file_tb/uut/*
view structure
view signals
run 1 ms