@echo off

del /s /q sim
mkdir sim
cd sim

echo "Analyzing"
ghdl -a --std=08 ../vhdl/uart_clock.vhd
ghdl -a --std=08 ../vhdl/uart.vhd
ghdl -a --std=08 ../tb/uart_tb.vhd

@REM echo "Elaborating"
@REM ghdl -e -P=../altera -fsynopsys --std=08 aesInterface_tb

@REM echo "Running"
@REM ghdl -r --std=08 -P=../altera -fsynopsys aesInterface_tb --wave=../sim/aesInterface_tb.ghw > ../sim/aesInterface_tb.log 2> ../sim/aesInterface_tb.err

@REM cd ../../../

@REM echo "synth"
@REM ghdl --synth --std=08 -P=../altera -fsynopsys library.aesInterface
