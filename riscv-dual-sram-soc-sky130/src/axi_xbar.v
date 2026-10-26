`timescale 1ns / 1ps

module axi_xbar (
    input clk,
    input resetn,

    // Core CPU memory bus interface
    input         mem_valid,
    input         mem_instr,
    output reg    mem_ready,
    input  [31:0] mem_addr,
    input  [31:0] mem_wdata,
    input  [ 3:0] mem_wstrb,
    output reg [31:0] mem_rdata,

    // Instruction SRAM Macro interface
    output        sram_inst_csb,
    output        sram_inst_web,
    output [ 3:0] sram_inst_wmask,
    output [ 9:0] sram_inst_addr,
    output [31:0] sram_inst_din,
    input  [31:0] sram_inst_dout,

    // Data SRAM Macro interface
    output        sram_data_csb,
    output        sram_data_web,
    output [ 3:0] sram_data_wmask,
    output [ 9:0] sram_data_addr,
    output [31:0] sram_data_din,
    input  [31:0] sram_data_dout,

    // MMIO GPIO interface
    output reg [7:0] gpio_out
);

    // Address decoding
    // 0x0000_0000 - 0x0000_03FF: Instr SRAM (1KB)
    // 0x0000_0400 - 0x0000_07FF: Data SRAM (1KB)
    // 0x1000_0000 - 0x1000_00FF: MMIO GPIO
    wire sel_sram_inst = mem_valid && (mem_addr[31:11] == 21'b0) && (mem_addr[10] == 1'b0);
    wire sel_sram_data = mem_valid && (mem_addr[31:11] == 21'b0) && (mem_addr[10] == 1'b1);
    wire sel_gpio      = mem_valid && (mem_addr[31:8] == 24'h100000);

    reg sel_sram_inst_q;
    reg sel_sram_data_q;
    reg sel_gpio_q;
    reg [7:0] gpio_reg;

    // SRAM Controls
    assign sram_inst_csb   = ~sel_sram_inst;
    assign sram_inst_web   = ~(|mem_wstrb);
    assign sram_inst_wmask = mem_wstrb;
    assign sram_inst_addr  = mem_addr[9:0];
    assign sram_inst_din   = mem_wdata;

    assign sram_data_csb   = ~sel_sram_data;
    assign sram_data_web   = ~(|mem_wstrb);
    assign sram_data_wmask = mem_wstrb;
    assign sram_data_addr  = mem_addr[9:0];
    assign sram_data_din   = mem_wdata;

    // Bus cycle completion (1-cycle synchronous SRAM access)
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            mem_ready       <= 1'b0;
            sel_sram_inst_q <= 1'b0;
            sel_sram_data_q <= 1'b0;
            sel_gpio_q      <= 1'b0;
            gpio_reg        <= 8'h00;
            gpio_out        <= 8'h00;
        end else begin
            mem_ready <= 1'b0;
            sel_sram_inst_q <= 1'b0;
            sel_sram_data_q <= 1'b0;
            sel_gpio_q      <= 1'b0;

            if (mem_valid && !mem_ready) begin
                mem_ready       <= 1'b1;
                sel_sram_inst_q <= sel_sram_inst;
                sel_sram_data_q <= sel_sram_data;
                sel_gpio_q      <= sel_gpio;

                if (sel_gpio && (|mem_wstrb)) begin
                    gpio_reg <= mem_wdata[7:0];
                    gpio_out <= mem_wdata[7:0];
                end
            end
        end
    end

    // Read Data Mux
    always @(*) begin
        if (sel_sram_inst_q)
            mem_rdata = sram_inst_dout;
        else if (sel_sram_data_q)
            mem_rdata = sram_data_dout;
        else if (sel_gpio_q)
            mem_rdata = {24'h0, gpio_reg};
        else
            mem_rdata = 32'h00000000;
    end

endmodule
