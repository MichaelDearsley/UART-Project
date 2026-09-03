`timescale 1ns/1ps

module uart_loopback_tb;

    logic clk;
    logic reset;

    logic [7:0] tx_data;
    logic tx_valid;
    logic tx;
    logic tx_ready;

    logic [7:0] rx_data;
    logic rx_valid;

    

    

    uart_tx tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .tx_ready(tx_ready),
        .tx(tx)
    );

    uart_rx rx_inst (
        .clk(clk),
        .reset(reset),
        .rx(tx),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    always #5 clk = ~clk;

    task send_byte(input logic [7:0] data);

        wait(tx_ready);

        @(negedge clk);
        tx_data = data;
        tx_valid = 1;

        @(negedge clk);
        tx_valid = 0;

        @(posedge rx_valid);

        if (rx_data == data)
            $display("PASS: Sent 0x%h, Received 0x%h", data, rx_data);
        else
            $display("FAIL: Sent 0x%h, Received 0x%h", data, rx_data);

    endtask

    initial begin

        $dumpfile("uart_loopback.vcd");
        $dumpvars(0, uart_loopback_tb);

        clk = 0;
        reset = 1;
        tx_data = 0; 
        tx_valid = 0;
        

        #20;

        reset = 0;

        #10;

        send_byte(8'h41);
        send_byte(8'h55);
        send_byte(8'hA5);
        send_byte(8'hFF);

        $finish;

    end

endmodule