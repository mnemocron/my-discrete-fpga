# -*- coding: utf-8 -*-
"""
Created on Fri Sep 15 15:04:57 2023

@author: simon
"""

def eval_bool_expr_to_lut(expr):
    prm = expr.lower() 
    prm = prm.replace('xor', '^')
    prm = prm.replace('a0', 'x[0]')
    prm = prm.replace('a1', 'x[1]')
    prm = prm.replace('a2', 'x[2]')
    prm = prm.replace('a3', 'x[3]')
    
    lut = []
    
    x=[0,0,0,0]
    for k in range(16):
        v = eval(prm)
        #lut[k] = v
        print(f'{x[3]}{x[2]}{x[1]}{x[0]} : {v}')
        
        if(x[2] and x[1] and x[0]):
            x[3] = int(not x[3])
        if(x[1] and x[0]):
            x[2] = int(not x[2])
        if(x[0]):
            x[1] = int(not x[1])
        x[0] = int(not x[0])
    return lut

prompt_a = 'a0 xor a1 xor a2 xor a3'
prompt_b = 'a3 or (a0 and a1)'

asdf = eval_bool_expr_to_lut(prompt_b)










