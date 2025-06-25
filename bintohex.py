INPUT = "rom.bin"
OUTPUT = "rom.hex"


def bin_to_hex(input_file, output_file):
    with open(input_file, "rb") as bin_file:
        data = bin_file.read()

    with open(output_file, "w") as hex_file:
        for i in range(0, len(data), 2):
            word = data[i : i + 2]
            if len(word) < 2:
                word = word + b"\x00"  # padding
            # little-endian
            hex_file.write(f"{word[0]:02x}\n")
            hex_file.write(f"{word[1]:02x}\n")


if __name__ == "__main__":
    bin_to_hex(INPUT, OUTPUT)
    print(f"Converted {INPUT} to {OUTPUT}")
