module uart_clock
  (input  I_clk,
   input  I_reset,
   input  [31:0] I_sampling_delay,
   output O_clk);
  reg s_clk;
  reg [31:0] s_counter;
  wire [30:0] n5_o;
  wire [31:0] n6_o;
  wire [30:0] n7_o;
  wire [31:0] n8_o;
  wire [31:0] n10_o;
  wire [31:0] n12_o;
  wire n13_o;
  wire n14_o;
  wire [30:0] n15_o;
  wire [31:0] n16_o;
  wire [31:0] n18_o;
  wire [30:0] n19_o;
  wire [31:0] n20_o;
  wire [31:0] n23_o;
  wire n30_o;
  reg n31_q;
  wire n32_o;
  wire [31:0] n33_o;
  reg [31:0] n34_q;
  assign O_clk = s_clk;
  /* uart_clock.vhd:19:12  */
  always @*
    s_clk = n31_q; // (isignal)
  initial
    s_clk = 1'b0;
  /* uart_clock.vhd:21:12  */
  always @*
    s_counter = n34_q; // (isignal)
  initial
    s_counter = 32'b00000000000000000000000000000000;
  /* uart_clock.vhd:30:16  */
  assign n5_o = s_counter[30:0];  // trunc
  /* uart_clock.vhd:30:38  */
  assign n6_o = {1'b0, n5_o};  //  uext
  /* uart_clock.vhd:30:40  */
  assign n7_o = I_sampling_delay[30:0];  // trunc
  /* uart_clock.vhd:30:79  */
  assign n8_o = {1'b0, n7_o};  //  uext
  /* uart_clock.vhd:30:79  */
  assign n10_o = n8_o / 32'b00000000000000000000000000000010; // sdiv
  /* uart_clock.vhd:30:83  */
  assign n12_o = n10_o - 32'b00000000000000000000000000000001;
  /* uart_clock.vhd:30:38  */
  assign n13_o = n6_o == n12_o;
  /* uart_clock.vhd:31:30  */
  assign n14_o = ~s_clk;
  /* uart_clock.vhd:34:42  */
  assign n15_o = s_counter[30:0];  // trunc
  /* uart_clock.vhd:34:64  */
  assign n16_o = {1'b0, n15_o};  //  uext
  /* uart_clock.vhd:34:64  */
  assign n18_o = n16_o + 32'b00000000000000000000000000000001;
  /* uart_clock.vhd:34:42  */
  assign n19_o = n18_o[30:0];  // trunc
  /* uart_clock.vhd:34:30  */
  assign n20_o = {1'b0, n19_o};  //  uext
  /* uart_clock.vhd:30:13  */
  assign n23_o = n13_o ? 32'b00000000000000000000000000000000 : n20_o;
  /* uart_clock.vhd:28:13  */
  assign n30_o = n13_o ? n14_o : s_clk;
  /* uart_clock.vhd:28:13  */
  always @(negedge I_clk or posedge I_reset)
    if (I_reset)
      n31_q <= 1'b0;
    else
      n31_q <= n30_o;
  /* uart_clock.vhd:24:5  */
  assign n32_o = ~I_reset;
  /* uart_clock.vhd:28:13  */
  assign n33_o = n32_o ? n23_o : s_counter;
  /* uart_clock.vhd:28:13  */
  always @(negedge I_clk)
    n34_q <= n33_o;
  initial
    n34_q = 32'b00000000000000000000000000000000;
endmodule

