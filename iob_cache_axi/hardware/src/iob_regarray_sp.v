// SPDX-FileCopyrightText: 2025 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_regarray_sp_conf.vh"

module iob_regarray_sp #(
   parameter ADDR_W = `IOB_REGARRAY_SP_ADDR_W,
   parameter DATA_W = `IOB_REGARRAY_SP_DATA_W
) (
   // clk_en_rst_s: Clock, clock enable and reset
   input                   clk_i,
   input                   cke_i,
   input                   arst_i,
   input                   rst_i,
   // we_i: Write enable signal for the register array
   input                   we_i,
   // addr_i: Address input for the register array
   input      [ADDR_W-1:0] addr_i,
   // d_i: Data input for the register array
   input      [DATA_W-1:0] d_i,
   // d_o: Data output from the register array
   output reg [DATA_W-1:0] d_o
);

   // Internal data input for the register array
   reg  [DATA_W*(2**ADDR_W)-1:0] data_in;
   // Internal data output from the register array
   wire [DATA_W*(2**ADDR_W)-1:0] data_out;

   always @(*) begin

      data_in = {{((DATA_W * (2 ** ADDR_W)) - DATA_W) {1'b0}}, d_i} << (addr_i * DATA_W);
      d_o     = data_out[(addr_i*DATA_W)+:DATA_W];

   end



   genvar i;
   generate
      for (i = 0; i < 2 ** ADDR_W; i = i + 1) begin : g_regarray
         wire reg_en_i;
         assign reg_en_i = we_i & (addr_i == i);
         iob_reg_care #(
            .DATA_W(DATA_W)
         ) regarray_sp_inst (
            .clk_i (clk_i),
            .cke_i (cke_i),
            .arst_i(arst_i),
            .rst_i (rst_i),
            .en_i  (reg_en_i),
            .data_i(data_in[DATA_W*(i+1)-1:DATA_W*i]),
            .data_o(data_out[DATA_W*(i+1)-1:DATA_W*i])
         );
      end
   endgenerate




endmodule
