//Testbench for TX

`timescale 1ns/1ps

module uart_tx_tb;

    logic clk;
    logic reset;
    logic tx;

    uart_tx dut (
        .clk(clk),
        .reset(reset),
        .tx(tx)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("uart_tx.vcd");
        $dumpvars(0, uart_tx_tb);

        clk = 0;
        reset = 1;

        #20;

        reset = 0;

        #200;

        $finish;

    end

endmodule