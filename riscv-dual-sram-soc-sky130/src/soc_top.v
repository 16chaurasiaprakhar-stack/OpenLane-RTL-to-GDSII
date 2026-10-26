`timescale 1ns / 1ps

module soc_top (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif
    input         clk,
    input         resetn,
    output        trap,
    output [7:0]  gpio_out,
    input  [2:0]  irq
);

    // Core CPU memory bus signals
    wire        mem_valid;
    wire        mem_instr;
    wire        mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [ 3:0] mem_wstrb;
    wire [31:0] mem_rdata;

    // Instruction SRAM signals
    wire        sram_inst_csb;
    wire        sram_inst_web;
    wire [ 3:0] sram_inst_wmask;
    wire [ 9:0] sram_inst_addr;
    wire [31:0] sram_inst_din;
    wire [31:0] sram_inst_dout;

    // Data SRAM signals
    wire        sram_data_csb;
    wire        sram_data_web;
    wire [ 3:0] sram_data_wmask;
    wire [ 9:0] sram_data_addr;
    wire [31:0] sram_data_din;
    wire [31:0] sram_data_dout;

    // RISC-V RV32I Core Instance
    picorv32 #(
        .ENABLE_COUNTERS(1),
        .ENABLE_COUNTERS64(0),
        .ENABLE_REGS_16_31(1),
        .ENABLE_REGS_DUALPORT(1),
        .TWO_STAGE_SHIFT(1),
        .BARREL_SHIFTER(0),
        .TWO_CYCLE_COMPARE(0),
        .TWO_CYCLE_ALU(0),
        .COMPRESSED_ISA(0),
        .CATCH_MISALIGN(1),
        .CATCH_ILLINSN(1),
        .ENABLE_PCPI(0),
        .ENABLE_MUL(0),
        .ENABLE_FAST_MUL(0),
        .ENABLE_DIV(0),
        .ENABLE_IRQ(1),
        .ENABLE_IRQ_QREGS(0),
        .ENABLE_IRQ_TIMER(0),
        .ENABLE_TRACE(0),
        .REGS_INIT_ZERO(1),
        .MASKED_IRQ(32'h0000_0000),
        .LATCHED_IRQ(32'hffff_ffff),
        .PROGADDR_RESET(32'h0000_0000),
        .PROGADDR_IRQ(32'h0000_0010),
        .STACKADDR(32'h0000_07fc)
    ) u_core (
        .clk         (clk),
        .resetn      (resetn),
        .trap        (trap),
        .mem_valid   (mem_valid),
        .mem_instr   (mem_instr),
        .mem_ready   (mem_ready),
        .mem_addr    (mem_addr),
        .mem_wdata   (mem_wdata),
        .mem_wstrb   (mem_wstrb),
        .mem_rdata   (mem_rdata),
        .irq         ({29'b0, irq}),
        .eoi         (),
        .trace_valid (),
        .trace_data  ()
    );

    // Crossbar / Interconnect arbiter
    axi_xbar u_axi_xbar (
        .clk             (clk),
        .resetn          (resetn),
        .mem_valid       (mem_valid),
        .mem_instr       (mem_instr),
        .mem_ready       (mem_ready),
        .mem_addr        (mem_addr),
        .mem_wdata       (mem_wdata),
        .mem_wstrb       (mem_wstrb),
        .mem_rdata       (mem_rdata),
        .sram_inst_csb   (sram_inst_csb),
        .sram_inst_web   (sram_inst_web),
        .sram_inst_wmask (sram_inst_wmask),
        .sram_inst_addr  (sram_inst_addr),
        .sram_inst_din   (sram_inst_din),
        .sram_inst_dout  (sram_inst_dout),
        .sram_data_csb   (sram_data_csb),
        .sram_data_web   (sram_data_web),
        .sram_data_wmask (sram_data_wmask),
        .sram_data_addr  (sram_data_addr),
        .sram_data_din   (sram_data_din),
        .sram_data_dout  (sram_data_dout),
        .gpio_out        (gpio_out)
    );

    // Dedicated Instruction SRAM Macro (Top-Left Periphery)
    sky130_sram_1k u_sram_inst (
`ifdef USE_POWER_PINS
        .vccd1 (vccd1),
        .vssd1 (vssd1),
`endif
        .clk   (clk),
        .csb   (sram_inst_csb),
        .web   (sram_inst_web),
        .wmask (sram_inst_wmask),
        .addr  (sram_inst_addr),
        .din   (sram_inst_din),
        .dout  (sram_inst_dout)
    );

    // Dedicated Data SRAM Macro (Top-Right Periphery)
    sky130_sram_1k u_sram_data (
`ifdef USE_POWER_PINS
        .vccd1 (vccd1),
        .vssd1 (vssd1),
`endif
        .clk   (clk),
        .csb   (sram_data_csb),
        .web   (sram_data_web),
        .wmask (sram_data_wmask),
        .addr  (sram_data_addr),
        .din   (sram_data_din),
        .dout  (sram_data_dout)
    );

endmodule
