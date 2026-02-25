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
    parameter DATA_W = `IOB_UUT_DATA_W,  // Don't change this parameter value!
    parameter AXI_ID_W = `IOB_UUT_AXI_ID_W,
    parameter AXI_ID = `IOB_UUT_AXI_ID,
    parameter AXI_LEN_W = `IOB_UUT_AXI_LEN_W,
    parameter AXI_ADDR_W = `IOB_UUT_AXI_ADDR_W,
    parameter AXI_DATA_W = `IOB_UUT_AXI_DATA_W
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
// AXI bus to connect Cache back end to memory
    wire [AXI_ADDR_W-1:0] be_axi_araddr;
    wire be_axi_arvalid;
    wire be_axi_arready;
    wire [AXI_DATA_W-1:0] be_axi_rdata;
    wire [2-1:0] be_axi_rresp;
    wire be_axi_rvalid;
    wire be_axi_rready;
    wire [AXI_ID_W-1:0] be_axi_arid;
    wire [AXI_LEN_W-1:0] be_axi_arlen;
    wire [3-1:0] be_axi_arsize;
    wire [2-1:0] be_axi_arburst;
    wire be_axi_arlock;
    wire [4-1:0] be_axi_arcache;
    wire [4-1:0] be_axi_arqos;
    wire [AXI_ID_W-1:0] be_axi_rid;
    wire be_axi_rlast;
    wire [AXI_ADDR_W-1:0] be_axi_awaddr;
    wire be_axi_awvalid;
    wire be_axi_awready;
    wire [AXI_DATA_W-1:0] be_axi_wdata;
    wire [AXI_DATA_W/8-1:0] be_axi_wstrb;
    wire be_axi_wvalid;
    wire be_axi_wready;
    wire [2-1:0] be_axi_bresp;
    wire be_axi_bvalid;
    wire be_axi_bready;
    wire [AXI_ID_W-1:0] be_axi_awid;
    wire [AXI_LEN_W-1:0] be_axi_awlen;
    wire [3-1:0] be_axi_awsize;
    wire [2-1:0] be_axi_awburst;
    wire be_axi_awlock;
    wire [4-1:0] be_axi_awcache;
    wire [4-1:0] be_axi_awqos;
    wire be_axi_wlast;
    wire [AXI_ID_W-1:0] be_axi_bid;
