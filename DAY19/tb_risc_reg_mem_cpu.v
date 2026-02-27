module tb_risc_reg_mem_cpu;

    reg clk = 0;
    reg reset = 1;

    wire [7:0] R0, R1, R2, R3;

    // Instantiate DUT
    risc_reg_mem_cpu DUT (
        .clk(clk),
        .reset(reset),
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .R3(R3)
    );

    // Clock generation (10 time unit period)
    always #5 clk = ~clk;

    initial begin
        // Release reset
        #10 reset = 0;

        // Let CPU execute
        #150;

        // Display register values
        $display("---- Register Values ----");
        $display("R0 = %d", R0);
        $display("R1 = %d", R1);
        $display("R2 = %d", R2);
        $display("R3 = %d", R3);

        $finish;
    end

endmodule