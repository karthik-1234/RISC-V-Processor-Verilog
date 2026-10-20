`timescale 1ns / 1ps

module register_file (
    input wire clk,

    // Read port 1
    input wire [4:0] rs1,
    output wire [31:0] read_data1,

    // Read port 2
    input wire [4:0] rs2,
    output wire [31:0] read_data2,

    // Write port
    input wire [4:0] rd,
    input wire [31:0] write_data,
    input wire reg_write
);

    // 32 registers, each 32 bits wide
    reg [31:0] registers [0:31];

    // Synchronous write
    always @(posedge clk) begin
        if (reg_write && (rd != 5'd0)) begin
            registers[rd] <= write_data;
        end
    end

    // Asynchronous reads
    assign read_data1 = (rs1 == 5'd0)
                      ? 32'b0
                      : registers[rs1];

    assign read_data2 = (rs2 == 5'd0)
                      ? 32'b0
                      : registers[rs2];

endmodule