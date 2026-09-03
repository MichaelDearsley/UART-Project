`timescale 1ns/1ps

module uart_rx_tb;

    logic clk;
    logic reset;
    logic rx;

    logic [7:0] rx_data;
    logic rx_valid;

    uart_rx dut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    always #5 clk = ~clk;

    initial begin

    $dumpfile("uart_rx.vcd");
    $dumpvars(0, uart_rx_tb);

    clk = 0;
    reset = 1;
    rx = 1; //UART idle is HIGH

    #20;

    reset = 0;

    #10;
    
    rx = 0; //Send start bit
    #100; //Wait 100ns with start bit

    rx = 1; //Sample D0
    #100;

    rx = 0; //Sample D1
    #100;

    rx = 0; //Sample D2
    #100;

    rx = 0; //Sample D3
    #100;

    rx = 0; //Sample D4
    #100;

    rx = 0; //Sample D5
    #100;

    rx = 1; //Sample D6
    #100;

    rx = 0; //Sample D7
    #100;

    rx = 1; //Stop bit
    #100;

    #20;

    $finish;

end

endmodule