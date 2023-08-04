module uart_clock
  (input  i_clk,
   input  i_reset,
   input  [31:0] i_sampling_delay,
   output o_clk);
  reg s_clk;
  reg [31:0] s_counter;
  wire [30:0] n251_o;
  wire [31:0] n252_o;
  wire [30:0] n253_o;
  wire [31:0] n254_o;
  wire [31:0] n256_o;
  wire [31:0] n258_o;
  wire n259_o;
  wire n260_o;
  wire [30:0] n261_o;
  wire [31:0] n262_o;
  wire [31:0] n264_o;
  wire [30:0] n265_o;
  wire [31:0] n266_o;
  wire [31:0] n269_o;
  wire n276_o;
  reg n277_q;
  wire n278_o;
  wire [31:0] n279_o;
  reg [31:0] n280_q;
  assign o_clk = s_clk;
  /* uart_clock.vhd:19:12  */
  always @*
    s_clk = n277_q; // (isignal)
  initial
    s_clk = 1'b0;
  /* uart_clock.vhd:21:12  */
  always @*
    s_counter = n280_q; // (isignal)
  initial
    s_counter = 32'b00000000000000000000000000000000;
  /* uart_clock.vhd:30:18  */
  assign n251_o = s_counter[30:0];  // trunc
  /* uart_clock.vhd:30:41  */
  assign n252_o = {1'b0, n251_o};  //  uext
  /* uart_clock.vhd:30:44  */
  assign n253_o = i_sampling_delay[30:0];  // trunc
  /* uart_clock.vhd:30:83  */
  assign n254_o = {1'b0, n253_o};  //  uext
  /* uart_clock.vhd:30:83  */
  assign n256_o = n254_o / 32'b00000000000000000000000000000010; // sdiv
  /* uart_clock.vhd:30:87  */
  assign n258_o = n256_o - 32'b00000000000000000000000000000001;
  /* uart_clock.vhd:30:41  */
  assign n259_o = n252_o == n258_o;
  /* uart_clock.vhd:31:30  */
  assign n260_o = ~s_clk;
  /* uart_clock.vhd:34:42  */
  assign n261_o = s_counter[30:0];  // trunc
  /* uart_clock.vhd:34:64  */
  assign n262_o = {1'b0, n261_o};  //  uext
  /* uart_clock.vhd:34:64  */
  assign n264_o = n262_o + 32'b00000000000000000000000000000001;
  /* uart_clock.vhd:34:42  */
  assign n265_o = n264_o[30:0];  // trunc
  /* uart_clock.vhd:34:30  */
  assign n266_o = {1'b0, n265_o};  //  uext
  /* uart_clock.vhd:30:13  */
  assign n269_o = n259_o ? 32'b00000000000000000000000000000000 : n266_o;
  /* uart_clock.vhd:28:9  */
  assign n276_o = n259_o ? n260_o : s_clk;
  /* uart_clock.vhd:28:9  */
  always @(negedge i_clk or posedge i_reset)
    if (i_reset)
      n277_q <= 1'b0;
    else
      n277_q <= n276_o;
  /* uart_clock.vhd:24:5  */
  assign n278_o = ~i_reset;
  /* uart_clock.vhd:28:9  */
  assign n279_o = n278_o ? n269_o : s_counter;
  /* uart_clock.vhd:28:9  */
  always @(negedge i_clk)
    n280_q <= n279_o;
  initial
    n280_q = 32'b00000000000000000000000000000000;
endmodule

module uart
  (input  clk,
   input  rst,
   input  [7:0] tx_data_word,
   input  tx_start,
   input  rx_data,
   input  [1:0] cfg_parity_setting,
   input  [31:0] cfg_clkSpeed_over_bdRate,
   output tx_data_out,
   output tx_ready,
   output rx_finished_out);
  reg [31:0] sampling_delay;
  reg [1:0] rx_state;
  reg [3:0] rx_bit_counter;
  reg rx_counter_rst;
  reg rx_uart_clk;
  reg [1:0] tx_state;
  reg [10:0] tx_reg;
  reg [3:0] tx_bit_counter;
  reg tx_counter_rst;
  reg tx_start_internal;
  reg tx_parity_bit;
  reg tx_uart_clk;
  wire uart_clk_rx_ent_n19;
  wire uart_clk_rx_ent_o_clk;
  localparam n22_o = 1'b0;
  wire uart_clk_tx_ent_n23;
  wire uart_clk_tx_ent_o_clk;
  wire n28_o;
  wire [1:0] n31_o;
  wire n33_o;
  wire n35_o;
  wire [31:0] n36_o;
  wire n38_o;
  wire [1:0] n40_o;
  wire n42_o;
  wire n44_o;
  wire [3:0] n45_o;
  reg [1:0] n47_o;
  reg n52_o;
  wire [1:0] n54_o;
  wire n55_o;
  wire n62_o;
  wire n64_o;
  wire n66_o;
  wire n68_o;
  wire [3:0] n69_o;
  reg n74_o;
  wire n76_o;
  wire [31:0] n81_o;
  wire [31:0] n83_o;
  wire [3:0] n84_o;
  wire [1:0] n109_o;
  wire n111_o;
  wire n113_o;
  wire [31:0] n114_o;
  wire n116_o;
  wire [1:0] n118_o;
  wire n120_o;
  wire n122_o;
  wire [3:0] n123_o;
  reg [1:0] n125_o;
  reg n130_o;
  wire [1:0] n132_o;
  wire n133_o;
  wire n140_o;
  wire n141_o;
  wire n144_o;
  wire n146_o;
  wire n151_o;
  wire n153_o;
  wire [1:0] n154_o;
  reg n158_o;
  wire [31:0] n162_o;
  wire [31:0] n164_o;
  wire [3:0] n165_o;
  wire [31:0] n172_o;
  wire [31:0] n174_o;
  wire [3:0] n175_o;
  wire n179_o;
  wire [1:0] n184_o;
  wire [9:0] n185_o;
  wire [10:0] n187_o;
  wire n192_o;
  wire n194_o;
  wire n196_o;
  wire n197_o;
  wire n198_o;
  wire n200_o;
  wire n201_o;
  wire n203_o;
  wire n204_o;
  wire n206_o;
  wire n207_o;
  wire n209_o;
  reg [1:0] n212_q;
  reg [3:0] n214_q;
  reg n215_q;
  reg [1:0] n216_q;
  reg [3:0] n217_q;
  reg n218_q;
  reg n219_q;
  reg n220_q;
  reg n221_q;
  reg n222_q;
  wire n223_o;
  wire n224_o;
  wire n225_o;
  wire n226_o;
  wire n227_o;
  wire n228_o;
  wire n229_o;
  wire n230_o;
  wire n231_o;
  wire n232_o;
  wire n233_o;
  wire [1:0] n234_o;
  reg n235_o;
  wire [1:0] n236_o;
  reg n237_o;
  wire n238_o;
  wire n239_o;
  wire n240_o;
  wire n241_o;
  wire n242_o;
  wire n243_o;
  wire n244_o;
  wire n245_o;
  assign tx_data_out = n221_q;
  assign tx_ready = n158_o;
  assign rx_finished_out = n222_q;
  /* uart.vhd:39:12  */
  always @*
    sampling_delay = cfg_clkSpeed_over_bdRate; // (isignal)
  initial
    sampling_delay = 32'b00000000000000000000000000000000;
  /* uart.vhd:42:12  */
  always @*
    rx_state = n212_q; // (isignal)
  initial
    rx_state = 2'b00;
  /* uart.vhd:44:12  */
  always @*
    rx_bit_counter = n214_q; // (isignal)
  initial
    rx_bit_counter = 4'b0000;
  /* uart.vhd:45:12  */
  always @*
    rx_counter_rst = n215_q; // (isignal)
  initial
    rx_counter_rst = 1'b0;
  /* uart.vhd:46:12  */
  always @*
    rx_uart_clk = uart_clk_rx_ent_n19; // (isignal)
  initial
    rx_uart_clk = 1'b0;
  /* uart.vhd:49:12  */
  always @*
    tx_state = n216_q; // (isignal)
  initial
    tx_state = 2'b00;
  /* uart.vhd:50:12  */
  always @*
    tx_reg = n187_o; // (isignal)
  initial
    tx_reg = 11'b11111111111;
  /* uart.vhd:51:12  */
  always @*
    tx_bit_counter = n217_q; // (isignal)
  initial
    tx_bit_counter = 4'b0000;
  /* uart.vhd:52:12  */
  always @*
    tx_counter_rst = n218_q; // (isignal)
  initial
    tx_counter_rst = 1'b0;
  /* uart.vhd:53:12  */
  always @*
    tx_start_internal = n219_q; // (isignal)
  initial
    tx_start_internal = 1'b0;
  /* uart.vhd:54:12  */
  always @*
    tx_parity_bit = n220_q; // (isignal)
  initial
    tx_parity_bit = 1'b0;
  /* uart.vhd:55:12  */
  always @*
    tx_uart_clk = uart_clk_tx_ent_n23; // (isignal)
  initial
    tx_uart_clk = 1'b0;
  /* uart.vhd:72:29  */
  assign uart_clk_rx_ent_n19 = uart_clk_rx_ent_o_clk; // (signal)
  /* uart.vhd:67:5  */
  uart_clock uart_clk_rx_ent (
    .i_clk(clk),
    .i_reset(rx_counter_rst),
    .i_sampling_delay(sampling_delay),
    .o_clk(uart_clk_rx_ent_o_clk));
  /* uart.vhd:79:29  */
  assign uart_clk_tx_ent_n23 = uart_clk_tx_ent_o_clk; // (signal)
  /* uart.vhd:74:5  */
  uart_clock uart_clk_tx_ent (
    .i_clk(clk),
    .i_reset(n22_o),
    .i_sampling_delay(sampling_delay),
    .o_clk(uart_clk_tx_ent_o_clk));
  /* uart.vhd:95:37  */
  assign n28_o = ~rx_data;
  /* uart.vhd:95:25  */
  assign n31_o = n28_o ? 2'b01 : 2'b00;
  /* uart.vhd:93:21  */
  assign n33_o = rx_state == 2'b00;
  /* uart.vhd:100:21  */
  assign n35_o = rx_state == 2'b01;
  /* uart.vhd:105:44  */
  assign n36_o = {28'b0, rx_bit_counter};  //  uext
  /* uart.vhd:105:44  */
  assign n38_o = $signed(n36_o) >= $signed(32'b00000000000000000000000000001010);
  /* uart.vhd:105:25  */
  assign n40_o = n38_o ? 2'b11 : rx_state;
  /* uart.vhd:103:21  */
  assign n42_o = rx_state == 2'b10;
  /* uart.vhd:110:21  */
  assign n44_o = rx_state == 2'b11;
  assign n45_o = {n44_o, n42_o, n35_o, n33_o};
  /* uart.vhd:92:17  */
  always @*
    case (n45_o)
      4'b1000: n47_o = rx_state;
      4'b0100: n47_o = n40_o;
      4'b0010: n47_o = 2'b10;
      4'b0001: n47_o = n31_o;
      default: n47_o = rx_state;
    endcase
  /* uart.vhd:92:17  */
  always @*
    case (n45_o)
      4'b1000: n52_o = 1'b0;
      4'b0100: n52_o = 1'b0;
      4'b0010: n52_o = 1'b1;
      4'b0001: n52_o = 1'b0;
      default: n52_o = rx_counter_rst;
    endcase
  /* uart.vhd:89:13  */
  assign n54_o = rst ? 2'b00 : n47_o;
  /* uart.vhd:89:13  */
  assign n55_o = rst ? rx_counter_rst : n52_o;
  /* uart.vhd:126:21  */
  assign n62_o = rx_state == 2'b00;
  /* uart.vhd:128:21  */
  assign n64_o = rx_state == 2'b01;
  /* uart.vhd:130:21  */
  assign n66_o = rx_state == 2'b10;
  /* uart.vhd:132:21  */
  assign n68_o = rx_state == 2'b11;
  assign n69_o = {n68_o, n66_o, n64_o, n62_o};
  /* uart.vhd:125:17  */
  always @*
    case (n69_o)
      4'b1000: n74_o = 1'b1;
      4'b0100: n74_o = 1'b0;
      4'b0010: n74_o = 1'b0;
      4'b0001: n74_o = n222_q;
      default: n74_o = 1'b0;
    endcase
  /* uart.vhd:122:13  */
  assign n76_o = rst ? 1'b0 : n74_o;
  /* uart.vhd:147:46  */
  assign n81_o = {28'b0, rx_bit_counter};  //  uext
  /* uart.vhd:147:46  */
  assign n83_o = n81_o + 32'b00000000000000000000000000000001;
  /* uart.vhd:147:31  */
  assign n84_o = n83_o[3:0];  // trunc
  /* uart.vhd:175:25  */
  assign n109_o = tx_start_internal ? 2'b01 : 2'b00;
  /* uart.vhd:173:21  */
  assign n111_o = tx_state == 2'b00;
  /* uart.vhd:180:21  */
  assign n113_o = tx_state == 2'b01;
  /* uart.vhd:185:44  */
  assign n114_o = {28'b0, tx_bit_counter};  //  uext
  /* uart.vhd:185:44  */
  assign n116_o = $signed(n114_o) >= $signed(32'b00000000000000000000000000001010);
  /* uart.vhd:185:25  */
  assign n118_o = n116_o ? 2'b11 : tx_state;
  /* uart.vhd:183:21  */
  assign n120_o = tx_state == 2'b10;
  /* uart.vhd:190:21  */
  assign n122_o = tx_state == 2'b11;
  assign n123_o = {n122_o, n120_o, n113_o, n111_o};
  /* uart.vhd:172:17  */
  always @*
    case (n123_o)
      4'b1000: n125_o = tx_state;
      4'b0100: n125_o = n118_o;
      4'b0010: n125_o = 2'b10;
      4'b0001: n125_o = n109_o;
      default: n125_o = tx_state;
    endcase
  /* uart.vhd:172:17  */
  always @*
    case (n123_o)
      4'b1000: n130_o = 1'b0;
      4'b0100: n130_o = 1'b0;
      4'b0010: n130_o = 1'b1;
      4'b0001: n130_o = 1'b0;
      default: n130_o = tx_counter_rst;
    endcase
  /* uart.vhd:169:13  */
  assign n132_o = rst ? 2'b00 : n125_o;
  /* uart.vhd:169:13  */
  assign n133_o = rst ? tx_counter_rst : n130_o;
  /* uart.vhd:204:51  */
  assign n140_o = tx_state == 2'b00;
  /* uart.vhd:204:37  */
  assign n141_o = tx_start & n140_o;
  /* uart.vhd:204:13  */
  assign n144_o = n141_o ? 1'b1 : 1'b0;
  /* uart.vhd:202:13  */
  assign n146_o = rst ? 1'b0 : n144_o;
  /* uart.vhd:216:13  */
  assign n151_o = tx_state == 2'b01;
  /* uart.vhd:218:13  */
  assign n153_o = tx_state == 2'b10;
  assign n154_o = {n153_o, n151_o};
  /* uart.vhd:215:9  */
  always @*
    case (n154_o)
      2'b10: n158_o = 1'b0;
      2'b01: n158_o = 1'b0;
      default: n158_o = 1'b1;
    endcase
  /* uart.vhd:231:46  */
  assign n162_o = {28'b0, tx_bit_counter};  //  uext
  /* uart.vhd:231:46  */
  assign n164_o = n162_o + 32'b00000000000000000000000000000001;
  /* uart.vhd:231:31  */
  assign n165_o = n164_o[3:0];  // trunc
  /* uart.vhd:242:56  */
  assign n172_o = {28'b0, tx_bit_counter};  //  uext
  /* uart.vhd:242:56  */
  assign n174_o = 32'b00000000000000000000000000001010 - n172_o;
  /* uart.vhd:242:56  */
  assign n175_o = n174_o[3:0];  // trunc
  /* uart.vhd:239:13  */
  assign n179_o = rst ? 1'b1 : n245_o;
  /* uart.vhd:249:23  */
  assign n184_o = {1'b1, tx_parity_bit};
  /* uart.vhd:249:39  */
  assign n185_o = {n184_o, tx_data_word};
  /* uart.vhd:249:54  */
  assign n187_o = {n185_o, 1'b0};
  /* uart.vhd:258:29  */
  assign n192_o = tx_state == 2'b01;
  /* uart.vhd:259:40  */
  assign n194_o = cfg_parity_setting == 2'b00;
  /* uart.vhd:261:43  */
  assign n196_o = cfg_parity_setting == 2'b01;
  /* uart.vhd:262:38  */
  assign n197_o = ^(tx_data_word);
  /* uart.vhd:262:38  */
  assign n198_o = ~n197_o;
  /* uart.vhd:263:43  */
  assign n200_o = cfg_parity_setting == 2'b10;
  /* uart.vhd:264:38  */
  assign n201_o = ^(tx_data_word);
  /* uart.vhd:263:17  */
  assign n203_o = n200_o ? n201_o : 1'b1;
  /* uart.vhd:261:17  */
  assign n204_o = n196_o ? n198_o : n203_o;
  /* uart.vhd:259:17  */
  assign n206_o = n194_o ? 1'b1 : n204_o;
  /* uart.vhd:258:13  */
  assign n207_o = n192_o ? n206_o : tx_parity_bit;
  /* uart.vhd:256:13  */
  assign n209_o = rst ? 1'b1 : n207_o;
  /* uart.vhd:88:9  */
  always @(posedge clk)
    n212_q <= n54_o;
  initial
    n212_q = 2'b00;
  /* uart.vhd:146:9  */
  always @(posedge rx_uart_clk or posedge rx_counter_rst)
    if (rx_counter_rst)
      n214_q <= 4'b0000;
    else
      n214_q <= n84_o;
  /* uart.vhd:88:9  */
  always @(posedge clk)
    n215_q <= n55_o;
  initial
    n215_q = 1'b0;
  /* uart.vhd:168:9  */
  always @(posedge clk)
    n216_q <= n132_o;
  initial
    n216_q = 2'b00;
  /* uart.vhd:230:9  */
  always @(posedge tx_uart_clk or posedge tx_counter_rst)
    if (tx_counter_rst)
      n217_q <= 4'b0000;
    else
      n217_q <= n165_o;
  /* uart.vhd:168:9  */
  always @(posedge clk)
    n218_q <= n133_o;
  initial
    n218_q = 1'b0;
  /* uart.vhd:201:9  */
  always @(posedge clk)
    n219_q <= n146_o;
  initial
    n219_q = 1'b0;
  /* uart.vhd:255:9  */
  always @(posedge clk)
    n220_q <= n209_o;
  initial
    n220_q = 1'b0;
  /* uart.vhd:238:9  */
  always @(posedge tx_uart_clk)
    n221_q <= n179_o;
  initial
    n221_q = 1'b1;
  /* uart.vhd:121:9  */
  always @(posedge clk)
    n222_q <= n76_o;
  initial
    n222_q = 1'b0;
  assign n223_o = tx_reg[0];
  /* uart.vhd:79:29  */
  assign n224_o = tx_reg[1];
  /* uart.vhd:74:5  */
  assign n225_o = tx_reg[2];
  /* uart.vhd:72:29  */
  assign n226_o = tx_reg[3];
  /* uart.vhd:67:5  */
  assign n227_o = tx_reg[4];
  /* uart.vhd:19:9  */
  assign n228_o = tx_reg[5];
  /* uart.vhd:15:9  */
  assign n229_o = tx_reg[6];
  /* uart.vhd:14:9  */
  assign n230_o = tx_reg[7];
  /* uart.vhd:154:9  */
  assign n231_o = tx_reg[8];
  assign n232_o = tx_reg[9];
  /* uart.vhd:254:5  */
  assign n233_o = tx_reg[10];
  /* uart.vhd:242:38  */
  assign n234_o = n175_o[1:0];
  /* uart.vhd:242:38  */
  always @*
    case (n234_o)
      2'b00: n235_o = n223_o;
      2'b01: n235_o = n224_o;
      2'b10: n235_o = n225_o;
      2'b11: n235_o = n226_o;
    endcase
  /* uart.vhd:242:38  */
  assign n236_o = n175_o[1:0];
  /* uart.vhd:242:38  */
  always @*
    case (n236_o)
      2'b00: n237_o = n227_o;
      2'b01: n237_o = n228_o;
      2'b10: n237_o = n229_o;
      2'b11: n237_o = n230_o;
    endcase
  assign n238_o = n175_o[0];
  /* uart.vhd:242:38  */
  assign n239_o = n238_o ? n232_o : n231_o;
  assign n240_o = n175_o[1];
  /* uart.vhd:242:38  */
  assign n241_o = n240_o ? n233_o : n239_o;
  assign n242_o = n175_o[2];
  /* uart.vhd:242:38  */
  assign n243_o = n242_o ? n237_o : n235_o;
  assign n244_o = n175_o[3];
  /* uart.vhd:242:38  */
  assign n245_o = n244_o ? n241_o : n243_o;
endmodule

