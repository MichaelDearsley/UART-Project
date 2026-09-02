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
    input logic [7:0] tx_data, //UART data bits
    input logic tx_valid,
    output logic tx
);

    localparam int CLKS_PER_BIT = CLK_FREQ / BAUD_RATE; //localparam is used as the value is calculated from parameters

    logic [$clog2(CLKS_PER_BIT)-1:0] baud_count; //4 bits is enough to represent 0-9 binary, and $clog2() means ceiling of log base 2
    logic [9:0] shift_reg; //10 bit storage for UART bits
    logic busy; 

    always_ff @(posedge clk) begin //On rising edge, is reset = 1? If yes reset values, If no normal operation

        if (reset) begin
            baud_count <= 0;
            shift_reg <= 0; //Clear the UART frame
            busy <= 0; //Not busy, not transmitting
            tx <= 1; //UARTS idle is HIGH 
        end

        else begin

            if (!busy) begin //Start transmitting
                if (tx_valid) begin //Is there a byte ready
                    shift_reg <= {1'b1, tx_data, 1'b0}; //Load shift register storing 1st bit (Start bit), 8 data bits, last bit (stop bit)
                    busy <=1; 
                    baud_count <= 0; //Reset timing counter
                    tx <= 0;
                end
            end
            if (busy) begin //If transmitting

                if (baud_count == CLKS_PER_BIT - 1) begin  //If the clock cycles match the UART bit
                    baud_count <= 0;

                    shift_reg <= {1'b1, shift_reg[9:1]}; //Shift the register to the right e.g. 1010000010 goes to 1101000001
                    tx <= shift_reg[1]; //Next bit goes onto TX wire
                end
                else begin
                    baud_count <= baud_count +1'b1;
                end
            end
        end
    end

endmodule
