// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81.0 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_asym_converter_conf.vh"

module iob_asym_converter #(
   parameter W_DATA_W   = `IOB_ASYM_CONVERTER_W_DATA_W,
   parameter R_DATA_W   = `IOB_ASYM_CONVERTER_R_DATA_W,
   parameter ADDR_W     = `IOB_ASYM_CONVERTER_ADDR_W,
   parameter BIG_ENDIAN = `IOB_ASYM_CONVERTER_BIG_ENDIAN,
   parameter MAXDATA_W  = `IOB_ASYM_CONVERTER_MAXDATA_W,   // Don't change this parameter value!
   parameter MINDATA_W  = `IOB_ASYM_CONVERTER_MINDATA_W,   // Don't change this parameter value!
   parameter R          = `IOB_ASYM_CONVERTER_R,           // Don't change this parameter value!
   parameter MINADDR_W  = `IOB_ASYM_CONVERTER_MINADDR_W,   // Don't change this parameter value!
   parameter W_ADDR_W   = `IOB_ASYM_CONVERTER_W_ADDR_W,    // Don't change this parameter value!
   parameter R_ADDR_W   = `IOB_ASYM_CONVERTER_R_ADDR_W     // Don't change this parameter value!
) (
   // clk_en_rst_s: Clock, clock enable and reset
   input                  clk_i,
   input                  cke_i,
   input                  arst_i,
   input                  rst_i,
   // write_i: Write interface
   input                  w_en_i,
   input  [ W_ADDR_W-1:0] w_addr_i,
   input  [ W_DATA_W-1:0] w_data_i,
   // read_io: Read interface
   input                  r_en_i,
   input  [ R_ADDR_W-1:0] r_addr_i,
   output [ R_DATA_W-1:0] r_data_o,
   // extmem_io: External memory interface
   output [        R-1:0] ext_mem_w_en_o,
   output [MINADDR_W-1:0] ext_mem_w_addr_o,
   output [MAXDATA_W-1:0] ext_mem_w_data_o,
   output [        R-1:0] ext_mem_r_en_o,
   output [MINADDR_W-1:0] ext_mem_r_addr_o,
   input  [MAXDATA_W-1:0] ext_mem_r_data_i
);

   // Read data valid register
   wire                 r_data_valid_reg;
   // Read data register
   wire [MAXDATA_W-1:0] r_data_reg;
   // Read data internal
   reg  [MAXDATA_W-1:0] r_data_int;

   always @(*) begin

      if (r_data_valid_reg) begin
         r_data_int = ext_mem_r_data_i;
      end else begin
         r_data_int = r_data_reg;
      end

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
   //Generate the RAM based on the parameters
   generate
      if (W_DATA_W > R_DATA_W) begin : g_write_wider
         //memory write port
         assign ext_mem_w_en_o   = {R{w_en_i}};
         assign ext_mem_w_addr_o = w_addr_i;
         assign ext_mem_w_data_o = w_data_i;

         //register to hold the LSBs of r_addr
         wire [$clog2(R)-1:0] r_addr_lsbs_reg;
         iob_reg_cae #(
            .DATA_W ($clog2(R)),
            .RST_VAL({$clog2(R) {1'd0}})
         ) r_addr_reg_inst (
            .clk_i (clk_i),
            .cke_i (cke_i),
            .arst_i(arst_i),
            .en_i  (r_en_i),
            .data_i(r_addr_i[$clog2(R)-1:0]),
            .data_o(r_addr_lsbs_reg)
         );

         //memory read port
         assign ext_mem_r_addr_o = r_addr_i[R_ADDR_W-1:$clog2(R)];

         wire [W_DATA_W-1:0] r_data;
         if (BIG_ENDIAN) begin : g_big_endian
            assign ext_mem_r_en_o = {{(R - 1) {1'd0}}, r_en_i} << ((R - 1) - r_addr_i[$clog2(
                R
            )-1:0]);
            assign r_data = r_data_int >> (((R - 1) - r_addr_lsbs_reg) * R_DATA_W);
         end else begin : g_little_endian
            assign ext_mem_r_en_o = {{(R - 1) {1'd0}}, r_en_i} << r_addr_i[$clog2(R)-1:0];
            assign r_data         = r_data_int >> (r_addr_lsbs_reg * R_DATA_W);
         end
         assign r_data_o = r_data[0+:R_DATA_W];

      end else if (W_DATA_W < R_DATA_W) begin : g_read_wider
         //memory write port
         assign ext_mem_w_en_o = {{(R - 1) {1'd0}}, w_en_i} << w_addr_i[$clog2(R)-1:0];
         assign ext_mem_w_data_o = {{(R_DATA_W - W_DATA_W) {1'd0}}, w_data_i} << (w_addr_i[$clog2(
             R
         )-1:0] * W_DATA_W);
         assign ext_mem_w_addr_o = w_addr_i[W_ADDR_W-1:$clog2(R)];

         //memory read port
         assign ext_mem_r_en_o = {R{r_en_i}};
         assign ext_mem_r_addr_o = r_addr_i;
         if (BIG_ENDIAN) begin : g_big_endian
            genvar data_sel;
            for (data_sel = 0; data_sel < R; data_sel = data_sel + 1) begin : gen_r_data
               assign r_data_o[data_sel * W_DATA_W +: W_DATA_W] =
                        r_data_int[((R - 1) - data_sel) * W_DATA_W +: W_DATA_W];
            end
         end else begin : g_little_endian
            assign r_data_o = r_data_int;
         end

      end else begin : g_same_width
         //W_DATA_W == R_DATA_W
         //memory write port
         assign ext_mem_w_en_o   = w_en_i;
         assign ext_mem_w_addr_o = w_addr_i;
         assign ext_mem_w_data_o = w_data_i;

         //memory read port
         assign ext_mem_r_en_o   = r_en_i;
         assign ext_mem_r_addr_o = r_addr_i;
         assign r_data_o         = r_data_int;
      end
   endgenerate




   // Default description
   iob_reg_car #(
      .DATA_W (1),
      .RST_VAL(1'b0)
   ) r_data_valid_reg_inst (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .rst_i (rst_i),
      // data_i port: Data input
      .data_i(r_en_i),
      // data_o port: Data output
      .data_o(r_data_valid_reg)
   );

   // Default description
   iob_reg_care #(
      .DATA_W (MAXDATA_W),
      .RST_VAL({MAXDATA_W{1'd0}})
   ) r_data_reg_inst (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .rst_i (rst_i),
      .en_i  (r_data_valid_reg),
      // data_i port: Data input
      .data_i(ext_mem_r_data_i),
      // data_o port: Data output
      .data_o(r_data_reg)
   );


endmodule
