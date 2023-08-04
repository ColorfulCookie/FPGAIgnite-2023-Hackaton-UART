#Run the script using verilog_conversion <filename.vhdl filename.vhdl>
ghdl -a $1
ghdl synth --out=verilog $1 > $1.v
ghdl -a $2
ghdl synth --out=verilog $2 > $2.v
