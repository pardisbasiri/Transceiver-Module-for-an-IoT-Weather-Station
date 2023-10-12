module transceiver(
  input clk, rst,
  input [2:0] signal,
  input wire [4:0] current_hour, // 5-bit input representing the current hour
  output reg [5:0] temperature,
  output reg [5:0] humidity,
  output reg [4:0] wind,
  output wire enable_transceiver // Enable signal for the transceiver
);

  // Define time constants for 12:00 PM and 4:00 PM
  parameter TIME_12_PM = 5'b11000; // 12:00 PM in 24-hour format
  parameter TIME_4_PM = 5'b100;    // 4:00 PM in 24-hour format

  reg [11:0] cnt = 0;
  reg flag_hour = 1'b0;
  reg [2:0] received_signal = 3'b000; // Initialize received_signal to an invalid value

  always @ (posedge clk) begin
    if (rst) begin
      temperature <= 43;
      humidity <= 52;
      wind <= 19;
      flag_hour <= 1'b0;
      cnt <= 0;
    end else begin
      flag_hour <= 1'b0;
      cnt <= cnt + 1;

      // Check if the current time is within the specified range (12:00 PM to 4:00 PM)
      if (current_hour >= TIME_12_PM && current_hour <= TIME_4_PM) begin
        enable_transceiver <= 1'b1; // Enable the transceiver
      end else begin
        enable_transceiver <= 1'b0; // Disable the transceiver
      }

      // Check if a signal has been received
      if (received_signal != 3'b000) begin
        case (received_signal)
          3'b111: temperature <= temperature + 3;
          3'b010: humidity <= humidity + 1;
          3'b101: wind <= wind + 8;
          default: begin
            // Handle unknown signals here
          end
        endcase
        // Reset the received_signal after processing
        received_signal <= 3'b000;
      }

      // Check the signal and set received_signal accordingly
      case (signal)
        3'b111: received_signal <= 3'b111; // Temperature signal
        3'b010: received_signal <= 3'b010; // Humidity signal
        3'b101: received_signal <= 3'b101; // Wind signal
        default: received_signal <= 3'b000; // No valid signal received
      endcase
    end
  end
endmodule
