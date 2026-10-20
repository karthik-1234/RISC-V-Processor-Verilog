# RISC-V Processor in Verilog

A 32-bit RISC-V processor project focused on RTL design,
functional verification, and computer architecture.

## Project Status

### Completed

- [x] 32-bit Arithmetic Logic Unit (ALU)
- [x] ALU supports ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, and SLTU
- [x] ALU testbench with 16 directed test cases
- [x] ALU edge-case testing
- [x] 32 x 32-bit register file
- [x] Two combinational read ports
- [x] One synchronous write port
- [x] Register x0 always reads as zero
- [x] Register-file testbench with 41 passing checks
- [x] Tests covering all writable registers (x1-x31)

### Planned

- [ ] Instruction decoder
- [ ] Immediate generator
- [ ] Program counter
- [ ] Instruction and data memories
- [ ] Single-cycle RISC-V processor
- [ ] Expanded ALU verification with randomized tests

## Project Structure

```text
RISC-V-Processor-Verilog/
├── rtl/
│   ├── alu.v
│   └── register_file.v
├── tb/
│   ├── tb_alu.v
│   └── tb_register_file.v
├── programs/
├── docs/
├── .gitignore
└── README.md