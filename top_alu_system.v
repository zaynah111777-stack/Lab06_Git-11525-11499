`timescale 1ns / 1ps
module top_alu_system (
    input  wire clk,
    input  wire pbin,
    input  wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);
    wire rst_clean, slow_clk, zero_flag;
    wire [31:0] switch_data, alu_result;
    reg  [31:0] led_write_data = 32'd0;
    reg  [3:0]  alu_ctrl = 4'd0;

    // Lab 5 modules, reused as-is
    debouncer rst_db (.clk(clk), .pbin(pbin), .pbout(rst_clean));

    leds switch_reader (.clk(clk), .rst(rst_clean), .btns(16'd0),
        .writeData(32'd0), .writeEnable(1'b0), .readEnable(1'b1),
        .memAddress(30'd0), .switches(physical_sw), .readData(switch_data));

    switches led_writer (.clk(clk), .rst(rst_clean),
        .writeData(led_write_data), .writeEnable(1'b1),
        .readEnable(1'b0), .memAddress(30'd0),
        .readData(), .leds(physical_leds));

    clock_divider ticker (.clk_in(clk), .rst(rst_clean), .clk_out(slow_clk));

    // ALU with the two fixed operands
    Alu core_alu (.A(32'h10101010), .B(32'h01010101),
                  .ALUControl(alu_ctrl), .ALUResult(alu_result), .zero(zero_flag));


    localparam READ = 1'b0, SHOW = 1'b1;
    reg state = READ;

    always @(posedge slow_clk or posedge rst_clean) begin
        if (rst_clean) begin
            state <= READ;
            alu_ctrl <= 4'd0;
            led_write_data <= 32'd0;
        end else begin
            case (state)
                READ: begin
                    alu_ctrl <= switch_data[3:0];      // SW0-SW3 = ALUControl
                    state <= SHOW;
                end
                SHOW: begin
                    if (switch_data[15])               // SW15 = 1: upper 16 bits
                        led_write_data <= {16'd0, alu_result[31:16]};
                    else                               // SW15 = 0: lower 15 bits + Zero on LED15
                        led_write_data <= {16'd0, zero_flag, alu_result[14:0]};
                    state <= READ;
                end
            endcase
        end
    end
endmodule