// SPDX-FileCopyrightText: 2025 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_fifo_sync_conf.vh"

module iob_fifo_sync #(
   parameter W_DATA_W  = `IOB_FIFO_SYNC_W_DATA_W,
   parameter R_DATA_W  = `IOB_FIFO_SYNC_R_DATA_W,
   parameter ADDR_W    = `IOB_FIFO_SYNC_ADDR_W,
   parameter MAXDATA_W = `IOB_FIFO_SYNC_MAXDATA_W,  // Don't change this parameter value!
   parameter MINDATA_W = `IOB_FIFO_SYNC_MINDATA_W,  // Don't change this parameter value!
   parameter R         = `IOB_FIFO_SYNC_R,          // Don't change this parameter value!
   parameter MINADDR_W = `IOB_FIFO_SYNC_MINADDR_W,  // Don't change this parameter value!
   parameter W_ADDR_W  = `IOB_FIFO_SYNC_W_ADDR_W,   // Don't change this parameter value!
   parameter R_ADDR_W  = `IOB_FIFO_SYNC_R_ADDR_W    // Don't change this parameter value!
) (
   // clk_en_rst_s: Clock, clock enable and reset
   input                  clk_i,
   input                  cke_i,
   input                  arst_i,
   input                  rst_i,
   // w_en_i: Write enable input
   input                  w_en_i,
   // w_data_i: Write data input
   input  [ W_DATA_W-1:0] w_data_i,
   // w_full_o: Write full output
   output                 w_full_o,
   // r_en_i: Read enable input
   input                  r_en_i,
   // r_data_o: Read data output
   output [ R_DATA_W-1:0] r_data_o,
   // r_empty_o: Read empty output
   output                 r_empty_o,
   // level_o: FIFO interface
   output [ ADDR_W+1-1:0] level_o,
   // extmem_io: External memory interface
   output                 ext_mem_clk_o,
   output [        R-1:0] ext_mem_r_en_o,
   output [MINADDR_W-1:0] ext_mem_r_addr_o,
   input  [MAXDATA_W-1:0] ext_mem_r_data_i,
   output [        R-1:0] ext_mem_w_en_o,
   output [MINADDR_W-1:0] ext_mem_w_addr_o,
   output [MAXDATA_W-1:0] ext_mem_w_data_o
);

   // Internal write enable wire
   wire                w_en_int;
   // Internal write address wire
   wire [W_ADDR_W-1:0] w_addr;
   // Internal read enable wire
   wire                r_en_int;
   // Internal read address wire
   wire [R_ADDR_W-1:0] r_addr;
   // Next read empty signal
   wire                r_empty_nxt;
   // Next write full signal
   wire                w_full_nxt;
   // Internal FIFO level wire
   wire [ADDR_W+1-1:0] level;
   // Internal FIFO level wire
   reg  [ADDR_W+1-1:0] level_incr;
   reg  [ADDR_W+1-1:0] level_nxt;
   reg                 level_rst;

   always @(*) begin

      level_incr = level + W_INCR;
      level_nxt  = level;
      level_rst  = rst_i;
      if (w_en_int && (!r_en_int))  //write only
         level_nxt = level_incr;
      else if (w_en_int && r_en_int)  //write and read
         level_nxt = level_incr - R_INCR;
      else if (r_en_int)  //read only
         level_nxt = level - R_INCR;

   end


   // SPDX-FileCopyrightText: 2025 IObundle
   //
   // SPDX-License-Identifier: MIT

   function [31:0] iob_max;
      input [31:0] a;
      input [31:0] b;
      begin
         if (a > b) iob_max = a;
         else iob_max = b;
      end
   endfunction

   function [31:0] iob_min;
      input [31:0] a;
      input [31:0] b;
      begin
         if (a < b) iob_min = a;
         else iob_min = b;
      end
   endfunction

   function [31:0] iob_cshift_left;
      input [31:0] DATA;
      input integer DATA_WIDTH;
      input integer SHIFT;
      begin
         iob_cshift_left = (DATA << SHIFT) | (DATA >> (DATA_WIDTH - SHIFT));
      end
   endfunction

   function [31:0] iob_cshift_right;
      input [31:0] DATA;
      input integer DATA_WIDTH;
      input integer SHIFT;
      begin
         iob_cshift_right = (DATA >> SHIFT) | (DATA << (DATA_WIDTH - SHIFT));
      end
   endfunction

   function integer iob_abs;
      input integer a;
      begin
         iob_abs = (a >= 0) ? a : -a;
      end
   endfunction

   function integer iob_sign;
      input integer a;
      begin
         if (a < 0) iob_sign = -1;
         else iob_sign = 1;
      end
   endfunction
   localparam ADDR_W_DIFF = $clog2(R);
   localparam [ADDR_W:0] FIFO_SIZE = {1'b1, {ADDR_W{1'b0}}};  //in bytes
   assign w_en_int = (w_en_i & (~w_full_o));
   assign r_en_int = (r_en_i & (~r_empty_o));
   //assign according to assymetry type
   localparam [ADDR_W-1:0] W_INCR = (W_DATA_W > R_DATA_W) ?
                  {{ADDR_W-1{1'd0}},{1'd1}} << ADDR_W_DIFF : {{ADDR_W-1{1'd0}},{1'd1}};
   localparam [ADDR_W-1:0] R_INCR = (R_DATA_W > W_DATA_W) ?
                  {{ADDR_W-1{1'd0}},{1'd1}} << ADDR_W_DIFF : {{ADDR_W-1{1'd0}},{1'd1}};
   assign level_o       = level;
   assign r_empty_nxt   = level_nxt < {1'b0, R_INCR};
   assign w_full_nxt    = level_nxt > (FIFO_SIZE - W_INCR);
   assign ext_mem_clk_o = clk_i;




   // Default description
   iob_reg_car #(
      .DATA_W (1),
      .RST_VAL({1'd1})
   ) r_empty_reg0 (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .rst_i (rst_i),
      // data_i port: Data input
      .data_i(r_empty_nxt),
      // data_o port: Data output
      .data_o(r_empty_o)
   );

   // Default description
   iob_reg_car #(
      .DATA_W (1),
      .RST_VAL({1'd0})
   ) w_full_reg0 (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .rst_i (rst_i),
      // data_i port: Data input
      .data_i(w_full_nxt),
      // data_o port: Data output
      .data_o(w_full_o)
   );

   // Default description
   iob_counter #(
      .DATA_W (W_ADDR_W),
      .RST_VAL({W_ADDR_W{1'd0}})
   ) w_addr_cnt0 (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i        (clk_i),
      .cke_i        (cke_i),
      .arst_i       (arst_i),
      // counter_rst_i port: Counter reset input
      .counter_rst_i(rst_i),
      // counter_en_i port: Counter enable input
      .counter_en_i (w_en_int),
      // data_o port: Output port
      .data_o       (w_addr)
   );

   // Default description
   iob_counter #(
      .DATA_W (R_ADDR_W),
      .RST_VAL({R_ADDR_W{1'd0}})
   ) r_addr_cnt0 (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i        (clk_i),
      .cke_i        (cke_i),
      .arst_i       (arst_i),
      // counter_rst_i port: Counter reset input
      .counter_rst_i(rst_i),
      // counter_en_i port: Counter enable input
      .counter_en_i (r_en_int),
      // data_o port: Output port
      .data_o       (r_addr)
   );

   // Default description
   iob_asym_converter #(
      .W_DATA_W(W_DATA_W),
      .R_DATA_W(R_DATA_W),
      .ADDR_W  (ADDR_W)
   ) asym_converter (
      // extmem_io port: External memory interface
      .ext_mem_w_en_o  (ext_mem_w_en_o),
      .ext_mem_w_addr_o(ext_mem_w_addr_o),
      .ext_mem_w_data_o(ext_mem_w_data_o),
      .ext_mem_r_en_o  (ext_mem_r_en_o),
      .ext_mem_r_addr_o(ext_mem_r_addr_o),
      .ext_mem_r_data_i(ext_mem_r_data_i),
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i           (clk_i),
      .cke_i           (cke_i),
      .arst_i          (arst_i),
      .rst_i           (rst_i),
      // write_i port: Write interface
      .w_en_i          (w_en_int),
      .w_addr_i        (w_addr),
      .w_data_i        (w_data_i),
      // read_io port: Read interface
      .r_en_i          (r_en_int),
      .r_addr_i        (r_addr),
      .r_data_o        (r_data_o)
   );

   // level register
   iob_reg_car #(
      .DATA_W (ADDR_W + 1),
      .RST_VAL(0)
   ) level_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .rst_i (level_rst),
      // data_i port: Data input
      .data_i(level_nxt),
      // data_o port: Data output
      .data_o(level)
   );


endmodule