// Connect axi_ram to 'iob_ram_t2p_be' memory
    wire ext_mem_clk;
    wire ext_mem_r_en;
    wire [AXI_ADDR_W - 2-1:0] ext_mem_r_addr;
    wire [32-1:0] ext_mem_r_data;
    wire [32/8-1:0] ext_mem_w_strb;
    wire [AXI_ADDR_W - 2-1:0] ext_mem_w_addr;
    wire [32-1:0] ext_mem_w_data;


   // Set constant inputs and connect outputs
   assign invalidate_i_int = 1'b0;
   assign wtb_empty_i_int = 1'b1;


        // Unit Under Test (UUT) Cache instance with 'axi' back end interface.
        iob_cache_axi #(
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
        // axi_m port: Back-end interface
        .axi_araddr_o(be_axi_araddr),
        .axi_arvalid_o(be_axi_arvalid),
        .axi_arready_i(be_axi_arready),
        .axi_rdata_i(be_axi_rdata),
        .axi_rresp_i(be_axi_rresp),
        .axi_rvalid_i(be_axi_rvalid),
        .axi_rready_o(be_axi_rready),
        .axi_arid_o(be_axi_arid),
        .axi_arlen_o(be_axi_arlen),
        .axi_arsize_o(be_axi_arsize),
        .axi_arburst_o(be_axi_arburst),
        .axi_arlock_o(be_axi_arlock),
        .axi_arcache_o(be_axi_arcache),
        .axi_arqos_o(be_axi_arqos),
        .axi_rid_i(be_axi_rid),
        .axi_rlast_i(be_axi_rlast),
        .axi_awaddr_o(be_axi_awaddr),
        .axi_awvalid_o(be_axi_awvalid),
        .axi_awready_i(be_axi_awready),
        .axi_wdata_o(be_axi_wdata),
        .axi_wstrb_o(be_axi_wstrb),
        .axi_wvalid_o(be_axi_wvalid),
        .axi_wready_i(be_axi_wready),
        .axi_bresp_i(be_axi_bresp),
        .axi_bvalid_i(be_axi_bvalid),
        .axi_bready_o(be_axi_bready),
        .axi_awid_o(be_axi_awid),
        .axi_awlen_o(be_axi_awlen),
        .axi_awsize_o(be_axi_awsize),
        .axi_awburst_o(be_axi_awburst),
        .axi_awlock_o(be_axi_awlock),
        .axi_awcache_o(be_axi_awcache),
        .axi_awqos_o(be_axi_awqos),
        .axi_wlast_o(be_axi_wlast),
        .axi_bid_i(be_axi_bid),
        // ie_io port: Cache invalidate and write-trough buffer IO chain
        .invalidate_i(invalidate_i_int),
        .invalidate_o(invalidate_o_int),
        .wtb_empty_i(wtb_empty_i_int),
        .wtb_empty_o(wtb_empty_o_int)
        );

            // External memory
        iob_axi_ram #(
        .ID_WIDTH(AXI_ID_W),
        .ADDR_WIDTH(AXI_ADDR_W),
        .DATA_WIDTH(AXI_DATA_W),
        .LEN_WIDTH(AXI_LEN_W)
    ) ddr_model_mem (
            // clk_i port: Clock
        .clk_i(clk_i),
        // rst_i port: Synchronous reset
        .rst_i(arst_i),
        // axi_s port: AXI interface
        .axi_araddr_i(be_axi_araddr),
        .axi_arvalid_i(be_axi_arvalid),
        .axi_arready_o(be_axi_arready),
        .axi_rdata_o(be_axi_rdata),
        .axi_rresp_o(be_axi_rresp),
        .axi_rvalid_o(be_axi_rvalid),
        .axi_rready_i(be_axi_rready),
        .axi_arid_i(be_axi_arid),
        .axi_arlen_i(be_axi_arlen),
        .axi_arsize_i(be_axi_arsize),
        .axi_arburst_i(be_axi_arburst),
        .axi_arlock_i({1'b0, be_axi_arlock}),
        .axi_arcache_i(be_axi_arcache),
        .axi_arqos_i(be_axi_arqos),
        .axi_rid_o(be_axi_rid),
        .axi_rlast_o(be_axi_rlast),
        .axi_awaddr_i(be_axi_awaddr),
        .axi_awvalid_i(be_axi_awvalid),
        .axi_awready_o(be_axi_awready),
        .axi_wdata_i(be_axi_wdata),
        .axi_wstrb_i(be_axi_wstrb),
        .axi_wvalid_i(be_axi_wvalid),
        .axi_wready_o(be_axi_wready),
        .axi_bresp_o(be_axi_bresp),
        .axi_bvalid_o(be_axi_bvalid),
        .axi_bready_i(be_axi_bready),
        .axi_awid_i(be_axi_awid),
        .axi_awlen_i(be_axi_awlen),
        .axi_awsize_i(be_axi_awsize),
        .axi_awburst_i(be_axi_awburst),
        .axi_awlock_i({1'b0, be_axi_awlock}),
        .axi_awcache_i(be_axi_awcache),
        .axi_awqos_i(be_axi_awqos),
        .axi_wlast_i(be_axi_wlast),
        .axi_bid_o(be_axi_bid),
        // external_mem_bus_m port: Port for connection to external 'iob_ram_t2p_be' memory
        .ext_mem_clk_o(ext_mem_clk),
        .ext_mem_r_en_o(ext_mem_r_en),
        .ext_mem_r_addr_o(ext_mem_r_addr),
        .ext_mem_r_data_i(ext_mem_r_data),
        .ext_mem_w_strb_o(ext_mem_w_strb),
        .ext_mem_w_addr_o(ext_mem_w_addr),
        .ext_mem_w_data_o(ext_mem_w_data)
        );

            // Default description
        iob_ram_t2p_be #(
        .ADDR_W(AXI_ADDR_W - 2),
        .DATA_W(AXI_DATA_W)
    ) iob_ram_t2p_be_inst (
            // ram_t2p_be_s port: RAM interface
        .clk_i(ext_mem_clk),
        .r_en_i(ext_mem_r_en),
        .r_addr_i(ext_mem_r_addr),
        .r_data_o(ext_mem_r_data),
        .w_strb_i(ext_mem_w_strb),
        .w_addr_i(ext_mem_w_addr),
        .w_data_i(ext_mem_w_data)
        );

    
endmodule
