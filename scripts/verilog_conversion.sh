
ghdl -a --std=08 uart_clock.vhd
ghdl -a --std=08 uart.vhd
#ghdl synth --std=08 --out=verilog uart_clock > uart_clock.v
ghdl synth --std=08 --out=verilog uart > uart.v