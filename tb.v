`timescale 1ns / 1ps

module tb_transceiver();

  reg clk;
  reg rst;
  wire [2:0] signal;
  wire [4:0] current_hour;
  wire enable_transceiver;
  reg [5:0] temperature;
  reg [5:0] humidity;
  reg [4:0] wind;

  // Instantiate the transceiver module
  transceiver transceiver_inst (
    .clk(clk),
    .rst(rst),
    .signal(signal),
    .current_hour(current_hour),
    .enable_transceiver(enable_transceiver),
    .temperature(temperature),
    .humidity(humidity),
    .wind(wind)
  );

  // Clock generation
  always begin
    #5 clk = ~clk; // Toggle the clock every 5 time units
  end

  // Initialize signals
  initial begin
    clk = 0;
    rst = 0;
    signal = 3'b000;
    current_hour = 5'b00000;
    #10 rst = 1; // Apply reset
    #20 rst = 0; // Release reset
  end

  // Test case 1: Transceiver is enabled
  initial begin
    $display("Test Case 1: Transceiver is enabled.");
    current_hour = 5'b11001; // Set the current hour to 12:30 PM
    #100; // Run the simulation for a while
    if (enable_transceiver) $display("Transceiver is enabled.");
    else $display("Transceiver is disabled.");
    $finish;
  end

  // Test case 2: Transceiver is disabled
  initial begin
    $display("Test Case 2: Transceiver is disabled.");
    current_hour = 5'b01000; // Set the current hour to 4:00 AM
    #100; // Run the simulation for a while
    if (enable_transceiver) $display("Transceiver is enabled.");
    else $display("Transceiver is disabled.");
    $finish;
  end

endmodule
