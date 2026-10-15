`timescale 1ns / 1ps

module tb_alu;

    reg  [31:0] A;
    reg  [31:0] B;
    reg  [3:0]  ALUControl;
    wire [31:0] Result;

    integer errors;

    // Connect the testbench to our ALU
    alu dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result)
    );

    // Check the result of each operation
    task check_result;
        input [31:0] expected;
        begin
            #10;

            if (Result !== expected) begin
                $display("FAIL: Expected=%h, Actual=%h",
                         expected, Result);
                errors = errors + 1;
            end
            else begin
                $display("PASS: Expected=%h, Actual=%h",
                         expected, Result);
            end
        end
    endtask

    initial begin
        errors = 0;

        // Test 1: Addition
        A = 10;
        B = 5;
        ALUControl = 4'b0000;
        check_result(15);

        // Test 2: Subtraction
        A = 10;
        B = 5;
        ALUControl = 4'b0001;
        check_result(5);

        // Test 3: Bitwise AND
        A = 32'hA;
        B = 32'hC;
        ALUControl = 4'b0010;
        check_result(32'h8);

        // Test 4: Bitwise OR
        A = 32'hA;
        B = 32'hC;
        ALUControl = 4'b0011;
        check_result(32'hE);

        // Test 5: Bitwise XOR
        A = 32'hA;
        B = 32'hC;
        ALUControl = 4'b0100;
        check_result(32'h6);

        // Test 6: Logical left shift
        A = 1;
        B = 3;
        ALUControl = 4'b0101;
        check_result(8);

        // Test 7: Logical right shift
        A = 16;
        B = 2;
        ALUControl = 4'b0110;
        check_result(4);

        // Test 8: Arithmetic right shift
        A = 32'hFFFFFFF8; // -8 in signed 32-bit representation
        B = 2;
        ALUControl = 4'b0111;
        check_result(32'hFFFFFFFE); // -2

        // Test 9: Signed comparison
        A = 32'hFFFFFFFF; // -1
        B = 1;
        ALUControl = 4'b1000;
        check_result(1);

        // Test 10: Unsigned comparison
        A = 32'hFFFFFFFF;
        B = 1;
        ALUControl = 4'b1001;
        check_result(0);
        
        // Test 11: Addition overflow (32-bit wraparound)
        A = 32'hFFFFFFFF;
        B = 1;
        ALUControl = 4'b0000;
        check_result(32'h00000000);

        // Test 12: Subtraction underflow (32-bit wraparound)
        A = 0;
        B = 1;
        ALUControl = 4'b0001;
        check_result(32'hFFFFFFFF);

        // Test 13: Signed comparison with minimum negative integer
        A = 32'h80000000;
        B = 1;
        ALUControl = 4'b1000;
        check_result(1);

        // Test 14: Unsigned comparison with the same bit patterns
        A = 32'h80000000;
        B = 1;
        ALUControl = 4'b1001;
        check_result(0);

        // Test 15: Left shift by the maximum shift amount
        A = 1;
        B = 31;
        ALUControl = 4'b0101;
        check_result(32'h80000000);

        // Test 16: Unsupported ALU control
        A = 10;
        B = 5;
        ALUControl = 4'b1111;
        check_result(0);

        // Final report
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d errors", errors);

        $finish;
    end

endmodule