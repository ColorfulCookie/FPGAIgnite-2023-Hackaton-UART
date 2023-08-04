set ::env(DESIGN_NAME) {uartus}
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]
set ::env(CLOCK_PORT) {I_clk}
set ::env(CLOCK_PERIOD) {100.0} ; # 100 nanoseconds -> 10MHz
set ::env(DESIGN_IS_CORE) {1}