# -*- coding: utf-8 -*-

JSON_FILE = './config-concept.json'
OUT_FILE = './bitstream.txt' # or bitstream.h
OUT_FORMAT = 'stimuli' # or arduino

VALID_OPT_BUS = ['north', 'south', 'east', 'west']
VALID_OPT_BUSBITS = ['e0','e1','e2','e3','w0','w1','w2','w3','n0','n1','n2','n3','s0','s1','s2','s3']
VALID_OPT_PRIOBITS = ['_n0','_n1','_s0','_s1','_w0','_w1','_e0','_e1']
SW_MATRIX = {}
SW_MATRIX['n'] = [123,122,121,120]
SW_MATRIX['s'] = [127,126,125,124]
SW_MATRIX['e'] = [115,114,113,112]
SW_MATRIX['w'] = [119,118,117,116]
SW_MATRIX['x'] = [135,134,133,132]
SW_MATRIX['_e'] = [105,104]
SW_MATRIX['_w'] = [107,106]
SW_MATRIX['_n'] = [109,108]
SW_MATRIX['_s'] = [111,110]
SW_MATRIX['x'] = [135,134,133,132]
SW_MATRIX['_x'] = []

import json

# try catch
with open(JSON_FILE) as fil:
    raw = json.load(fil)

set_bits = []

if('slices' in raw):
    for slice in raw['slices']:
        bit_offset = 0
        # location adds to bit_offset
        if('reg' in slice):
            reg = slice['reg']
            for key in reg:
                key = key.lower()
                if(key == 'a'):
                    if(reg[key]):
                        set_bits.append(72)
                elif(key == 'b'):
                    if(reg[key]):
                        set_bits.append(73)
                elif(key == 'c'):
                    if(reg[key]):
                        set_bits.append(74)
                elif(key == 'd'):
                    if(reg[key]):
                        set_bits.append(75)
                        
        if('clk_sel' in slice):
            clk_sel = int(slice['clk_sel'])
            if(clk_sel > 1):
                print("error")
            if(clk_sel == 1):
                set_bits.append(77)
                
        if('routes' in slice):
            for route in slice['routes']:
                for src in route:
                    dst = route[src].lower()
                    src = src.lower()
                    xps = []
                    if(src == dst):
                        print('error')
                    if(src in VALID_OPT_BUS and dst in VALID_OPT_BUS):
                        pts = [src,dst]
                        if('east'  in pts):
                            xps += ['e0', 'e1', 'e2', 'e3']
                        if('west'  in pts):
                            xps += ['w0', 'w1', 'w2', 'w3']
                        if('north' in pts):
                            xps += ['n0', 'n1', 'n2', 'n3']
                        if('south' in pts):
                            xps += ['s0', 's1', 's2', 's3']
                    elif(src in VALID_OPT_BUSBITS and dst in VALID_OPT_BUSBITS):
                        xps += [src, dst]
                    elif(src in VALID_OPT_PRIOBITS and dst in VALID_OPT_PRIOBITS):
                        xps += [src, dst]
                    else:
                        print('a error')
                    for bit in xps:
                        num = bit[-1]
                        alp = bit.split(num)[0]
                        num = int(num)
                        if(alp in ['n','s']):
                            crspt = 'e' + str(num)
                            if(crspt in xps):
                                set_bits.append(SW_MATRIX['x'][num])
                            crspt = 'w' + str(num)
                            if(crspt in xps):
                                set_bits.append(SW_MATRIX['x'][num])
                        if(alp in ['e','w']):
                            crspt = 'n' + str(num)
                            if(crspt in xps):
                                set_bits.append(SW_MATRIX['x'][num])
                            crspt = 's' + str(num)
                            if(crspt in xps):
                                set_bits.append(SW_MATRIX['x'][num])
                        if(alp in ['_n','_s']):
                            crspts = [d+str(n) for d in ['_e','_w'] for n in [0,1]]
                            for pt in crspts:
                                if pt in xps:
                                    print(pt)
                        if(alp in ['_e','_w']):
                            crspts = [d+str(n) for d in ['_n','_s'] for n in [0,1]]
                            for pt in crspts:
                                if pt in xps:
                                    print(pt)
                        set_bits.append(SW_MATRIX[alp][num])


