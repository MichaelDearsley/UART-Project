//Testbench for TX

`timescale 1ns/1ps

module uart_tx_tb;

    logic clk;
    logic reset;
    logic [7:0] tx_data;
    logic tx_valid;
    logic tx;

    uart_tx dut (
        .clk(clk),
        .reset(reset),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .tx(tx)
    );

    always #5 clk = ~clk;

    initial begin 

        $dumpfile("uart_tx.vcd");
        $dumpvars(0, uart_tx_tb);

        clk = 0;
        reset = 1;
        tx_data = 8'h41; //Sends ASCII A
        tx_valid = 0;

        #20;

        reset = 0;

        #10;

        tx_valid = 1;

        #10;

        tx_valid = 0;

        #110

        $finish;

    end

endmodule
