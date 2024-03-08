
BITSTREAM_FILE = './bitstream.txt'
set_bits = []

# LUT A has a toggle bit

set_bits.append(7) # CBv LUT A -> bus[0] enable
set_bits.append(111) # SW xpoint_1 south[0] to west [0]
set_bits.append(119) # SW en_bus_south[0]
set_bits.append(127) # SW en_bus_west[0]
set_bits.append(101) # CBh presel_3[2] = +4
set_bits.append(102) # CBh presel_3[1] = +2
set_bits.append(103) # CBh presel_3[0] = +1
set_bits.append(15) # CLB LUT en reg a

for b in [17,19,21,23,25,27,29,31] :
    set_bits.append(b) 

with open(BITSTREAM_FILE, 'w') as f:
    for i in range(136):
        if (i) in set_bits:
            f.write('1')
        else:
            f.write('0')
        if not (i+1)%8:
            f.write('\n')
            
    f.write('\n')
    

