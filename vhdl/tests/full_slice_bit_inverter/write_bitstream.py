
BITSTREAM_FILE = './bitstream.txt'

set_bits = [1,113,122,105,97,98,40,41,42,43,49,50,51,52,17]
set_bits = [6,93,94,52,53,54,55,44,45,46,47,76,4,5,7, 124,125,126,127, 116,117,118,119, 132,133,134,135] 

with open(BITSTREAM_FILE, 'w') as f:
    for i in range(136):
        if (i) in set_bits:
            f.write('1')
        else:
            f.write('0')
        if not (i+1)%8:
            f.write('\n')
            
    f.write('\n')
    

