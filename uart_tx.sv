//UART - Way of two digital devices to communicate using a serial wire
//TX - Transmit RX - Recieve
//UART sends one bit at a time, so UART TX is hardware block that converts a byte into a serial stream of bits
//UART uses 8N1 which for one byte goes: Idle, Start, 8 data bits, Stop
//UART needs to count clock cycles between transmitted bits, hence we need to know when to move the bit
//If the clock is 100MHz and baud rate is 10MHz, 100/10 = 10, hence every 10 clock cycles the TX moves onto the next UART bit

module uart_tx #( //Define UART_TX hardware block
    parameter int CLK_FREQ = 100_000_000,
    parameter int BAUD_RATE = 10_000_000
    
) ( 
    input logic clk,
    input logic reset,
    output logic tx
);

    localparam int CLKS_PER_BIT = CLK_FREQ / BAUD_RATE; //localparam is used as the value is calculated from parameters

    logic [$clog2(CLKS_PER_BIT)-1:0] baud_count; //4 bits is enough to represent 0-9 binary, and $clog2() means ceiling of log base 2

    always_ff @(posedge clk) begin //On rising edge, is reset = 1? If yes baud_count = 0, If no reached 9? If yes = 0 If no count + 1

        if (reset)
            baud_count <= 0;

        else if (baud_count == CLKS_PER_BIT - 1)
            baud_count <= 0;

        else 
            baud_count <= baud_count + 1'b1;
    end

endmodule