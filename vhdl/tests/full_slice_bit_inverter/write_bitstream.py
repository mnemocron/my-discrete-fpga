
BITSTREAM_FILE = './bitstream.txt'

# LUT B has a toggle bit

set_bits = []

set_bits.append(134) # SW xpoint_1 south[1] to west [1]
set_bits.append(126) # SW en_bus_south[1]
set_bits.append(118) # SW en_bus_west[1]
set_bits.append(6) # CBv LUT B -> bus[1] enable
set_bits.append(89) # CBh presel_3 = 6
set_bits.append(90) # CBh presel_3 = 6
set_bits.append(14) # CLB LUT en reg b
for b in [40,41,42,43,44,45,46,47] :
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
    

