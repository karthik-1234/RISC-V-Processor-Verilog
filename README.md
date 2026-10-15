# RISC-V Processor in Verilog

A 32-bit RISC-V processor project focused on RTL design,
functional verification, and computer architecture.

## Project Status

### Completed
- [x] 32-bit Arithmetic Logic Unit (ALU)
- [x] Directed testbench with 16 test cases
- [x] Arithmetic, bitwise, shift, and comparison operations
- [x] Edge-case testing for arithmetic wraparound

### Planned
- [ ] Register file
- [ ] Instruction decoder
- [ ] Immediate generator
- [ ] Program counter
- [ ] Instruction and data memories
- [ ] Single-cycle RISC-V processor
- [ ] Expanded verification with randomized tests

## Project Structure

```text
RISC-V-Processor-Verilog/
├── rtl/
│   └── alu.v
├── tb/
│   └── tb_alu.v
├── programs/
├── docs/
├── .gitignore
└── README.md