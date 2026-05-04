def convert_lc2k_hex_file(input_file, output_file):
    with open(input_file, "r") as f:
        lines = f.readlines()

    instructions = [line.strip() for line in lines if line.strip()]

    with open(output_file, "w") as f:
        for i, instr in enumerate(instructions):
            value = int(instr, 16)

            if value >= 2 ** 31:
                value -= 2 ** 32

            if i == 0:
                f.write(f"sMEM .fill {value}\n")
            else:
                f.write(f"     .fill {value}\n")


if __name__ == "__main__":
    convert_lc2k_hex_file("input.mc", "output.txt")
  
