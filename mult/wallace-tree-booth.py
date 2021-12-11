from copy import deepcopy

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

        if left_order > 0:
            self.wire_list[str(left_order - 1)].append(carry_wire)

        self.total_wire.append(sum_wire)
        if left_order > 0:
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
       
jump_start = [1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, \
              7, 8, 8, 8, 8, 8, 9, 7, 8, 6,\
              7, 5, 6, 4, 5, 3, 4, 2, 3, 1, 2]
print(jump_start)
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
filled = deepcopy(wall_tree.filled)
for i in range(32):
    if filled[i] // 3 > 0 and filled[i] != 0:       
        fullad_num = filled[i] // 3
        for n in range(fullad_num):           
            mult_conn.write(wall_tree.make_csa_line(i) + ';\n')
print(wall_tree.filled)


# Stage 5
filled = deepcopy(wall_tree.filled)
for i in range(32):
    if filled[i] // 3 > 0 and filled[i] != 0:       
        fullad_num = filled[i] // 3
        for n in range(fullad_num):           
            mult_conn.write(wall_tree.make_csa_line(i) + ';\n')

    elif filled[i] >= 2:
        j = i
        yes = 1
        while filled[j] != 3:
            if filled[j] < 2 or j==31:
                yes = 0
                break
            j += 1

        if yes:
            mult_conn.write(wall_tree.make_ha_line(i) + ';\n')
   
print(wall_tree.filled)


data1 = []
data2 = []
for idx in wall_tree.wire_list.keys():
    wires = wall_tree.wire_list[idx]
    data1.append(wires[0] if len(wires)>0 else '1\'b0')
    data2.append(wires[1] if len(wires)>1 else '1\'b0')



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

only_pp = [0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,\
           8,8,8,7,7,6,6,5,5,4,4,3,3,2,2,1,1]


## input
assigned = [0 for n in range(32)]
for col in range(0, 8):
    i = 32

    for row in range(0, 17):

        while True:
            i = i-1 if i>0 else 0
            if assigned[i] < only_pp[i]:
                break           

        target_input = 'prod['+str(col)+']['+str(row)+']'        
        target_wire = '\\'+str(i)+'/'+str(assigned[i])+' '
        wire_assign.write('assign '+target_wire +' = '+target_input+';\n')
        assigned[i] += 1

        # print('assign '+target_wire +' = '+target_input+';\n')

# fill signed position

col = 7

for i in range(12):
    target_wire = '\\'+str(i)+'/'+str(assigned[i])+' '
    if i%2 == 0:
        E = '~( data2['+ str(2*col+1) +'] ^ data1[15] ) | pos_0[' + str(col) +'] & ~neg_0[' + str(col) +']'
        wire_assign.write('assign '+target_wire +' = '+E+';\n') 

        s = 'data2['+ str(2*col+1) +']'
        target_wire = '\\'+str(i+17)+'/'+str(assigned[i+17])+' '
        wire_assign.write('assign '+target_wire +' = '+s+';\n')       

        col -= 1
        assigned[i] += 1
        assigned[i+17] += 1
    else:
        one = '1\'b1'
        wire_assign.write('assign '+target_wire +' = '+one+';\n')    
        assigned[i] += 1


for i in range(12, 15):
    E = '~( data2['+ str(2*col+1) +'] ^ data1[15] ) | pos_0[' + str(col) +'] & ~neg_0[' + str(col) +']'
    E_bar = '( data2['+ str(2*col+1) +'] ^ data1[15] ) & ~pos_0[' + str(col) +'] | neg_0[' + str(col) +']'

    if i==12:
        while assigned[i] < jump_start[i]:
            target_wire = '\\'+str(i)+'/'+str(assigned[i])+' '
            wire_assign.write('assign '+ target_wire + ' = '+E +';\n')
            assigned[i] += 1        

    else:
        target_wire = '\\'+str(i)+'/'+str(assigned[i])+' '
        wire_assign.write('assign '+ target_wire + ' = '+E_bar +';\n')
        assigned[i] += 1

    if i%2 == 0:    
        s = 'data2['+ str(2*col+1) +']'
        target_wire = '\\'+str(i+17)+'/'+str(assigned[i+17])+' '
        wire_assign.write('assign '+target_wire +' = '+s+';\n')
        assigned[i+17] += 1
        col-=1

print(assigned)
print(jump_start)
print(assigned == jump_start)


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