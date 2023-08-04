@echo off

del /s /q sim
mkdir sim
cd sim

echo "Analyzing"
ghdl -a --std=08 ../vhdl/uart_clock.vhd
ghdl -a --std=08 ../vhdl/uart.vhd
ghdl -a --std=08 ../tb/uart_tb.vhd

echo "Elaborating"
ghdl -e --std=08 uart_tb

echo "Running"
ghdl -r --std=08 uart_tb --wave=../sim/uart_tb.ghw > ../sim/uart_tb.log 2> ../sim/uart_tb.err

cd ../../../
