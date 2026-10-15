`timescale 1ns / 1ps
module alu (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALUControl,
    output reg  [31:0] Result
);

    localparam ADD  = 4'b0000;
    localparam SUB  = 4'b0001;
    localparam AND_ = 4'b0010;
    localparam OR_  = 4'b0011;
    localparam XOR_ = 4'b0100;
    localparam SLL  = 4'b0101;
    localparam SRL  = 4'b0110;
    localparam SRA  = 4'b0111;
    localparam SLT  = 4'b1000;
    localparam SLTU = 4'b1001;

    always @(*) begin
        Result = 32'b0;

        case (ALUControl)
            ADD:  Result = A + B;
            SUB:  Result = A - B;

            AND_: Result = A & B;
            OR_:  Result = A | B;
            XOR_: Result = A ^ B;

            SLL:  Result = A << B[4:0];
            SRL:  Result = A >> B[4:0];
            SRA:  Result = $signed(A) >>> B[4:0];

            SLT:  Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            SLTU: Result = (A < B) ? 32'd1 : 32'd0;

            default: Result = 32'b0;
        endcase
    end

endmodule