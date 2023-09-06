module uart_clock
  (input  i_clk,
   input  i_reset,
   input  [31:0] i_sampling_delay,
   output o_clk);
  reg s_clk;
  reg [31:0] s_counter;
  wire [30:0] n325_o;
  wire [31:0] n326_o;
  wire [30:0] n327_o;
  wire [31:0] n328_o;
  wire [31:0] n330_o;
  wire [31:0] n332_o;
  wire n333_o;
  wire n334_o;
  wire [30:0] n335_o;
  wire [31:0] n336_o;
  wire [31:0] n338_o;
  wire [30:0] n339_o;
  wire [31:0] n340_o;
  wire [31:0] n343_o;
  wire n350_o;
  reg n351_q;
  wire n352_o;
  wire [31:0] n353_o;
  reg [31:0] n354_q;
  assign o_clk = s_clk;
  /* ../rtl/vhdl/uart_clock.vhd:19:12  */
  always @*
    s_clk = n351_q; // (isignal)
  initial
    s_clk = 1'b0;
  /* ../rtl/vhdl/uart_clock.vhd:20:12  */
  always @*
    s_counter = n354_q; // (isignal)
  initial
    s_counter = 32'b00000000000000000000000000000000;
  /* ../rtl/vhdl/uart_clock.vhd:28:18  */
  assign n325_o = s_counter[30:0];  // trunc
  /* ../rtl/vhdl/uart_clock.vhd:28:41  */
  assign n326_o = {1'b0, n325_o};  //  uext
  /* ../rtl/vhdl/uart_clock.vhd:28:44  */
  assign n327_o = i_sampling_delay[30:0];  // trunc
  /* ../rtl/vhdl/uart_clock.vhd:28:83  */
  assign n328_o = {1'b0, n327_o};  //  uext
  /* ../rtl/vhdl/uart_clock.vhd:28:83  */
  assign n330_o = n328_o / 32'b00000000000000000000000000000010; // sdiv
  /* ../rtl/vhdl/uart_clock.vhd:28:87  */
  assign n332_o = n330_o - 32'b00000000000000000000000000000001;
  /* ../rtl/vhdl/uart_clock.vhd:28:41  */
  assign n333_o = n326_o == n332_o;
  /* ../rtl/vhdl/uart_clock.vhd:29:30  */
  assign n334_o = ~s_clk;
  /* ../rtl/vhdl/uart_clock.vhd:32:42  */
  assign n335_o = s_counter[30:0];  // trunc
  /* ../rtl/vhdl/uart_clock.vhd:32:64  */
  assign n336_o = {1'b0, n335_o};  //  uext
  /* ../rtl/vhdl/uart_clock.vhd:32:64  */
  assign n338_o = n336_o + 32'b00000000000000000000000000000001;
  /* ../rtl/vhdl/uart_clock.vhd:32:42  */
  assign n339_o = n338_o[30:0];  // trunc
  /* ../rtl/vhdl/uart_clock.vhd:32:30  */
  assign n340_o = {1'b0, n339_o};  //  uext
  /* ../rtl/vhdl/uart_clock.vhd:28:13  */
  assign n343_o = n333_o ? 32'b00000000000000000000000000000000 : n340_o;
  /* ../rtl/vhdl/uart_clock.vhd:27:9  */
  assign n350_o = n333_o ? n334_o : s_clk;
  /* ../rtl/vhdl/uart_clock.vhd:27:9  */
  always @(negedge i_clk or posedge i_reset)
    if (i_reset)
      n351_q <= 1'b0;
    else
      n351_q <= n350_o;
  /* ../rtl/vhdl/uart_clock.vhd:23:5  */
  assign n352_o = ~i_reset;
  /* ../rtl/vhdl/uart_clock.vhd:27:9  */
  assign n353_o = n352_o ? n343_o : s_counter;
  /* ../rtl/vhdl/uart_clock.vhd:27:9  */
  always @(negedge i_clk)
    n354_q <= n353_o;
  initial
    n354_q = 32'b00000000000000000000000000000000;
endmodule

module uartus
  (input  I_clk,
   input  I_rst,
   input  [7:0] I_tx_data_word,
   input  I_tx_start,
   input  I_rx_data,
   input  [1:0] I_cfg_parity_setting,
   input  [31:0] I_cfg_clkSpeed_over_bdRate,
   output O_tx_data,
   output O_tx_ready,
   output O_rx_finished,
   output [7:0] O_rx_data_word);
  reg [31:0] sampling_delay;
  reg [1:0] rx_state;
  reg [7:0] rx_reg;
  reg [5:0] rx_bit_counter;
  reg rx_counter_rst;
  reg rx_uart_clk;
  reg [1:0] tx_state;
  reg [10:0] tx_reg;
  reg [3:0] tx_bit_counter;
  reg tx_counter_rst;
  reg tx_start_internal;
  reg tx_uart_clk;
  wire uart_clk_rx_ent_n20;
  wire uart_clk_rx_ent_o_clk;
  localparam n23_o = 1'b0;
  wire uart_clk_tx_ent_n24;
  wire uart_clk_tx_ent_o_clk;
  wire n29_o;
  wire [1:0] n32_o;
  wire n34_o;
  wire n36_o;
  wire [31:0] n37_o;
  wire n39_o;
  wire [1:0] n41_o;
  wire n43_o;
  wire n45_o;
  wire [3:0] n46_o;
  reg [1:0] n49_o;
  reg n54_o;
  wire [1:0] n56_o;
  wire n57_o;
  wire n64_o;
  wire n66_o;
  wire n68_o;
  wire n70_o;
  wire [3:0] n71_o;
  reg n76_o;
  reg [7:0] n77_o;
  wire n79_o;
  wire [7:0] n80_o;
  wire n87_o;
  wire [31:0] n88_o;
  wire [31:0] n90_o;
  wire [5:0] n91_o;
  wire [31:0] n99_o;
  wire n101_o;
  wire [31:0] n102_o;
  wire n104_o;
  wire n105_o;
  wire [31:0] n106_o;
  wire n108_o;
  wire [31:0] n109_o;
  wire [31:0] n111_o;
  wire [2:0] n112_o;
  wire [7:0] n115_o;
  wire [7:0] n116_o;
  wire [7:0] n118_o;
  wire [1:0] n125_o;
  wire n127_o;
  wire n129_o;
  wire [31:0] n130_o;
  wire n132_o;
  wire [1:0] n134_o;
  wire n136_o;
  wire n138_o;
  wire [3:0] n139_o;
  reg [1:0] n142_o;
  reg n147_o;
  wire [1:0] n149_o;
  wire n150_o;
  wire n157_o;
  wire n158_o;
  wire n161_o;
  wire n163_o;
  wire n168_o;
  wire n170_o;
  wire [1:0] n171_o;
  reg n175_o;
  wire n180_o;
  wire [31:0] n181_o;
  wire [31:0] n183_o;
  wire [3:0] n184_o;
  wire [31:0] n192_o;
  wire n194_o;
  wire [31:0] n195_o;
  wire n197_o;
  wire n198_o;
  wire [31:0] n199_o;
  wire [31:0] n201_o;
  wire [3:0] n202_o;
  wire n205_o;
  wire n207_o;
  wire n212_o;
  wire [9:0] n214_o;
  wire [10:0] n216_o;
  wire n218_o;
  wire [9:0] n220_o;
  wire [10:0] n222_o;
  wire n224_o;
  wire n225_o;
  wire n226_o;
  wire [1:0] n228_o;
  wire [9:0] n229_o;
  wire [10:0] n231_o;
  wire n233_o;
  wire n234_o;
  wire [1:0] n236_o;
  wire [9:0] n237_o;
  wire [10:0] n239_o;
  wire [9:0] n241_o;
  wire [10:0] n243_o;
  wire [10:0] n244_o;
  wire [10:0] n245_o;
  wire [10:0] n246_o;
  wire [10:0] n247_o;
  reg [1:0] n249_q;
  reg [7:0] n250_q;
  wire [5:0] n251_o;
  reg [5:0] n252_q;
  reg n253_q;
  reg [1:0] n254_q;
  wire [3:0] n255_o;
  reg [3:0] n256_q;
  reg n257_q;
  reg n258_q;
  reg n259_q;
  reg n260_q;
  reg [7:0] n261_q;
  wire n262_o;
  wire n263_o;
  wire n264_o;
  wire n265_o;
  wire n266_o;
  wire n267_o;
  wire n268_o;
  wire n269_o;
  wire n270_o;
  wire n271_o;
  wire n272_o;
  wire n273_o;
  wire n274_o;
  wire n275_o;
  wire n276_o;
  wire n277_o;
  wire n278_o;
  wire n279_o;
  wire n280_o;
  wire n281_o;
  wire n282_o;
  wire n283_o;
  wire n284_o;
  wire n285_o;
  wire n286_o;
  wire n287_o;
  wire n288_o;
  wire n289_o;
  wire n290_o;
  wire n291_o;
  wire n292_o;
  wire n293_o;
  wire n294_o;
  wire n295_o;
  wire [7:0] n296_o;
  wire n297_o;
  wire n298_o;
  wire n299_o;
  wire n300_o;
  wire n301_o;
  wire n302_o;
  wire n303_o;
  wire n304_o;
  wire n305_o;
  wire n306_o;
  wire n307_o;
  wire [1:0] n308_o;
  reg n309_o;
  wire [1:0] n310_o;
  reg n311_o;
  wire n312_o;
  wire n313_o;
  wire n314_o;
  wire n315_o;
  wire n316_o;
  wire n317_o;
  wire n318_o;
  wire n319_o;
  assign O_tx_data = n259_q;
  assign O_tx_ready = n175_o;
  assign O_rx_finished = n260_q;
  assign O_rx_data_word = n261_q;
  /* ../rtl/vhdl/uartus.vhd:41:12  */
  always @*
    sampling_delay = I_cfg_clkSpeed_over_bdRate; // (isignal)
  initial
    sampling_delay = 32'b00000000000000000000000000000000;
  /* ../rtl/vhdl/uartus.vhd:44:12  */
  always @*
    rx_state = n249_q; // (isignal)
  initial
    rx_state = 2'b00;
  /* ../rtl/vhdl/uartus.vhd:45:12  */
  always @*
    rx_reg = n250_q; // (isignal)
  initial
    rx_reg = 8'b11111111;
  /* ../rtl/vhdl/uartus.vhd:46:12  */
  always @*
    rx_bit_counter = n252_q; // (isignal)
  initial
    rx_bit_counter = 6'b000000;
  /* ../rtl/vhdl/uartus.vhd:47:12  */
  always @*
    rx_counter_rst = n253_q; // (isignal)
  initial
    rx_counter_rst = 1'b0;
  /* ../rtl/vhdl/uartus.vhd:48:12  */
  always @*
    rx_uart_clk = uart_clk_rx_ent_n20; // (isignal)
  initial
    rx_uart_clk = 1'b0;
  /* ../rtl/vhdl/uartus.vhd:51:12  */
  always @*
    tx_state = n254_q; // (isignal)
  initial
    tx_state = 2'b00;
  /* ../rtl/vhdl/uartus.vhd:52:12  */
  always @*
    tx_reg = n247_o; // (isignal)
  initial
    tx_reg = 11'b11111111111;
  /* ../rtl/vhdl/uartus.vhd:53:12  */
  always @*
    tx_bit_counter = n256_q; // (isignal)
  initial
    tx_bit_counter = 4'b0000;
  /* ../rtl/vhdl/uartus.vhd:54:12  */
  always @*
    tx_counter_rst = n257_q; // (isignal)
  initial
    tx_counter_rst = 1'b0;
  /* ../rtl/vhdl/uartus.vhd:55:12  */
  always @*
    tx_start_internal = n258_q; // (isignal)
  initial
    tx_start_internal = 1'b0;
  /* ../rtl/vhdl/uartus.vhd:57:12  */
  always @*
    tx_uart_clk = uart_clk_tx_ent_n24; // (isignal)
  initial
    tx_uart_clk = 1'b0;
  /* ../rtl/vhdl/uartus.vhd:74:29  */
  assign uart_clk_rx_ent_n20 = uart_clk_rx_ent_o_clk; // (signal)
  /* ../rtl/vhdl/uartus.vhd:69:5  */
  uart_clock uart_clk_rx_ent (
    .i_clk(I_clk),
    .i_reset(rx_counter_rst),
    .i_sampling_delay(sampling_delay),
    .o_clk(uart_clk_rx_ent_o_clk));
  /* ../rtl/vhdl/uartus.vhd:81:29  */
  assign uart_clk_tx_ent_n24 = uart_clk_tx_ent_o_clk; // (signal)
  /* ../rtl/vhdl/uartus.vhd:76:5  */
  uart_clock uart_clk_tx_ent (
    .i_clk(I_clk),
    .i_reset(n23_o),
    .i_sampling_delay(sampling_delay),
    .o_clk(uart_clk_tx_ent_o_clk));
  /* ../rtl/vhdl/uartus.vhd:96:39  */
  assign n29_o = ~I_rx_data;
  /* ../rtl/vhdl/uartus.vhd:96:25  */
  assign n32_o = n29_o ? 2'b01 : 2'b00;
  /* ../rtl/vhdl/uartus.vhd:94:21  */
  assign n34_o = rx_state == 2'b00;
  /* ../rtl/vhdl/uartus.vhd:101:21  */
  assign n36_o = rx_state == 2'b01;
  /* ../rtl/vhdl/uartus.vhd:106:44  */
  assign n37_o = {26'b0, rx_bit_counter};  //  uext
  /* ../rtl/vhdl/uartus.vhd:106:44  */
  assign n39_o = $signed(n37_o) >= $signed(32'b00000000000000000000000000001010);
  /* ../rtl/vhdl/uartus.vhd:106:25  */
  assign n41_o = n39_o ? 2'b11 : rx_state;
  /* ../rtl/vhdl/uartus.vhd:104:21  */
  assign n43_o = rx_state == 2'b10;
  /* ../rtl/vhdl/uartus.vhd:111:21  */
  assign n45_o = rx_state == 2'b11;
  assign n46_o = {n45_o, n43_o, n36_o, n34_o};
  /* ../rtl/vhdl/uartus.vhd:93:17  */
  always @*
    case (n46_o)
      4'b1000: n49_o = 2'b00;
      4'b0100: n49_o = n41_o;
      4'b0010: n49_o = 2'b10;
      4'b0001: n49_o = n32_o;
      default: n49_o = rx_state;
    endcase
  /* ../rtl/vhdl/uartus.vhd:93:17  */
  always @*
    case (n46_o)
      4'b1000: n54_o = 1'b0;
      4'b0100: n54_o = 1'b0;
      4'b0010: n54_o = 1'b1;
      4'b0001: n54_o = 1'b0;
      default: n54_o = rx_counter_rst;
    endcase
  /* ../rtl/vhdl/uartus.vhd:90:13  */
  assign n56_o = I_rst ? 2'b00 : n49_o;
  /* ../rtl/vhdl/uartus.vhd:90:13  */
  assign n57_o = I_rst ? rx_counter_rst : n54_o;
  /* ../rtl/vhdl/uartus.vhd:127:21  */
  assign n64_o = rx_state == 2'b00;
  /* ../rtl/vhdl/uartus.vhd:130:21  */
  assign n66_o = rx_state == 2'b01;
  /* ../rtl/vhdl/uartus.vhd:133:21  */
  assign n68_o = rx_state == 2'b10;
  /* ../rtl/vhdl/uartus.vhd:136:21  */
  assign n70_o = rx_state == 2'b11;
  assign n71_o = {n70_o, n68_o, n66_o, n64_o};
  /* ../rtl/vhdl/uartus.vhd:126:17  */
  always @*
    case (n71_o)
      4'b1000: n76_o = 1'b1;
      4'b0100: n76_o = 1'b0;
      4'b0010: n76_o = 1'b0;
      4'b0001: n76_o = n260_q;
      default: n76_o = 1'b0;
    endcase
  /* ../rtl/vhdl/uartus.vhd:126:17  */
  always @*
    case (n71_o)
      4'b1000: n77_o = rx_reg;
      4'b0100: n77_o = n261_q;
      4'b0010: n77_o = n261_q;
      4'b0001: n77_o = n261_q;
      default: n77_o = n261_q;
    endcase
  /* ../rtl/vhdl/uartus.vhd:123:13  */
  assign n79_o = I_rst ? 1'b0 : n76_o;
  /* ../rtl/vhdl/uartus.vhd:123:13  */
  assign n80_o = I_rst ? n261_q : n77_o;
  /* ../rtl/vhdl/uartus.vhd:152:26  */
  assign n87_o = rx_state == 2'b10;
  /* ../rtl/vhdl/uartus.vhd:153:50  */
  assign n88_o = {26'b0, rx_bit_counter};  //  uext
  /* ../rtl/vhdl/uartus.vhd:153:50  */
  assign n90_o = n88_o + 32'b00000000000000000000000000000001;
  /* ../rtl/vhdl/uartus.vhd:153:35  */
  assign n91_o = n90_o[5:0];  // trunc
  /* ../rtl/vhdl/uartus.vhd:163:35  */
  assign n99_o = {26'b0, rx_bit_counter};  //  uext
  /* ../rtl/vhdl/uartus.vhd:163:35  */
  assign n101_o = $signed(n99_o) > $signed(32'b00000000000000000000000000001000);
  /* ../rtl/vhdl/uartus.vhd:163:57  */
  assign n102_o = {26'b0, rx_bit_counter};  //  uext
  /* ../rtl/vhdl/uartus.vhd:163:57  */
  assign n104_o = $signed(n102_o) < $signed(32'b00000000000000000000000000000001);
  /* ../rtl/vhdl/uartus.vhd:163:39  */
  assign n105_o = n101_o | n104_o;
  /* ../rtl/vhdl/uartus.vhd:165:35  */
  assign n106_o = {26'b0, rx_bit_counter};  //  uext
  /* ../rtl/vhdl/uartus.vhd:165:35  */
  assign n108_o = $signed(n106_o) > $signed(32'b00000000000000000000000000000000);
  /* ../rtl/vhdl/uartus.vhd:166:39  */
  assign n109_o = {26'b0, rx_bit_counter};  //  uext
  /* ../rtl/vhdl/uartus.vhd:166:39  */
  assign n111_o = n109_o - 32'b00000000000000000000000000000001;
  /* ../rtl/vhdl/uartus.vhd:166:39  */
  assign n112_o = n111_o[2:0];  // trunc
  /* ../rtl/vhdl/uartus.vhd:165:13  */
  assign n115_o = n108_o ? n296_o : rx_reg;
  /* ../rtl/vhdl/uartus.vhd:163:13  */
  assign n116_o = n105_o ? rx_reg : n115_o;
  /* ../rtl/vhdl/uartus.vhd:161:13  */
  assign n118_o = I_rst ? 8'b11111111 : n116_o;
  /* ../rtl/vhdl/uartus.vhd:185:25  */
  assign n125_o = tx_start_internal ? 2'b01 : 2'b00;
  /* ../rtl/vhdl/uartus.vhd:183:21  */
  assign n127_o = tx_state == 2'b00;
  /* ../rtl/vhdl/uartus.vhd:190:21  */
  assign n129_o = tx_state == 2'b01;
  /* ../rtl/vhdl/uartus.vhd:195:44  */
  assign n130_o = {28'b0, tx_bit_counter};  //  uext
  /* ../rtl/vhdl/uartus.vhd:195:44  */
  assign n132_o = $signed(n130_o) <= $signed(32'b00000000000000000000000000001011);
  /* ../rtl/vhdl/uartus.vhd:195:25  */
  assign n134_o = n132_o ? tx_state : 2'b11;
  /* ../rtl/vhdl/uartus.vhd:193:21  */
  assign n136_o = tx_state == 2'b10;
  /* ../rtl/vhdl/uartus.vhd:200:21  */
  assign n138_o = tx_state == 2'b11;
  assign n139_o = {n138_o, n136_o, n129_o, n127_o};
  /* ../rtl/vhdl/uartus.vhd:182:17  */
  always @*
    case (n139_o)
      4'b1000: n142_o = 2'b00;
      4'b0100: n142_o = n134_o;
      4'b0010: n142_o = 2'b10;
      4'b0001: n142_o = n125_o;
      default: n142_o = tx_state;
    endcase
  /* ../rtl/vhdl/uartus.vhd:182:17  */
  always @*
    case (n139_o)
      4'b1000: n147_o = 1'b0;
      4'b0100: n147_o = 1'b0;
      4'b0010: n147_o = 1'b1;
      4'b0001: n147_o = 1'b0;
      default: n147_o = tx_counter_rst;
    endcase
  /* ../rtl/vhdl/uartus.vhd:179:13  */
  assign n149_o = I_rst ? 2'b00 : n142_o;
  /* ../rtl/vhdl/uartus.vhd:179:13  */
  assign n150_o = I_rst ? tx_counter_rst : n147_o;
  /* ../rtl/vhdl/uartus.vhd:214:53  */
  assign n157_o = tx_state == 2'b00;
  /* ../rtl/vhdl/uartus.vhd:214:39  */
  assign n158_o = I_tx_start & n157_o;
  /* ../rtl/vhdl/uartus.vhd:214:13  */
  assign n161_o = n158_o ? 1'b1 : 1'b0;
  /* ../rtl/vhdl/uartus.vhd:212:13  */
  assign n163_o = I_rst ? 1'b0 : n161_o;
  /* ../rtl/vhdl/uartus.vhd:225:13  */
  assign n168_o = tx_state == 2'b01;
  /* ../rtl/vhdl/uartus.vhd:227:13  */
  assign n170_o = tx_state == 2'b10;
  assign n171_o = {n170_o, n168_o};
  /* ../rtl/vhdl/uartus.vhd:224:9  */
  always @*
    case (n171_o)
      2'b10: n175_o = 1'b0;
      2'b01: n175_o = 1'b0;
      default: n175_o = 1'b1;
    endcase
  /* ../rtl/vhdl/uartus.vhd:239:26  */
  assign n180_o = tx_state == 2'b10;
  /* ../rtl/vhdl/uartus.vhd:240:50  */
  assign n181_o = {28'b0, tx_bit_counter};  //  uext
  /* ../rtl/vhdl/uartus.vhd:240:50  */
  assign n183_o = n181_o + 32'b00000000000000000000000000000001;
  /* ../rtl/vhdl/uartus.vhd:240:35  */
  assign n184_o = n183_o[3:0];  // trunc
  /* ../rtl/vhdl/uartus.vhd:250:36  */
  assign n192_o = {28'b0, tx_bit_counter};  //  uext
  /* ../rtl/vhdl/uartus.vhd:250:36  */
  assign n194_o = $signed(n192_o) <= $signed(32'b00000000000000000000000000001011);
  /* ../rtl/vhdl/uartus.vhd:250:77  */
  assign n195_o = {28'b0, tx_bit_counter};  //  uext
  /* ../rtl/vhdl/uartus.vhd:250:77  */
  assign n197_o = $signed(n195_o) > $signed(32'b00000000000000000000000000000000);
  /* ../rtl/vhdl/uartus.vhd:250:57  */
  assign n198_o = n194_o & n197_o;
  /* ../rtl/vhdl/uartus.vhd:251:52  */
  assign n199_o = {28'b0, tx_bit_counter};  //  uext
  /* ../rtl/vhdl/uartus.vhd:251:52  */
  assign n201_o = n199_o - 32'b00000000000000000000000000000001;
  /* ../rtl/vhdl/uartus.vhd:251:52  */
  assign n202_o = n201_o[3:0];  // trunc
  /* ../rtl/vhdl/uartus.vhd:250:13  */
  assign n205_o = n198_o ? n319_o : n259_q;
  /* ../rtl/vhdl/uartus.vhd:248:13  */
  assign n207_o = I_rst ? 1'b1 : n205_o;
  /* ../rtl/vhdl/uartus.vhd:261:34  */
  assign n212_o = I_cfg_parity_setting == 2'b00;
  /* ../rtl/vhdl/uartus.vhd:262:33  */
  assign n214_o = {2'b11, I_tx_data_word};
  /* ../rtl/vhdl/uartus.vhd:262:50  */
  assign n216_o = {n214_o, 1'b0};
  /* ../rtl/vhdl/uartus.vhd:263:37  */
  assign n218_o = I_cfg_parity_setting == 2'b11;
  /* ../rtl/vhdl/uartus.vhd:264:33  */
  assign n220_o = {2'b11, I_tx_data_word};
  /* ../rtl/vhdl/uartus.vhd:264:50  */
  assign n222_o = {n220_o, 1'b0};
  /* ../rtl/vhdl/uartus.vhd:265:37  */
  assign n224_o = I_cfg_parity_setting == 2'b01;
  /* ../rtl/vhdl/uartus.vhd:266:29  */
  assign n225_o = ^(I_tx_data_word);
  /* ../rtl/vhdl/uartus.vhd:266:29  */
  assign n226_o = ~n225_o;
  /* ../rtl/vhdl/uartus.vhd:266:27  */
  assign n228_o = {1'b1, n226_o};
  /* ../rtl/vhdl/uartus.vhd:266:57  */
  assign n229_o = {n228_o, I_tx_data_word};
  /* ../rtl/vhdl/uartus.vhd:266:74  */
  assign n231_o = {n229_o, 1'b0};
  /* ../rtl/vhdl/uartus.vhd:267:37  */
  assign n233_o = I_cfg_parity_setting == 2'b10;
  /* ../rtl/vhdl/uartus.vhd:268:29  */
  assign n234_o = ^(I_tx_data_word);
  /* ../rtl/vhdl/uartus.vhd:268:27  */
  assign n236_o = {1'b1, n234_o};
  /* ../rtl/vhdl/uartus.vhd:268:56  */
  assign n237_o = {n236_o, I_tx_data_word};
  /* ../rtl/vhdl/uartus.vhd:268:73  */
  assign n239_o = {n237_o, 1'b0};
  /* ../rtl/vhdl/uartus.vhd:270:33  */
  assign n241_o = {2'b11, I_tx_data_word};
  /* ../rtl/vhdl/uartus.vhd:270:50  */
  assign n243_o = {n241_o, 1'b0};
  /* ../rtl/vhdl/uartus.vhd:267:9  */
  assign n244_o = n233_o ? n239_o : n243_o;
  /* ../rtl/vhdl/uartus.vhd:265:9  */
  assign n245_o = n224_o ? n231_o : n244_o;
  /* ../rtl/vhdl/uartus.vhd:263:9  */
  assign n246_o = n218_o ? n222_o : n245_o;
  /* ../rtl/vhdl/uartus.vhd:261:9  */
  assign n247_o = n212_o ? n216_o : n246_o;
  /* ../rtl/vhdl/uartus.vhd:89:9  */
  always @(posedge I_clk)
    n249_q <= n56_o;
  initial
    n249_q = 2'b00;
  /* ../rtl/vhdl/uartus.vhd:160:9  */
  always @(posedge rx_uart_clk)
    n250_q <= n118_o;
  initial
    n250_q = 8'b11111111;
  /* ../rtl/vhdl/uartus.vhd:151:9  */
  assign n251_o = n87_o ? n91_o : rx_bit_counter;
  /* ../rtl/vhdl/uartus.vhd:151:9  */
  always @(posedge rx_uart_clk or posedge rx_counter_rst)
    if (rx_counter_rst)
      n252_q <= 6'b000000;
    else
      n252_q <= n251_o;
  /* ../rtl/vhdl/uartus.vhd:89:9  */
  always @(posedge I_clk)
    n253_q <= n57_o;
  initial
    n253_q = 1'b0;
  /* ../rtl/vhdl/uartus.vhd:178:9  */
  always @(posedge I_clk)
    n254_q <= n149_o;
  initial
    n254_q = 2'b00;
  /* ../rtl/vhdl/uartus.vhd:238:9  */
  assign n255_o = n180_o ? n184_o : tx_bit_counter;
  /* ../rtl/vhdl/uartus.vhd:238:9  */
  always @(posedge tx_uart_clk or posedge tx_counter_rst)
    if (tx_counter_rst)
      n256_q <= 4'b0000;
    else
      n256_q <= n255_o;
  /* ../rtl/vhdl/uartus.vhd:178:9  */
  always @(posedge I_clk)
    n257_q <= n150_o;
  initial
    n257_q = 1'b0;
  /* ../rtl/vhdl/uartus.vhd:211:9  */
  always @(posedge I_clk)
    n258_q <= n163_o;
  initial
    n258_q = 1'b0;
  /* ../rtl/vhdl/uartus.vhd:247:9  */
  always @(posedge tx_uart_clk)
    n259_q <= n207_o;
  initial
    n259_q = 1'b1;
  /* ../rtl/vhdl/uartus.vhd:122:9  */
  always @(posedge I_clk)
    n260_q <= n79_o;
  initial
    n260_q = 1'b0;
  /* ../rtl/vhdl/uartus.vhd:122:9  */
  always @(posedge I_clk)
    n261_q <= n80_o;
  initial
    n261_q = 8'b11111111;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n262_o = n112_o[2];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n263_o = ~n262_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n264_o = n112_o[1];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n265_o = ~n264_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n266_o = n263_o & n265_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n267_o = n263_o & n264_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n268_o = n262_o & n265_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n269_o = n262_o & n264_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n270_o = n112_o[0];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n271_o = ~n270_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n272_o = n266_o & n271_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n273_o = n266_o & n270_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n274_o = n267_o & n271_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n275_o = n267_o & n270_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n276_o = n268_o & n271_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n277_o = n268_o & n270_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n278_o = n269_o & n271_o;
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n279_o = n269_o & n270_o;
  assign n280_o = rx_reg[0];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n281_o = n272_o ? I_rx_data : n280_o;
  assign n282_o = rx_reg[1];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n283_o = n273_o ? I_rx_data : n282_o;
  assign n284_o = rx_reg[2];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n285_o = n274_o ? I_rx_data : n284_o;
  assign n286_o = rx_reg[3];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n287_o = n275_o ? I_rx_data : n286_o;
  /* ../rtl/vhdl/uartus.vhd:148:5  */
  assign n288_o = rx_reg[4];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n289_o = n276_o ? I_rx_data : n288_o;
  /* ../rtl/vhdl/uartus.vhd:121:5  */
  assign n290_o = rx_reg[5];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n291_o = n277_o ? I_rx_data : n290_o;
  /* ../rtl/vhdl/uartus.vhd:88:5  */
  assign n292_o = rx_reg[6];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n293_o = n278_o ? I_rx_data : n292_o;
  assign n294_o = rx_reg[7];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n295_o = n279_o ? I_rx_data : n294_o;
  assign n296_o = {n295_o, n293_o, n291_o, n289_o, n287_o, n285_o, n283_o, n281_o};
  /* ../rtl/vhdl/uartus.vhd:166:39  */
  assign n297_o = tx_reg[0];
  /* ../rtl/vhdl/uartus.vhd:166:17  */
  assign n298_o = tx_reg[1];
  assign n299_o = tx_reg[2];
  assign n300_o = tx_reg[3];
  assign n301_o = tx_reg[4];
  assign n302_o = tx_reg[5];
  assign n303_o = tx_reg[6];
  assign n304_o = tx_reg[7];
  assign n305_o = tx_reg[8];
  assign n306_o = tx_reg[9];
  assign n307_o = tx_reg[10];
  /* ../rtl/vhdl/uartus.vhd:251:36  */
  assign n308_o = n202_o[1:0];
  /* ../rtl/vhdl/uartus.vhd:251:36  */
  always @*
    case (n308_o)
      2'b00: n309_o = n297_o;
      2'b01: n309_o = n298_o;
      2'b10: n309_o = n299_o;
      2'b11: n309_o = n300_o;
    endcase
  /* ../rtl/vhdl/uartus.vhd:251:36  */
  assign n310_o = n202_o[1:0];
  /* ../rtl/vhdl/uartus.vhd:251:36  */
  always @*
    case (n310_o)
      2'b00: n311_o = n301_o;
      2'b01: n311_o = n302_o;
      2'b10: n311_o = n303_o;
      2'b11: n311_o = n304_o;
    endcase
  assign n312_o = n202_o[0];
  /* ../rtl/vhdl/uartus.vhd:251:36  */
  assign n313_o = n312_o ? n306_o : n305_o;
  assign n314_o = n202_o[1];
  /* ../rtl/vhdl/uartus.vhd:251:36  */
  assign n315_o = n314_o ? n307_o : n313_o;
  assign n316_o = n202_o[2];
  /* ../rtl/vhdl/uartus.vhd:251:36  */
  assign n317_o = n316_o ? n311_o : n309_o;
  assign n318_o = n202_o[3];
  /* ../rtl/vhdl/uartus.vhd:251:36  */
  assign n319_o = n318_o ? n315_o : n317_o;
endmodule

