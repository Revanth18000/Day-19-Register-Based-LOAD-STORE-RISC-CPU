module risc_reg_mem_cpu (
    input clk,
    input reset,
    output [7:0] R0,
    output [7:0] R1,
    output [7:0] R2,
    output [7:0] R3
);

    reg [3:0] PC;
    reg [7:0] IR;

    // Register file
    reg [7:0] reg_file [0:3];

    // Data memory
    reg [7:0] data_mem [0:15];

    // Instruction fields
    wire [1:0] rd     = IR[7:6];
    wire [1:0] rs1    = IR[5:4];
    wire [1:0] rs2    = IR[3:2];
    wire [1:0] opcode = IR[1:0];

    // Opcodes
    parameter ADD   = 2'b00;
    parameter SUB   = 2'b01;
    parameter LOAD  = 2'b10;
    parameter STORE = 2'b11;

    // Program memory
    reg [7:0] program [0:15];

    initial begin
        // Format: [rd rs1 rs2 opcode]

        program[0] = 8'b01_10_00_10; // LOAD  R1, R2
        program[1] = 8'b11_01_00_00; // ADD   R3 = R1 + R0
        program[2] = 8'b00_11_01_11; // STORE R0 -> MEM[R3]

        reg_file[0] = 8'd2;
        reg_file[1] = 0;
        reg_file[2] = 8'd4;  // memory address
        reg_file[3] = 0;

        data_mem[4] = 8'd10;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 0;
        end else begin

            IR <= program[PC];
            PC <= PC + 1;

            case(opcode)

                ADD:
                    reg_file[rd] <= reg_file[rs1] + reg_file[rs2];

                SUB:
                    reg_file[rd] <= reg_file[rs1] - reg_file[rs2];

                LOAD:
                    reg_file[rd] <= data_mem[reg_file[rs1]];

                STORE:
                    data_mem[reg_file[rs1]] <= reg_file[rs2];

            endcase
        end
    end

    assign R0 = reg_file[0];
    assign R1 = reg_file[1];
    assign R2 = reg_file[2];
    assign R3 = reg_file[3];

endmodule