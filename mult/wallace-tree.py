

mult_conn = open('mult_conn.txt', 'w')
wire_assign = open('wire_assign.txt', 'w')


class inst_info:
    def __init__(self, filled):
        self.ha_num = 0
        self.csa_num = 0

        self.total_wire = []
        self.wire_list = dict()

        for i in range(32):
            _key = str(i)
            if filled[i] != 0:
                wire = '\\' + _key + '/0 '
                self.wire_list[_key] = [wire]
                self.total_wire.append(wire)
                for n in range(1, filled[i]):
                    wire = '\\' + _key + '/' + str(n) + ' '
                    self.wire_list[_key].append(wire)
                    self.total_wire.append(wire)
            
            else:
                self.wire_list[_key] = []


        self.filled = filled

    def make_csa_line(self, left_order):

        now_wire = self.wire_list[str(left_order)]
        
        assert type(left_order) is int
        assert len(now_wire) >= 3

        instance_name = 'csa' +str(self.csa_num)
        self.csa_num += 1

        sum_wire = '\s' + str(self.csa_num) + ' '
        carry_wire = '\c' + str(self.csa_num) + ' '        
        line = 'fullad ' + instance_name + '(' + \
            now_wire[0] + ', ' + now_wire[1] + ', ' + now_wire[2] + ', ' +\
            sum_wire + ', '+ carry_wire + \
            ')'

        del now_wire[0:3]
        now_wire.append(sum_wire)
        self.wire_list[str(left_order - 1)].append(carry_wire)

        self.total_wire.append(sum_wire)
        self.total_wire.append(carry_wire)
        self.filled = [len(self.wire_list[n]) for n in self.wire_list.keys()]

        return line;

    def make_ha_line(self, left_order):

        now_wire = self.wire_list[str(left_order)]
        
        assert type(left_order) is int
        assert len(now_wire) >= 2

        instance_name = 'ha' +str(self.ha_num)
        self.ha_num += 1

        sum_wire = '\sf' + str(self.ha_num) + ' '
        carry_wire = '\cf' + str(self.ha_num) + ' '        
        line = 'halfad ' + instance_name + '(' + \
            now_wire[-2] + ', ' + now_wire[-1] + ', ' + \
            sum_wire + ', '+ carry_wire + \
            ')'

        del now_wire[-2:]
        now_wire.append(sum_wire)
        self.wire_list[str(left_order - 1)].append(carry_wire)

        self.total_wire.append(sum_wire)
        self.total_wire.append(carry_wire)
        self.filled = [len(self.wire_list[n]) for n in self.wire_list.keys()]

        return line;
       
jump_start = [n if n<16 else 32-n for n in range(32)]
wall_tree = inst_info(jump_start)




# Stage 1 ~ 3

for stage in range(3):
    filled = wall_tree.filled
    for i in range(32):
        if filled[i] // 3 > 0 and filled[i] != 0:       
            fullad_num = filled[i] // 3

            for n in range(fullad_num):           
                mult_conn.write(wall_tree.make_csa_line(i) + ';\n')

            
    print(wall_tree.filled)


# Stage 4
filled = wall_tree.filled
for i in range(32):
    if filled[i] // 3 > 0 and filled[i] != 0:       
        fullad_num = filled[i] // 3

        for n in range(fullad_num):           
            mult_conn.write(wall_tree.make_csa_line(i) + ';\n')

    # FA
    if i == 15:
        ha_num = filled[i] %3 // 2
        mult_conn.write(wall_tree.make_ha_line(i) + ';\n')

print(wall_tree.filled)

# Stage 5

filled = wall_tree.filled
for i in range(32):
    if filled[i] // 3 > 0 and filled[i] != 0:
        fullad_num = filled[i] // 3
        for n in range(fullad_num):           
            mult_conn.write(wall_tree.make_csa_line(i) + ';\n')
print(wall_tree.filled)

# Stage 6
filled = wall_tree.filled
for i in range(32):
    if filled[i] // 3 > 0 and filled[i] != 0:
        fullad_num = filled[i] // 3
        for n in range(fullad_num):           
            mult_conn.write(wall_tree.make_csa_line(i) + ';\n')

    
     # FA
    filled = wall_tree.filled
    if i>0 and filled[i-1] == 1 and filled[i] >= 2:
        ha_num = filled[i] %3 // 2
        mult_conn.write(wall_tree.make_ha_line(i) + ';\n')


# Final stage with FA(identical to csa), HA
# for i in range(1, 32)[::-1]:
#     if wall_tree.filled[i] == 1:
#         continue

#     elif wall_tree.filled[i] == 2:
#         mult_conn.write(wall_tree.make_ha_line(i) + ';\n')

#     else: # 3
#         mult_conn.write(wall_tree.make_csa_line(i) + ';\n')


# Two data wires for 32 bit adder

data1 = []
data2 = []
for idx in wall_tree.wire_list.keys():
    wires = wall_tree.wire_list[idx]
    data1.append(wires[0] if len(wires)>0 else '1\'b0')
    data2.append(wires[1] if len(wires)>1 else '1\'b0')

print(data1)
print(data2)





##################
# declare wires

wire_assign.write('wire ')

for i, wire in enumerate(wall_tree.total_wire):
    wire_assign.write(wire)

    if i != len(wall_tree.total_wire) - 1:
        wire_assign.write(', ')
    else:
        wire_assign.write(';')


    if (i + 1) % 10 == 0:
        wire_assign.write('\n    ')

wire_assign.write('\nwire [31:0] in1, in2;\n');

wire_assign.write('\n\n\n\n\n')







# assign wire = input, output

def make_wire(hor, ver):
    assert type(hor) == int
    assert type(ver) == int
    return '\\'+str(hor)+'/'+str(ver)


## input
for hor in range(1, 32):    
    _sum = 31 - hor
    if hor <= 16:        
        for ver in range(0, hor):
            target_wire = make_wire(hor, ver)
            input_vert = 16 - hor + ver
            target_input = 'p_prod[' + str(input_vert) +'][' + str(_sum - input_vert) + ']'
            
            wire_assign.write('assign ' + target_wire + ' = ' + target_input + ' ;\n')

    else:
        for ver in range(0, _sum + 1):
            target_wire = make_wire(hor, ver)
            input_vert = ver
            target_input = 'p_prod[' + str(input_vert) +'][' + str(_sum - input_vert) + ']'
            
            wire_assign.write('assign ' + target_wire + ' = ' + target_input + ' ;\n')

## output
# for n in range(32)[::-1]:
#     target_output = 'out[' + str(n) + ']'
#     target_wire = wall_tree.wire_list[str(31 - n)][0]
#     wire_assign.write('assign ' + target_output + ' = ' + target_wire + ';\n')

## output for adder
wire_assign.write('assign in1 = {')
for n in range(32):
    wire_assign.write(data1[n]) 
    if n!= 31:
        wire_assign.write(',');
wire_assign.write('};\n')

wire_assign.write('assign in2 = {')
for n in range(32):
    wire_assign.write(data2[n]);
    if n!= 31:
        wire_assign.write(',');
wire_assign.write('};\n')



mult_conn.close()
wire_assign.close()