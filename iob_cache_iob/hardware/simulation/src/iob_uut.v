// SPDX-FileCopyrightText: 2025 IObundle, Lda
//
// SPDX-License-Identifier: MIT
//
// Py2HWSW Version 0.81 has generated this code (https://github.com/IObundle/py2hwsw).

`timescale 1ns / 1ps
`include "iob_uut_conf.vh"

module iob_uut #(
    parameter FE_ADDR_W = `IOB_UUT_FE_ADDR_W,
    parameter FE_DATA_W = `IOB_UUT_FE_DATA_W,
    parameter BE_ADDR_W = `IOB_UUT_BE_ADDR_W,
    parameter BE_DATA_W = `IOB_UUT_BE_DATA_W,
    parameter NWAYS_W = `IOB_UUT_NWAYS_W,
    parameter NLINES_W = `IOB_UUT_NLINES_W,
    parameter WORD_OFFSET_W = `IOB_UUT_WORD_OFFSET_W,
    parameter WTBUF_DEPTH_W = `IOB_UUT_WTBUF_DEPTH_W,
    parameter REP_POLICY = `IOB_UUT_REP_POLICY,
    parameter WRITE_POL = `IOB_UUT_WRITE_POL,
    parameter USE_CTRL = `IOB_UUT_USE_CTRL,
    parameter USE_CTRL_CNT = `IOB_UUT_USE_CTRL_CNT,
    parameter FE_NBYTES = `IOB_UUT_FE_NBYTES,  // Don't change this parameter value!
    parameter FE_NBYTES_W = `IOB_UUT_FE_NBYTES_W,  // Don't change this parameter value!
    parameter BE_NBYTES = `IOB_UUT_BE_NBYTES,  // Don't change this parameter value!
    parameter BE_NBYTES_W = `IOB_UUT_BE_NBYTES_W,  // Don't change this parameter value!
    parameter LINE2BE_W = `IOB_UUT_LINE2BE_W,  // Don't change this parameter value!
    parameter ADDR_W = `IOB_UUT_ADDR_W,  // Don't change this parameter value!
    parameter DATA_W = `IOB_UUT_DATA_W  // Don't change this parameter value!
) (
    // clk_en_rst_s: Clock, clock enable and reset
    input clk_i,
    input cke_i,
    input arst_i,
    // cache_s: Testbench cache csrs interface
    input iob_valid_i,
    input [ADDR_W-1:0] iob_addr_i,
    input [DATA_W-1:0] iob_wdata_i,
    input [DATA_W/8-1:0] iob_wstrb_i,
    output iob_rvalid_o,
    output [DATA_W-1:0] iob_rdata_o,
    output iob_ready_o
);

// Internal signals for cache invalidate and write-trough buffer IO chain
    wire invalidate_i_int;
    wire invalidate_o_int;
    wire wtb_empty_i_int;
    wire wtb_empty_o_int;
// IOb bus to connect Cache back end to memory
    wire be_iob_valid;
    wire [BE_ADDR_W-1:0] be_iob_addr;
    wire [BE_DATA_W-1:0] be_iob_wdata;
    wire [BE_DATA_W/8-1:0] be_iob_wstrb;
    reg be_iob_rvalid;
    reg [BE_DATA_W-1:0] be_iob_rdata;
    reg be_iob_ready;
// Memory interface
    reg mem_en_i;
    reg [BE_DATA_W/8-1:0] mem_we_i;
    reg [BE_ADDR_W-1:0] mem_addr_i;
    reg [BE_DATA_W-1:0] mem_d_i;
    wire [BE_DATA_W-1:0] mem_d_o;
// Register valid signal
    wire iob_reg_rvalid;
    reg iob_reg_rvalid_nxt;

	always @ (*)
		begin
			
   be_iob_ready = 1'b1;

   mem_en_i = be_iob_valid;
   mem_we_i = be_iob_wstrb;
   mem_addr_i = be_iob_addr;
   mem_d_i = be_iob_wdata;
   be_iob_rdata = mem_d_o;

   iob_reg_rvalid_nxt = be_iob_valid & (~(|be_iob_wstrb));
   be_iob_rvalid = iob_reg_rvalid;

		end


   // Set constant inputs and connect outputs
   assign invalidate_i_int = 1'b0;
   assign wtb_empty_i_int = 1'b1;


        // Unit Under Test (UUT) Cache instance with 'iob' back end interface.
        iob_cache_iob #(
        .USE_CTRL(USE_CTRL),
        .USE_CTRL_CNT(USE_CTRL_CNT)
    ) cache (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // iob_s port: Front-end interface
        .iob_valid_i(iob_valid_i),
        .iob_addr_i(iob_addr_i),
        .iob_wdata_i(iob_wdata_i),
        .iob_wstrb_i(iob_wstrb_i),
        .iob_rvalid_o(iob_rvalid_o),
        .iob_rdata_o(iob_rdata_o),
        .iob_ready_o(iob_ready_o),
        // iob_m port: Back-end interface
        .be_iob_valid_o(be_iob_valid),
        .be_iob_addr_o(be_iob_addr),
        .be_iob_wdata_o(be_iob_wdata),
        .be_iob_wstrb_o(be_iob_wstrb),
        .be_iob_rvalid_i(be_iob_rvalid),
        .be_iob_rdata_i(be_iob_rdata),
        .be_iob_ready_i(be_iob_ready),
        // ie_io port: Cache invalidate and write-trough buffer IO chain
        .invalidate_i(invalidate_i_int),
        .invalidate_o(invalidate_o_int),
        .wtb_empty_i(wtb_empty_i_int),
        .wtb_empty_o(wtb_empty_o_int)
        );

            // Default description
        iob_ram_sp_be #(
        .ADDR_W(BE_ADDR_W),
        .DATA_W(BE_DATA_W)
    ) native_ram (
            // clk_i port: Clock
        .clk_i(clk_i),
        // mem_if_io port: Memory interface
        .en_i(mem_en_i),
        .we_i(mem_we_i),
        .addr_i(mem_addr_i),
        .d_i(mem_d_i),
        .d_o(mem_d_o)
        );

            // iob_reg_rvalid register
        iob_reg_ca #(
        .DATA_W(1),
        .RST_VAL(0)
    ) iob_reg_rvalid_reg (
            // clk_en_rst_s port: Clock, clock enable and reset
        .clk_i(clk_i),
        .cke_i(cke_i),
        .arst_i(arst_i),
        // data_i port: Data input
        .data_i(iob_reg_rvalid_nxt),
        // data_o port: Data output
        .data_o(iob_reg_rvalid)
        );

    
endmodule
