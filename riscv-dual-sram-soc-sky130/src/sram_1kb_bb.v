/// sta-blackbox
`timescale 1ns / 1ps

(* blackbox *)
module sky130_sram_1k (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif
    input clk,
    input csb,
    input web,
    input [3:0] wmask,
    input [9:0] addr,
    input [31:0] din,
    output reg [31:0] dout
);

`ifndef SYNTHESIS
    reg [31:0] mem [0:255];
    wire [7:0] word_addr = addr[9:2];

    always @(posedge clk) begin
        if (!csb) begin
            if (!web) begin
                if (wmask[0]) mem[word_addr][ 7: 0] <= din[ 7: 0];
                if (wmask[1]) mem[word_addr][15: 8] <= din[15: 8];
                if (wmask[2]) mem[word_addr][23:16] <= din[23:16];
                if (wmask[3]) mem[word_addr][31:24] <= din[31:24];
            end
            dout <= mem[word_addr];
        end
    end
`endif

endmodule
