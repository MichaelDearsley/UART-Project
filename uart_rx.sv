//UART RX 
    
module uart_rx #( //Define RX hardware block
    parameter int CLK_FREQ = 100_000_000,
    parameter int BAUD_RATE = 10_000_000
) (
    input logic clk,
    input logic reset,
    input logic rx, //RX is input as serial data comes into RX
    output logic [7:0] rx_data,
    output logic rx_valid
);

    localparam int CLKS_PER_BIT = CLK_FREQ / BAUD_RATE; //Stored as localparam as using parameters
    logic [$clog2(CLKS_PER_BIT)-1:0] baud_count; //Counts clock cycles within a UART bit using log function
    logic receiving; // 0 = waiting, 1 = recieving a frame
    logic [7:0] rx_data_reg; //Stores the 8 recieved data bits
    logic [2:0] bit_count; //Tracks bit recieved
    logic start_check; // 1 = checking whether a detected low is a real start bit
    logic frame_error;

    always_ff @(posedge clk) begin //Start at positive clock edge

        if (reset) begin //Reset puts everything into starting state
            baud_count <= 0;
            receiving <= 0;
            start_check <= 0;
            bit_count <= 0;
            rx_data_reg <= 0;
            frame_error <= 0;
            rx_data <= 0;
            rx_valid <= 0;
        end

        else begin

            rx_valid <= 0;
            if (!receiving && !start_check) begin //If not recieving and not checking a start bit, watch for RX going LOW

                if (rx == 1'b0) begin
                    start_check <= 1;
                    baud_count <= 0;
                end

            end

            else if (start_check) begin  //If detected a possible start bit, wait half a bit and check again

                if (baud_count == (CLKS_PER_BIT / 2)) begin
                    baud_count <= 0;

                    if (rx == 1'b0) begin
                        start_check <= 0;
                        receiving <= 1;
                        bit_count <= 0;
                    end
                    else begin
                        start_check <= 0;
                    end
                end

                else begin
                    baud_count <= baud_count + 1'b1;
                end
            
            end
            else if (receiving) begin //If we are currently receiving a UART frame

                if (baud_count == CLKS_PER_BIT - 1) begin //Check baud counter, see if one complete UART bit period has passed
                    baud_count <= 0; //Reset counter

                    if (bit_count == 4'd8) begin //If bit count = 8 (stop bit) 
                        
                        if (rx == 1'b1) begin //Check RX line for 1
                           frame_error <= 0; //If RX = 1, stop bit is correct
                           rx_data <= rx_data_reg; //Copy over 
                           rx_valid <= 1; //Data is ready
                        end
                        else begin
                            frame_error <= 1; //Stop bit should have been recieved, hence error
                        end
                        receiving <= 0; 
                        bit_count <= 0;
                    end
        
                    else begin
                        rx_data_reg[bit_count] <= rx; //Store incoming bit
                        bit_count <= bit_count + 1'b1; //Move to the next bit
                    end
                end
                else begin
                    baud_count <= baud_count + 1'b1; 
                end

            end

        end

    end

endmodule