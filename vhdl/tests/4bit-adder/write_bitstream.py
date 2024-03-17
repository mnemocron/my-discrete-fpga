
BITSTREAM_FILE = './bitstream.txt'

# LUT B has a toggle bit

set_bits = []

set_bits.append(4) # CBv LUT D -> bus[3] enable
set_bits.append(5) # CBv LUT C -> bus[2] enable
set_bits.append(6) # CBv LUT B -> bus[1] enable
set_bits.append(7) # CBv LUT A -> bus[0] enable

set_bits.append(15) # CLB LUT en reg a
set_bits.append(14) # CLB LUT en reg b
set_bits.append(13) # CLB LUT en reg c
set_bits.append(12) # CLB LUT en reg d
set_bits.append(11) # CLB en sum mode

set_bits.append(80) # CLB insel d = 2 --> sum mode
set_bits.append(82) # CLB insel c = 2 --> sum mode
set_bits.append(84) # CLB insel b = 2 --> sum mode
set_bits.append(86) # CLB insel a = 2 --> sum mode

# LUT A
for b in [17,18,21,22,25,26,29,30] :
    set_bits.append(b) #

# LUT B
for b in [] :
    set_bits.append(b) #

# LUT C
for b in [] :
    set_bits.append(b) #

# LUT D
for b in [] :
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
    

