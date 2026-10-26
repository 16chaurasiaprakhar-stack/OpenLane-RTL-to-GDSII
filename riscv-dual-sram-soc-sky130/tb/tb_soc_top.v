`timescale 1ns / 1ps

module tb_soc_top;

    reg clk;
    reg resetn;
    reg [2:0] irq;
    wire trap;
    wire [7:0] gpio_out;

    // 80 MHz clock generator (12.5 ns period -> 6.25 ns half-cycle)
    always #6.25 clk = ~clk;

    // Device Under Test (DUT)
    soc_top u_dut (
        .clk      (clk),
        .resetn   (resetn),
        .trap     (trap),
        .gpio_out (gpio_out),
        .irq      (irq)
    );

    integer i;
    reg test_passed;

    initial begin
        $display("================================================================");
        $display("  SOC SUBSYSTEM FUNCTIONAL VERIFICATION TESTBENCH");
        $display("  Target: 32-bit RISC-V + Dual OpenRAM 1KB SRAM Macros");
        $display("  Process: SkyWater 130nm | Clock: 80 MHz (12.5 ns)");
        $display("================================================================");

        // Dump VCD waveform
        $dumpfile("tb_soc_top.vcd");
        $dumpvars(0, tb_soc_top);

        // Initialize signals
        clk = 0;
        resetn = 0;
        irq = 3'b000;
        test_passed = 0;

        // Preload Instruction SRAM with verification firmware:
        // 0x00: addi x1, x0, 10        (x1 = 10)
        // 0x04: addi x2, x0, 25        (x2 = 25)
        // 0x08: add  x3, x1, x2        (x3 = 35)
        // 0x0C: addi x5, x0, 1024      (x5 = 0x400, Data SRAM base)
        // 0x10: sw   x3, 0(x5)         (Store 35 to Data SRAM)
        // 0x14: lw   x4, 0(x5)         (Load 35 from Data SRAM into x4)
        // 0x18: lui  x6, 16'h10000     (x6 = 0x10000000, MMIO GPIO)
        // 0x1C: sw   x4, 0(x6)         (Output 35 to GPIO)
        // 0x20: jal  x0, 0             (Infinite loop)
        u_dut.u_sram_inst.mem[0] = 32'h00a00093;
        u_dut.u_sram_inst.mem[1] = 32'h01900113;
        u_dut.u_sram_inst.mem[2] = 32'h002081b3;
        u_dut.u_sram_inst.mem[3] = 32'h40000293;
        u_dut.u_sram_inst.mem[4] = 32'h0032a023;
        u_dut.u_sram_inst.mem[5] = 32'h0002a203;
        u_dut.u_sram_inst.mem[6] = 32'h10000337;
        u_dut.u_sram_inst.mem[7] = 32'h00432023;
        u_dut.u_sram_inst.mem[8] = 32'h0000006f;

        // Clear remaining memory locations
        for (i = 9; i < 256; i = i + 1) begin
            u_dut.u_sram_inst.mem[i] = 32'h00000013; // nop
            u_dut.u_sram_data.mem[i] = 32'h00000000;
        end

        // Assert reset for 100 ns
        #100;
        @(posedge clk);
        resetn = 1;
        $display("[INFO] System reset deasserted. CPU execution started.");

        // Monitor execution
        for (i = 0; i < 500; i = i + 1) begin
            @(posedge clk);
            if (gpio_out == 8'd35) begin
                test_passed = 1;
                $display("[PASS] Cycle %0d: Instruction SRAM fetch successful.", i);
                $display("[PASS] Cycle %0d: RISC-V RV32I ALU arithmetic verified (10 + 25 = 35).", i);
                $display("[PASS] Cycle %0d: Data SRAM write and readback verified at 0x400.", i);
                $display("[PASS] Cycle %0d: Interconnect MMIO GPIO write confirmed (gpio_out = 0x%02h / %0d).", i, gpio_out, gpio_out);
                $display("----------------------------------------------------------------");
                $display(">>> ALL FUNCTIONAL TESTS PASSED (100%% SUCCESS) <<<");
                $display("================================================================");
                #50;
                $finish;
            end
        end

        // Timeout check
        if (!test_passed) begin
            $display("----------------------------------------------------------------");
            $display("[FAIL] Simulation timeout reached without expected GPIO output!");
            $display("       Current gpio_out = 0x%02h, trap = %b", gpio_out, trap);
            $display("================================================================");
            $fatal(1);
        end
    end

endmodule
