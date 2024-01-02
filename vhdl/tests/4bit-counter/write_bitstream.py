
BITSTREAM_FILE = './bitstream.txt'

# LUT B has a toggle bit

set_bits = []

set_bits.append(133) # SW xpoint_2 south[2] to west [2]
set_bits.append(134) # SW xpoint_1 south[1] to west [1]
set_bits.append(135) # SW xpoint_0 south[0] to west [0]

set_bits.append(125) # SW en_bus_south[2]
set_bits.append(126) # SW en_bus_south[1]
set_bits.append(127) # SW en_bus_south[0]

set_bits.append(117) # SW en_bus_west[2]
set_bits.append(118) # SW en_bus_west[1]
set_bits.append(119) # SW en_bus_west[0]

set_bits.append(5) # CBv LUT C -> bus[2] enable
set_bits.append(6) # CBv LUT B -> bus[1] enable
set_bits.append(7) # CBv LUT A -> bus[0] enable

set_bits.append(89) # CBh presel_3 = 7
set_bits.append(90) # CBh presel_3 = 7
set_bits.append(91) # CBh presel_3 = 7

set_bits.append(93) # CBh presel_2 = 6
set_bits.append(94) # CBh presel_2 = 6

set_bits.append(97) # CBh presel_1 = 5
set_bits.append(99) # CBh presel_1 = 5

set_bits.append(15) # CLB LUT en reg a
set_bits.append(14) # CLB LUT en reg b
set_bits.append(13) # CLB LUT en reg c

# LUT A
for b in [24,25,26,27,28,29,30,31] :
    set_bits.append(b) #

# LUT B
#for b in [40,41,42,43,44,45,46,47] :
for b in [39,43,37,41] :
    set_bits.append(b) #

# LUT C
for b in [51,55] :
    set_bits.append(b) #

with open(BITSTREAM_FILE, 'w') as f:
    for i in range(136):
        if (i) in set_bits:
            f.write('1')
        else:
            f.write('0')
        if not (i+1)%8:
            f.write('\n')
            
    f.write('\n')
    

