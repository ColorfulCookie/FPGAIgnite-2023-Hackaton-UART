@echo off

del /s /q sim
mkdir sim
cd sim

echo "Analyzing"
ghdl -a --std=08 ../vhdl/uart_clock.vhd
ghdl -a --std=08 ../vhdl/uartus.vhd
ghdl -a --std=08 ../tb/uartus_tb.vhd

echo "Elaborating"
ghdl -e --std=08 uartus_tb

echo "Running"
ghdl -r --std=08 uartus_tb --wave=../sim/uartus_tb.ghw > ../sim/uartus_tb.log 2> ../sim/uartus_tb.err

cd ../../../
