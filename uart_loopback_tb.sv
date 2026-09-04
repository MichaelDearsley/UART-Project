`timescale 1ns/1ps

module uart_loopback_tb; //Define testbench

    logic clk;
    logic reset;
    logic [7:0] tx_data; //8 bit byte that the testbench gives to the transmitter
    logic tx_valid; 
    logic tx; //Serial output coming from UART TX (one bit at a time)
    logic tx_ready; //Tells the testbench whether the transmitter is available
    logic [7:0] rx_data; //9 bit byte that comes out of the reciever
    logic rx_valid; 

    uart_tx tx_inst ( //Creates instance of uart_tx hardware
        .clk(clk),
        .reset(reset),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .tx_ready(tx_ready),
        .tx(tx)
    );

    uart_rx rx_inst ( //Creates instance of uart_rx hardware
        .clk(clk),
        .reset(reset),
        .rx(tx), //Loopback connection, TX output to RX input
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    always #5 clk = ~clk; //Generate clock

    task send_byte(input logic [7:0] data); //Task is reusable code, checks if tx_data and rx_data align

        wait(tx_ready); //Wait until tx_ready is 1

        @(negedge clk); //At falling clock edge as UART operates on rising edge
        tx_data = data; 
        tx_valid = 1;

        @(negedge clk);
        tx_valid = 0;

        @(posedge rx_valid);

        if (rx_data == data) //Check if RX and TX match
            $display("PASS: Sent 0x%h, Received 0x%h", data, rx_data); //Prints that it passed
        else
            $display("FAIL: Sent 0x%h, Received 0x%h", data, rx_data);

    endtask

    initial begin

        $dumpfile("uart_loopback.vcd"); //Creates waveform file
        $dumpvars(0, uart_loopback_tb); //Records signals

        clk = 0;
        reset = 1;
        tx_data = 0; 
        tx_valid = 0;

        #20; //Wait 20ns
        
        reset = 0;

        #10;

        send_byte(8'h41); //Test byte 1
        send_byte(8'h55); //Test byte 2
        send_byte(8'hA5); //Test byte 3
        send_byte(8'hFF); //Test byte 4

        $finish;

    end

endmodule
