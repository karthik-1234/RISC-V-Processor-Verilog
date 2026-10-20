`timescale 1ns / 1ps

module tb_register_file;

    reg clk;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] write_data;
    reg reg_write;

    wire [31:0] read_data1, read_data2;

    integer errors;
integer i;
reg [31:0] expected [1:31];

    register_file dut (
        .clk(clk),
        .rs1(rs1),
        .read_data1(read_data1),
        .rs2(rs2),
        .read_data2(read_data2),
        .rd(rd),
        .write_data(write_data),
        .reg_write(reg_write)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    task check_read;
        input [31:0] expected1;
        input [31:0] expected2;
        begin
            #1;

            if (read_data1 !== expected1 ||
                read_data2 !== expected2) begin
                $display("FAIL: rs1=%0d rs2=%0d", rs1, rs2);
                $display("Expected: %h %h", expected1, expected2);
                $display("Actual:   %h %h", read_data1, read_data2);
                errors = errors + 1;
            end else begin
                $display("PASS: rs1=%0d rs2=%0d", rs1, rs2);
            end
        end
    endtask

    task write_register;
        input [4:0] address;
        input [31:0] value;
        begin
            @(negedge clk);
            rd = address;
            write_data = value;
            reg_write = 1;

            @(posedge clk);
            #1;
            reg_write = 0;
        end
    endtask

    initial begin
        clk = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        write_data = 0;
        reg_write = 0;
        errors = 0;

        $display("Starting register-file tests...");

        // Test 1: x0 always reads zero
        rs1 = 0;
        rs2 = 0;
        check_read(0, 0);

        // Test 2: Write and read x1
        write_register(1, 32'd100);
        rs1 = 1;
        rs2 = 0;
        check_read(100, 0);

        // Test 3: Write and read x2
        write_register(2, 32'd200);
        rs1 = 1;
        rs2 = 2;
        check_read(100, 200);

        // Test 4: Write a large hexadecimal value
        write_register(5, 32'hDEADBEEF);
        rs1 = 5;
        rs2 = 2;
        check_read(32'hDEADBEEF, 200);

        // Test 5: Attempt to write to x0
        write_register(0, 32'hFFFFFFFF);
        rs1 = 0;
        rs2 = 5;
        check_read(0, 32'hDEADBEEF);

        // Test 6: Disabled write must not modify x3
        write_register(3, 32'd300);

        @(negedge clk);
        rd = 3;
        write_data = 32'd999;
        reg_write = 0;

        @(posedge clk);
        #1;
        rs1 = 3;
        rs2 = 0;
        check_read(300, 0);
        // Test 7: Overwrite x1 with a new value
        write_register(1, 32'h12345678);
        rs1 = 1;
        rs2 = 2;
        check_read(32'h12345678, 200);

        // Test 8: Verify x1 and x5 remain independent
        rs1 = 1;
        rs2 = 5;
        check_read(32'h12345678, 32'hDEADBEEF);

        // Test 9: Write and read the highest register, x31
        write_register(31, 32'hCAFEBABE);
        rs1 = 31;
        rs2 = 0;
        check_read(32'hCAFEBABE, 0);

        // Test 10: Verify x31 retains its value after another write
        write_register(10, 32'hABCDEF01);
        rs1 = 31;
        rs2 = 10;
        check_read(32'hCAFEBABE, 32'hABCDEF01);
                // Test 11: Write and verify all writable registers
        $display("Testing all writable registers...");

        for (i = 1; i < 32; i = i + 1) begin
            expected[i] = 32'hA5000000 + i;
            write_register(i, expected[i]);
        end

        for (i = 1; i < 32; i = i + 1) begin
            rs1 = i;
            rs2 = 0;
            check_read(expected[i], 0);
        end
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d errors", errors);

        $finish;
    end

endmodule