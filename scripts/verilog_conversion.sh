
ghdl -a --std=08 ../rtl/vhdl/uart_clock.vhd
ghdl -a --std=08 ../rtl/vhdl/uartus.vhd
#ghdl synth --std=08 --out=verilog uart_clock > uart_clock.v
ghdl synth --std=08 --out=verilog uartus > uart.v
