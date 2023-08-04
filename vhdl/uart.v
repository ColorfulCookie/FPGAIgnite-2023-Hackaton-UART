module uart_clock
  (input  i_clk,
   input  i_reset,
   input  [31:0] i_sampling_delay,
   output o_clk);
  reg s_clk;
  reg [31:0] s_counter;
  wire [30:0] n234_o;
  wire [31:0] n235_o;
  wire [30:0] n236_o;
  wire [31:0] n237_o;
  wire [31:0] n239_o;
  wire [31:0] n241_o;
  wire n242_o;
  wire n243_o;
  wire [30:0] n244_o;
  wire [31:0] n245_o;
  wire [31:0] n247_o;
  wire [30:0] n248_o;
  wire [31:0] n249_o;
  wire [31:0] n252_o;
  wire n259_o;
  reg n260_q;
  wire n261_o;
  wire [31:0] n262_o;
  reg [31:0] n263_q;
  assign o_clk = s_clk;
  /* uart_clock.vhd:19:12  */
  always @*
    s_clk = n260_q; // (isignal)
  initial
    s_clk = 1'b0;
  /* uart_clock.vhd:21:12  */
  always @*
    s_counter = n263_q; // (isignal)
  initial
    s_counter = 32'b00000000000000000000000000000000;
  /* uart_clock.vhd:30:16  */
  assign n234_o = s_counter[30:0];  // trunc
  /* uart_clock.vhd:30:38  */
  assign n235_o = {1'b0, n234_o};  //  uext
  /* uart_clock.vhd:30:40  */
  assign n236_o = i_sampling_delay[30:0];  // trunc
  /* uart_clock.vhd:30:79  */
  assign n237_o = {1'b0, n236_o};  //  uext
  /* uart_clock.vhd:30:79  */
  assign n239_o = n237_o / 32'b00000000000000000000000000000010; // sdiv
  /* uart_clock.vhd:30:83  */
  assign n241_o = n239_o - 32'b00000000000000000000000000000001;
  /* uart_clock.vhd:30:38  */
  assign n242_o = n235_o == n241_o;
  /* uart_clock.vhd:31:30  */
  assign n243_o = ~s_clk;
  /* uart_clock.vhd:34:42  */
  assign n244_o = s_counter[30:0];  // trunc
  /* uart_clock.vhd:34:64  */
  assign n245_o = {1'b0, n244_o};  //  uext
  /* uart_clock.vhd:34:64  */
  assign n247_o = n245_o + 32'b00000000000000000000000000000001;
  /* uart_clock.vhd:34:42  */
  assign n248_o = n247_o[30:0];  // trunc
  /* uart_clock.vhd:34:30  */
  assign n249_o = {1'b0, n248_o};  //  uext
  /* uart_clock.vhd:30:13  */
  assign n252_o = n242_o ? 32'b00000000000000000000000000000000 : n249_o;
  /* uart_clock.vhd:28:13  */
  assign n259_o = n242_o ? n243_o : s_clk;
  /* uart_clock.vhd:28:13  */
  always @(negedge i_clk or posedge i_reset)
    if (i_reset)
      n260_q <= 1'b0;
    else
      n260_q <= n259_o;
  /* uart_clock.vhd:24:5  */
  assign n261_o = ~i_reset;
  /* uart_clock.vhd:28:13  */
  assign n262_o = n261_o ? n252_o : s_counter;
  /* uart_clock.vhd:28:13  */
  always @(negedge i_clk)
    n263_q <= n262_o;
  initial
    n263_q = 32'b00000000000000000000000000000000;
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
  wire n58_o;
  wire n60_o;
  wire n62_o;
  wire n64_o;
  wire [3:0] n65_o;
  reg n70_o;
  wire [31:0] n74_o;
  wire [31:0] n76_o;
  wire [3:0] n77_o;
  wire [1:0] n100_o;
  wire n102_o;
  wire n104_o;
  wire [31:0] n105_o;
  wire n107_o;
  wire [1:0] n109_o;
  wire n111_o;
  wire n113_o;
  wire [3:0] n114_o;
  reg [1:0] n116_o;
  reg n121_o;
  wire n128_o;
  wire n129_o;
  wire n132_o;
  wire n137_o;
  wire n139_o;
  wire [1:0] n140_o;
  reg n144_o;
  wire [31:0] n148_o;
  wire [31:0] n150_o;
  wire [3:0] n151_o;
  wire [31:0] n158_o;
  wire [31:0] n160_o;
  wire [3:0] n161_o;
  wire [1:0] n168_o;
  wire [9:0] n169_o;
  wire [10:0] n171_o;
  wire n176_o;
  wire n178_o;
  wire n180_o;
  wire n181_o;
  wire n182_o;
  wire n184_o;
  wire n185_o;
  wire n187_o;
  wire n188_o;
  wire n190_o;
  reg [1:0] n194_q;
  reg [3:0] n197_q;
  reg n198_q;
  reg [1:0] n199_q;
  reg [3:0] n200_q;
  reg n201_q;
  reg n202_q;
  wire n203_o;
  reg n204_q;
  reg n205_q;
  wire n206_o;
  wire n207_o;
  wire n208_o;
  wire n209_o;
  wire n210_o;
  wire n211_o;
  wire n212_o;
  wire n213_o;
  wire n214_o;
  wire n215_o;
  wire n216_o;
  wire [1:0] n217_o;
  reg n218_o;
  wire [1:0] n219_o;
  reg n220_o;
  wire n221_o;
  wire n222_o;
  wire n223_o;
  wire n224_o;
  wire n225_o;
  wire n226_o;
  wire n227_o;
  wire n228_o;
  assign tx_data_out = n205_q;
  assign tx_ready = n144_o;
  assign rx_finished_out = n70_o;
  /* uart.vhd:39:12  */
  always @*
    sampling_delay = cfg_clkSpeed_over_bdRate; // (isignal)
  initial
    sampling_delay = 32'b00000000000000000000000000000000;
  /* uart.vhd:42:12  */
  always @*
    rx_state = n194_q; // (isignal)
  initial
    rx_state = 2'b00;
  /* uart.vhd:44:12  */
  always @*
    rx_bit_counter = n197_q; // (isignal)
  initial
    rx_bit_counter = 4'b0000;
  /* uart.vhd:45:12  */
  always @*
    rx_counter_rst = n198_q; // (isignal)
  initial
    rx_counter_rst = 1'b0;
  /* uart.vhd:46:12  */
  always @*
    rx_uart_clk = uart_clk_rx_ent_n19; // (isignal)
  initial
    rx_uart_clk = 1'b0;
  /* uart.vhd:49:12  */
  always @*
    tx_state = n199_q; // (isignal)
  initial
    tx_state = 2'b00;
  /* uart.vhd:50:12  */
  always @*
    tx_reg = n171_o; // (isignal)
  initial
    tx_reg = 11'b11111111111;
  /* uart.vhd:51:12  */
  always @*
    tx_bit_counter = n200_q; // (isignal)
  initial
    tx_bit_counter = 4'b0000;
  /* uart.vhd:52:12  */
  always @*
    tx_counter_rst = n201_q; // (isignal)
  initial
    tx_counter_rst = 1'b0;
  /* uart.vhd:53:12  */
  always @*
    tx_start_internal = n202_q; // (isignal)
  initial
    tx_start_internal = 1'b0;
  /* uart.vhd:54:12  */
  always @*
    tx_parity_bit = n204_q; // (isignal)
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
  /* uart.vhd:91:33  */
  assign n28_o = ~rx_data;
  /* uart.vhd:91:21  */
  assign n31_o = n28_o ? 2'b01 : 2'b00;
  /* uart.vhd:89:17  */
  assign n33_o = rx_state == 2'b00;
  /* uart.vhd:96:17  */
  assign n35_o = rx_state == 2'b01;
  /* uart.vhd:101:40  */
  assign n36_o = {28'b0, rx_bit_counter};  //  uext
  /* uart.vhd:101:40  */
  assign n38_o = $signed(n36_o) >= $signed(32'b00000000000000000000000000001010);
  /* uart.vhd:101:21  */
  assign n40_o = n38_o ? 2'b11 : rx_state;
  /* uart.vhd:99:17  */
  assign n42_o = rx_state == 2'b10;
  /* uart.vhd:106:17  */
  assign n44_o = rx_state == 2'b11;
  assign n45_o = {n44_o, n42_o, n35_o, n33_o};
  /* uart.vhd:88:13  */
  always @*
    case (n45_o)
      4'b1000: n47_o = rx_state;
      4'b0100: n47_o = n40_o;
      4'b0010: n47_o = 2'b10;
      4'b0001: n47_o = n31_o;
      default: n47_o = rx_state;
    endcase
  /* uart.vhd:88:13  */
  always @*
    case (n45_o)
      4'b1000: n52_o = 1'b0;
      4'b0100: n52_o = 1'b0;
      4'b0010: n52_o = 1'b1;
      4'b0001: n52_o = 1'b0;
      default: n52_o = rx_counter_rst;
    endcase
  /* uart.vhd:116:13  */
  assign n58_o = rx_state == 2'b00;
  /* uart.vhd:118:13  */
  assign n60_o = rx_state == 2'b01;
  /* uart.vhd:120:13  */
  assign n62_o = rx_state == 2'b10;
  /* uart.vhd:122:13  */
  assign n64_o = rx_state == 2'b11;
  assign n65_o = {n64_o, n62_o, n60_o, n58_o};
  /* uart.vhd:115:9  */
  always @*
    case (n65_o)
      4'b1000: n70_o = 1'b1;
      4'b0100: n70_o = 1'b0;
      4'b0010: n70_o = 1'b0;
      4'b0001: n70_o = n70_o;
      default: n70_o = 1'b0;
    endcase
  /* uart.vhd:134:46  */
  assign n74_o = {28'b0, rx_bit_counter};  //  uext
  /* uart.vhd:134:46  */
  assign n76_o = n74_o + 32'b00000000000000000000000000000001;
  /* uart.vhd:134:31  */
  assign n77_o = n76_o[3:0];  // trunc
  /* uart.vhd:156:21  */
  assign n100_o = tx_start_internal ? 2'b01 : 2'b00;
  /* uart.vhd:154:17  */
  assign n102_o = tx_state == 2'b00;
  /* uart.vhd:161:17  */
  assign n104_o = tx_state == 2'b01;
  /* uart.vhd:166:40  */
  assign n105_o = {28'b0, tx_bit_counter};  //  uext
  /* uart.vhd:166:40  */
  assign n107_o = $signed(n105_o) >= $signed(32'b00000000000000000000000000001010);
  /* uart.vhd:166:21  */
  assign n109_o = n107_o ? 2'b11 : tx_state;
  /* uart.vhd:164:17  */
  assign n111_o = tx_state == 2'b10;
  /* uart.vhd:171:17  */
  assign n113_o = tx_state == 2'b11;
  assign n114_o = {n113_o, n111_o, n104_o, n102_o};
  /* uart.vhd:153:13  */
  always @*
    case (n114_o)
      4'b1000: n116_o = tx_state;
      4'b0100: n116_o = n109_o;
      4'b0010: n116_o = 2'b10;
      4'b0001: n116_o = n100_o;
      default: n116_o = tx_state;
    endcase
  /* uart.vhd:153:13  */
  always @*
    case (n114_o)
      4'b1000: n121_o = 1'b0;
      4'b0100: n121_o = 1'b0;
      4'b0010: n121_o = 1'b1;
      4'b0001: n121_o = 1'b0;
      default: n121_o = tx_counter_rst;
    endcase
  /* uart.vhd:181:46  */
  assign n128_o = tx_state == 2'b00;
  /* uart.vhd:181:33  */
  assign n129_o = tx_start & n128_o;
  /* uart.vhd:181:13  */
  assign n132_o = n129_o ? 1'b1 : 1'b0;
  /* uart.vhd:192:13  */
  assign n137_o = tx_state == 2'b01;
  /* uart.vhd:194:13  */
  assign n139_o = tx_state == 2'b10;
  assign n140_o = {n139_o, n137_o};
  /* uart.vhd:191:9  */
  always @*
    case (n140_o)
      2'b10: n144_o = 1'b0;
      2'b01: n144_o = 1'b0;
      default: n144_o = 1'b1;
    endcase
  /* uart.vhd:206:46  */
  assign n148_o = {28'b0, tx_bit_counter};  //  uext
  /* uart.vhd:206:46  */
  assign n150_o = n148_o + 32'b00000000000000000000000000000001;
  /* uart.vhd:206:31  */
  assign n151_o = n150_o[3:0];  // trunc
  /* uart.vhd:213:52  */
  assign n158_o = {28'b0, tx_bit_counter};  //  uext
  /* uart.vhd:213:52  */
  assign n160_o = 32'b00000000000000000000000000001010 - n158_o;
  /* uart.vhd:213:52  */
  assign n161_o = n160_o[3:0];  // trunc
  /* uart.vhd:219:23  */
  assign n168_o = {1'b1, tx_parity_bit};
  /* uart.vhd:219:39  */
  assign n169_o = {n168_o, tx_data_word};
  /* uart.vhd:219:54  */
  assign n171_o = {n169_o, 1'b0};
  /* uart.vhd:225:26  */
  assign n176_o = tx_state == 2'b01;
  /* uart.vhd:226:40  */
  assign n178_o = cfg_parity_setting == 2'b00;
  /* uart.vhd:228:47  */
  assign n180_o = cfg_parity_setting == 2'b01;
  /* uart.vhd:229:38  */
  assign n181_o = ^(tx_data_word);
  /* uart.vhd:229:38  */
  assign n182_o = ~n181_o;
  /* uart.vhd:230:47  */
  assign n184_o = cfg_parity_setting == 2'b10;
  /* uart.vhd:231:38  */
  assign n185_o = ^(tx_data_word);
  /* uart.vhd:230:21  */
  assign n187_o = n184_o ? n185_o : 1'b1;
  /* uart.vhd:228:21  */
  assign n188_o = n180_o ? n182_o : n187_o;
  /* uart.vhd:226:17  */
  assign n190_o = n178_o ? 1'b1 : n188_o;
  /* uart.vhd:87:9  */
  always @(posedge clk)
    n194_q <= n47_o;
  initial
    n194_q = 2'b00;
  /* uart.vhd:133:13  */
  always @(posedge rx_uart_clk or posedge rx_counter_rst)
    if (rx_counter_rst)
      n197_q <= 4'b0000;
    else
      n197_q <= n77_o;
  /* uart.vhd:87:9  */
  always @(posedge clk)
    n198_q <= n52_o;
  initial
    n198_q = 1'b0;
  /* uart.vhd:152:9  */
  always @(posedge clk)
    n199_q <= n116_o;
  initial
    n199_q = 2'b00;
  /* uart.vhd:205:13  */
  always @(posedge tx_uart_clk or posedge tx_counter_rst)
    if (tx_counter_rst)
      n200_q <= 4'b0000;
    else
      n200_q <= n151_o;
  /* uart.vhd:152:9  */
  always @(posedge clk)
    n201_q <= n121_o;
  initial
    n201_q = 1'b0;
  /* uart.vhd:180:9  */
  always @(posedge clk)
    n202_q <= n132_o;
  initial
    n202_q = 1'b0;
  /* uart.vhd:224:9  */
  assign n203_o = n176_o ? n190_o : tx_parity_bit;
  /* uart.vhd:224:9  */
  always @(posedge clk)
    n204_q <= n203_o;
  initial
    n204_q = 1'b0;
  /* uart.vhd:212:9  */
  always @(posedge tx_uart_clk)
    n205_q <= n228_o;
  initial
    n205_q = 1'b1;
  assign n206_o = tx_reg[0];
  assign n207_o = tx_reg[1];
  /* uart.vhd:79:29  */
  assign n208_o = tx_reg[2];
  /* uart.vhd:74:5  */
  assign n209_o = tx_reg[3];
  /* uart.vhd:72:29  */
  assign n210_o = tx_reg[4];
  /* uart.vhd:67:5  */
  assign n211_o = tx_reg[5];
  /* uart.vhd:19:9  */
  assign n212_o = tx_reg[6];
  /* uart.vhd:15:9  */
  assign n213_o = tx_reg[7];
  /* uart.vhd:14:9  */
  assign n214_o = tx_reg[8];
  /* uart.vhd:140:9  */
  assign n215_o = tx_reg[9];
  /* uart.vhd:142:17  */
  assign n216_o = tx_reg[10];
  /* uart.vhd:213:34  */
  assign n217_o = n161_o[1:0];
  /* uart.vhd:213:34  */
  always @*
    case (n217_o)
      2'b00: n218_o = n206_o;
      2'b01: n218_o = n207_o;
      2'b10: n218_o = n208_o;
      2'b11: n218_o = n209_o;
    endcase
  /* uart.vhd:213:34  */
  assign n219_o = n161_o[1:0];
  /* uart.vhd:213:34  */
  always @*
    case (n219_o)
      2'b00: n220_o = n210_o;
      2'b01: n220_o = n211_o;
      2'b10: n220_o = n212_o;
      2'b11: n220_o = n213_o;
    endcase
  /* uart.vhd:218:5  */
  assign n221_o = n161_o[0];
  /* uart.vhd:213:34  */
  assign n222_o = n221_o ? n215_o : n214_o;
  /* uart.vhd:211:5  */
  assign n223_o = n161_o[1];
  /* uart.vhd:213:34  */
  assign n224_o = n223_o ? n216_o : n222_o;
  /* uart.vhd:202:5  */
  assign n225_o = n161_o[2];
  /* uart.vhd:213:34  */
  assign n226_o = n225_o ? n220_o : n218_o;
  /* uart.vhd:190:5  */
  assign n227_o = n161_o[3];
  /* uart.vhd:213:34  */
  assign n228_o = n227_o ? n224_o : n226_o;
endmodule

