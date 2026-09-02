module counter ( //Creates hardware block called counter
    input logic clk, //Clock input
    input logic reset, //Reset Input

    output logic[3:0] count //Outputs 4-bit number
);

    always_ff @(posedge clk) begin //Runs everytime the clock goes from 0 to 1

    if (reset) 
        count <= 4'b0000; //When the reset is active count = 0

    else
        count <= count + 1'b1; //Increase count

    end

endmodule