//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Physical Constraints file
//Tool Version: V1.9.11.01 Education (64-bit)
//Part Number: GW2A-LV18PG256C8/I7
//Device: GW2A-18
//Device Version: C
//Created Time: Thu 06 05 11:38:50 2025

// 27MHz
create_clock -name clock -period 37.037 -waveform {0 18.518} [get_ports {clock}]
