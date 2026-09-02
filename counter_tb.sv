//Testbench for counter
//Test bench will: Create a clock, Applies reset, Releases reset, Lets the counter run, Record signals for GTKwave

`timescale 1ns/1ps //Simulation time / Simulation precision

module counter_tb; //Define testbench

    logic clk; //Clock signal
    logic reset; //Rest signal

    logic [3:0] count; //Count comes out DUT

    counter dut ( 
        .clk (clk), //Connects port inside the counter to signal inside testbench
        .reset (reset), //Connects port inside the reset to signal inside testbench
        .count (count) //Connects port inside the count to signal inside testbench
    );

    always #5 clk = ~clk; //Every 5ns the clock inverts

    initial begin //Executes code once

        $dumpfile("counter.vcd"); //Creates a waveform called counter.vcd in Icarus
        $dumpvars(0, counter_tb); //Record the signals

        clk = 0; //Start clock at 0
        reset = 1; //Start with reset active

        #20; //Wait 20ns 

        reset = 0; //Counter is allowed to operate from 0 to 1

        #100; //Runs for 100ns

        $finish;

    end

endmodule

