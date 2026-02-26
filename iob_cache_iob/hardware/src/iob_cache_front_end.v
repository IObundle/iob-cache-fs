// SPDX-FileCopyrightText: 2026 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81.0 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_cache_front_end_conf.vh"

module iob_cache_front_end #(
   parameter ADDR_W      = `IOB_CACHE_FRONT_END_ADDR_W,
   parameter DATA_W      = `IOB_CACHE_FRONT_END_DATA_W,
   parameter FE_NBYTES_W = `IOB_CACHE_FRONT_END_FE_NBYTES_W,  // Don't change this parameter value!
   parameter USE_CTRL    = `IOB_CACHE_FRONT_END_USE_CTRL
) (
   // clk_en_rst_s: Clock, clock enable and reset
   input                                             clk_i,
   input                                             cke_i,
   input                                             arst_i,
   // iob_s: Front-end interface
   input                                             iob_valid_i,
   input      [                          ADDR_W-1:0] iob_addr_i,
   input      [                          DATA_W-1:0] iob_wdata_i,
   input      [                        DATA_W/8-1:0] iob_wstrb_i,
   output reg                                        iob_rvalid_o,
   output     [                          DATA_W-1:0] iob_rdata_o,
   output reg                                        iob_ready_o,
   // cache_mem_io: Cache memory front-end interface
   output reg                                        data_req_o,
   output reg [     ADDR_W-USE_CTRL-FE_NBYTES_W-1:0] data_addr_o,
   input      [                          DATA_W-1:0] data_rdata_i,
   input                                             data_ack_i,
   output                                            data_req_reg_o,
   output     [     ADDR_W-USE_CTRL-FE_NBYTES_W-1:0] data_addr_reg_o,
   output     [                          DATA_W-1:0] data_wdata_reg_o,
   output     [                        DATA_W/8-1:0] data_wstrb_reg_o,
   // ctrl_io: Control interface.
   output                                            ctrl_req_o,
   output     [`IOB_CACHE_FRONT_END_ADDR_W_CSRS-1:0] ctrl_addr_o,
   output     [                        DATA_W/8-1:0] ctrl_wstrb_o,
   input      [           USE_CTRL*(DATA_W-1)+1-1:0] ctrl_rdata_i,
   input                                             ctrl_ack_i
);

   // Internal wires
   wire                                   ack;
   wire                                   valid_int;
   wire                                   ready_int;
   wire                                   we_r;
   reg                                    data_ready_int;
   reg                                    we_r_nxt;
   reg                                    we_r_en;
   reg                                    data_req_reg_o_nxt;
   reg                                    data_req_reg_o_en;
   reg  [ADDR_W-USE_CTRL-FE_NBYTES_W-1:0] data_addr_reg_o_nxt;
   reg                                    data_addr_reg_o_en;
   reg  [                     DATA_W-1:0] data_wdata_reg_o_nxt;
   reg                                    data_wdata_reg_o_en;
   reg  [                   DATA_W/8-1:0] data_wstrb_reg_o_nxt;
   reg                                    data_wstrb_reg_o_en;

   always @(*) begin

      // data output ports
      data_addr_o = valid_int ? iob_addr_i[ADDR_W-USE_CTRL-1:FE_NBYTES_W] : data_addr_reg_o;
      data_req_o = valid_int | data_req_reg_o;

      iob_rvalid_o = we_r ? 1'b0 : ack;
      iob_ready_o = ready_int;

      data_ready_int = data_req_reg_o ~^ data_ack_i;

      // Register every input
      data_req_reg_o_nxt = valid_int;
      data_req_reg_o_en = valid_int | ack;

      data_addr_reg_o_nxt = iob_addr_i[ADDR_W-USE_CTRL-1:FE_NBYTES_W];
      data_addr_reg_o_en = valid_int;

      data_wdata_reg_o_nxt = iob_wdata_i;
      data_wdata_reg_o_en = valid_int;

      data_wstrb_reg_o_nxt = iob_wstrb_i;
      data_wstrb_reg_o_en = valid_int;

      we_r_nxt = |iob_wstrb_i;
      we_r_en = iob_valid_i;

   end


   // select cache memory or controller
   generate
      if (USE_CTRL) begin : g_ctrl
         // Front-end output signals
         assign ack          = ctrl_ack_i | data_ack_i;
         assign iob_rdata_o  = (ctrl_ack_i) ? ctrl_rdata_i : data_rdata_i;

         assign valid_int    = ~iob_addr_i[ADDR_W-1] & iob_valid_i;

         assign ctrl_req_o   = iob_addr_i[ADDR_W-1] & iob_valid_i;
         assign ctrl_addr_o  = iob_addr_i[`IOB_CACHE_FRONT_END_ADDR_W_CSRS-1:0];
         assign ctrl_wstrb_o = (ctrl_req_o) ? iob_wstrb_i : {(DATA_W / 8) {1'b0}};

         wire ctrl_ready_int;
         assign ctrl_ready_int = ctrl_req_o ~^ ctrl_ack_i;
         assign ready_int      = ctrl_req_o ? ctrl_ready_int : data_ready_int;

      end else begin : g_no_ctrl
         // Front-end output signals
         assign ack          = data_ack_i;
         assign iob_rdata_o  = data_rdata_i;
         assign valid_int    = iob_valid_i;
         assign ctrl_req_o   = 1'b0;
         assign ctrl_addr_o  = `IOB_CACHE_FRONT_END_ADDR_W_CSRS'dx;
         assign ctrl_wstrb_o = {(DATA_W / 8) {1'b0}};

         assign ready_int    = data_ready_int;
      end
   endgenerate


   // we_r register
   iob_reg_cae #(
      .DATA_W (1),
      .RST_VAL(0)
   ) we_r_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (we_r_en),
      // data_i port: Data input
      .data_i(we_r_nxt),
      // data_o port: Data output
      .data_o(we_r)
   );

   // data_req_reg_o register
   iob_reg_cae #(
      .DATA_W (1),
      .RST_VAL(0)
   ) data_req_reg_o_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (data_req_reg_o_en),
      // data_i port: Data input
      .data_i(data_req_reg_o_nxt),
      // data_o port: Data output
      .data_o(data_req_reg_o)
   );

   // data_addr_reg_o register
   iob_reg_cae #(
      .DATA_W (ADDR_W - USE_CTRL - FE_NBYTES_W),
      .RST_VAL(0)
   ) data_addr_reg_o_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (data_addr_reg_o_en),
      // data_i port: Data input
      .data_i(data_addr_reg_o_nxt),
      // data_o port: Data output
      .data_o(data_addr_reg_o)
   );

   // data_wdata_reg_o register
   iob_reg_cae #(
      .DATA_W (DATA_W),
      .RST_VAL(0)
   ) data_wdata_reg_o_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (data_wdata_reg_o_en),
      // data_i port: Data input
      .data_i(data_wdata_reg_o_nxt),
      // data_o port: Data output
      .data_o(data_wdata_reg_o)
   );

   // data_wstrb_reg_o register
   iob_reg_cae #(
      .DATA_W (DATA_W / 8),
      .RST_VAL(0)
   ) data_wstrb_reg_o_reg (
      // clk_en_rst_s port: Clock, clock enable and reset
      .clk_i (clk_i),
      .cke_i (cke_i),
      .arst_i(arst_i),
      .en_i  (data_wstrb_reg_o_en),
      // data_i port: Data input
      .data_i(data_wstrb_reg_o_nxt),
      // data_o port: Data output
      .data_o(data_wstrb_reg_o)
   );


endmodule
