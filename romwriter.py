INPUT_FILE = "./rom.bin"
TARGET_FILE = "./src/gowin_dpb/gowin_dpb.v"

import re

def main():
    print("Reading input file...")
    with open(INPUT_FILE, "rb") as f:
        rom = f.read()
    # 64 blocks × 36 bytes = 2304 bytes
    if len(rom) < 64 * 36:
        rom = rom + b"\x00" * (64 * 36 - len(rom))
    elif len(rom) > 64 * 36:
        rom = rom[:64 * 36]

    # Split every 36 bytes and convert to a 288-bit hex string (MSB→LSB)
    init_list = []
    for i in range(64):
        chunk = rom[i*36:(i+1)*36]
        chunk = chunk[::-1]  # Reverse byte order (MSB/LSB fix)
        hexstr = chunk.hex().upper()
        init_list.append(f"288'h{hexstr}")

    # Read gowin_dpb.v
    with open(TARGET_FILE, "r", encoding="utf-8") as f:
        vsrc = f.read()

    # First, initialize all dpx9b_inst_<number>.INIT_RAM_XX with zeros
    def zero_replacer(match):
        return f"defparam dpx9b_inst_{match.group(1)}.INIT_RAM_{match.group(2)} = 288'h{'0'*72};"
    vsrc_zeroed = re.sub(
        r"defparam dpx9b_inst_(\d+)\.INIT_RAM_([0-3A-Fa-f]{2}) = 288'h[0-9A-Fa-f]+;",
        zero_replacer,
        vsrc
    )

    # Treat dpx9b_inst_0, 1, 2... as consecutive memory regions of 64 words each
    def data_replacer(match):
        inst_num = int(match.group(1))
        idx = int(match.group(2), 16)
        rom_idx = inst_num * 64 + idx
        if rom_idx < len(init_list):
            return f"defparam dpx9b_inst_{inst_num}.INIT_RAM_{match.group(2)} = {init_list[rom_idx]};"
        else:
            return f"defparam dpx9b_inst_{inst_num}.INIT_RAM_{match.group(2)} = 288'h{'0'*72};"

    vsrc_new = re.sub(
        r"defparam dpx9b_inst_(\d+)\.INIT_RAM_([0-3A-Fa-f]{2}) = 288'h0+;",
        data_replacer,
        vsrc_zeroed
    )

    with open(TARGET_FILE, "w", encoding="utf-8") as f:
        f.write(vsrc_new)
    print("Done.")

if __name__ == "__main__":
    main()
