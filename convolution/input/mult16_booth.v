`include "csa32.v"

module mult16(
    input signed [15:0] data1,
    input signed [15:0] data2,
    output signed [31:0] out
);

wire signed [16:0] prod [0:7];
wire [7:0] selectM;
wire [7:0] select2M;
wire [7:0] pos_0;
wire [7:0] neg_0;

generate
    genvar i;    
    for(i=0; i<8; i=i+1) begin : gen_booth
        if (i==0) begin
            booth_dec dec({data2[1:0], 1'b0}, selectM[i], select2M[i]);
            make_pp pp(
                .mult(data1),
                .selectM(selectM[i]),
                .select2M(select2M[i]),
                .neg(data2[1]),
                .pp(prod[i])
            );

            assign pos_0[i] = ~selectM[i] & ~select2M[i];
            assign neg_0[i] = 1'b0;
        end

        else begin
            wire tmp;
            booth_dec dec(data2[2*i+1: 2*i-1], selectM[i], select2M[i]);
            make_pp pp(
                .mult(data1),
                .selectM(selectM[i]),
                .select2M(select2M[i]),
                .neg(data2[2*i+1]),
                .pp(prod[i])
            );
            assign tmp = ~selectM[i] & ~select2M[i];
            assign pos_0[i] = tmp & ~data2[2*i+1];
            assign neg_0[i] = tmp & data2[2*i+1];
        end

        

    end    
endgenerate

wire \0/0 , \1/0 , \1/1 , \2/0 , \2/1 , \3/0 , \3/1 , \3/2 , \4/0 , \4/1 , 
    \4/2 , \5/0 , \5/1 , \5/2 , \5/3 , \6/0 , \6/1 , \6/2 , \6/3 , \7/0 , 
    \7/1 , \7/2 , \7/3 , \7/4 , \8/0 , \8/1 , \8/2 , \8/3 , \8/4 , \9/0 , 
    \9/1 , \9/2 , \9/3 , \9/4 , \9/5 , \10/0 , \10/1 , \10/2 , \10/3 , \10/4 , 
    \10/5 , \11/0 , \11/1 , \11/2 , \11/3 , \11/4 , \11/5 , \11/6 , \12/0 , \12/1 , 
    \12/2 , \12/3 , \12/4 , \12/5 , \12/6 , \12/7 , \13/0 , \13/1 , \13/2 , \13/3 , 
    \13/4 , \13/5 , \13/6 , \13/7 , \14/0 , \14/1 , \14/2 , \14/3 , \14/4 , \14/5 , 
    \14/6 , \14/7 , \15/0 , \15/1 , \15/2 , \15/3 , \15/4 , \15/5 , \15/6 , \15/7 , 
    \16/0 , \16/1 , \16/2 , \16/3 , \16/4 , \16/5 , \16/6 , \16/7 , \17/0 , \17/1 , 
    \17/2 , \17/3 , \17/4 , \17/5 , \17/6 , \17/7 , \17/8 , \18/0 , \18/1 , \18/2 , 
    \18/3 , \18/4 , \18/5 , \18/6 , \19/0 , \19/1 , \19/2 , \19/3 , \19/4 , \19/5 , 
    \19/6 , \19/7 , \20/0 , \20/1 , \20/2 , \20/3 , \20/4 , \20/5 , \21/0 , \21/1 , 
    \21/2 , \21/3 , \21/4 , \21/5 , \21/6 , \22/0 , \22/1 , \22/2 , \22/3 , \22/4 , 
    \23/0 , \23/1 , \23/2 , \23/3 , \23/4 , \23/5 , \24/0 , \24/1 , \24/2 , \24/3 , 
    \25/0 , \25/1 , \25/2 , \25/3 , \25/4 , \26/0 , \26/1 , \26/2 , \27/0 , \27/1 , 
    \27/2 , \27/3 , \28/0 , \28/1 , \29/0 , \29/1 , \29/2 , \30/0 , \31/0 , \31/1 , 
    \s1 , \c1 , \s2 , \c2 , \s3 , \c3 , \s4 , \c4 , \s5 , \c5 , 
    \s6 , \c6 , \s7 , \c7 , \s8 , \c8 , \s9 , \c9 , \s10 , \c10 , 
    \s11 , \c11 , \s12 , \c12 , \s13 , \c13 , \s14 , \c14 , \s15 , \c15 , 
    \s16 , \c16 , \s17 , \c17 , \s18 , \c18 , \s19 , \c19 , \s20 , \c20 , 
    \s21 , \c21 , \s22 , \c22 , \s23 , \c23 , \s24 , \c24 , \s25 , \c25 , 
    \s26 , \c26 , \s27 , \c27 , \s28 , \c28 , \s29 , \c29 , \s30 , \c30 , 
    \s31 , \c31 , \s32 , \c32 , \s33 , \c33 , \s34 , \c34 , \s35 , \c35 , 
    \s36 , \c36 , \s37 , \c37 , \s38 , \c38 , \s39 , \c39 , \s40 , \c40 , 
    \s41 , \c41 , \s42 , \c42 , \s43 , \c43 , \s44 , \c44 , \s45 , \c45 , 
    \s46 , \c46 , \s47 , \c47 , \s48 , \c48 , \s49 , \c49 , \s50 , \c50 , 
    \s51 , \c51 , \s52 , \c52 , \s53 , \c53 , \s54 , \c54 , \s55 , \c55 , 
    \s56 , \c56 , \s57 , \c57 , \s58 , \c58 , \s59 , \c59 , \s60 , \c60 , 
    \s61 , \c61 , \s62 , \c62 , \s63 , \c63 , \s64 , \c64 , \s65 , \c65 , 
    \s66 , \c66 , \s67 , \c67 , \s68 , \c68 , \s69 , \c69 , \s70 , \c70 , 
    \s71 , \c71 , \s72 , \c72 , \s73 , \c73 , \s74 , \c74 , \s75 , \c75 , 
    \s76 , \c76 , \s77 , \c77 , \s78 , \c78 , \s79 , \c79 , \s80 , \c80 , 
    \s81 , \c81 , \s82 , \c82 , \s83 , \c83 , \s84 , \c84 , \s85 , \c85 , 
    \s86 , \c86 , \s87 , \c87 , \s88 , \c88 , \s89 , \c89 , \s90 , \c90 , 
    \s91 , \c91 , \s92 , \c92 , \s93 , \c93 , \s94 , \c94 , \s95 , \c95 , 
    \s96 , \c96 , \s97 , \c97 , \s98 , \c98 , \s99 , \c99 , \s100 , \c100 , 
    \s101 , \c101 , \s102 , \c102 , \s103 , \c103 , \sf1 , \cf1 , \s104 , \c104 , 
    \s105 , \c105 , \sf2 , \cf2 , \sf3 , \cf3 , \sf4 , \cf4 , \sf5 , \cf5 , 
    \sf6 , \cf6 , \sf7 , \cf7 , \sf8 , \cf8 , \sf9 , \cf9 , \sf10 , \cf10 , 
    \sf11 , \cf11 , \sf12 , \cf12 , \sf13 , \cf13 , \sf14 , \cf14 , \s106 , \c106 ;
    
wire [31:0] in1, in2;





assign \31/0  = prod[0][0];
assign \30/0  = prod[0][1];
assign \29/0  = prod[0][2];
assign \28/0  = prod[0][3];
assign \27/0  = prod[0][4];
assign \26/0  = prod[0][5];
assign \25/0  = prod[0][6];
assign \24/0  = prod[0][7];
assign \23/0  = prod[0][8];
assign \22/0  = prod[0][9];
assign \21/0  = prod[0][10];
assign \20/0  = prod[0][11];
assign \19/0  = prod[0][12];
assign \18/0  = prod[0][13];
assign \17/0  = prod[0][14];
assign \16/0  = prod[0][15];
assign \15/0  = prod[0][16];
assign \29/1  = prod[1][0];
assign \28/1  = prod[1][1];
assign \27/1  = prod[1][2];
assign \26/1  = prod[1][3];
assign \25/1  = prod[1][4];
assign \24/1  = prod[1][5];
assign \23/1  = prod[1][6];
assign \22/1  = prod[1][7];
assign \21/1  = prod[1][8];
assign \20/1  = prod[1][9];
assign \19/1  = prod[1][10];
assign \18/1  = prod[1][11];
assign \17/1  = prod[1][12];
assign \16/1  = prod[1][13];
assign \15/1  = prod[1][14];
assign \14/0  = prod[1][15];
assign \13/0  = prod[1][16];
assign \27/2  = prod[2][0];
assign \26/2  = prod[2][1];
assign \25/2  = prod[2][2];
assign \24/2  = prod[2][3];
assign \23/2  = prod[2][4];
assign \22/2  = prod[2][5];
assign \21/2  = prod[2][6];
assign \20/2  = prod[2][7];
assign \19/2  = prod[2][8];
assign \18/2  = prod[2][9];
assign \17/2  = prod[2][10];
assign \16/2  = prod[2][11];
assign \15/2  = prod[2][12];
assign \14/1  = prod[2][13];
assign \13/1  = prod[2][14];
assign \12/0  = prod[2][15];
assign \11/0  = prod[2][16];
assign \25/3  = prod[3][0];
assign \24/3  = prod[3][1];
assign \23/3  = prod[3][2];
assign \22/3  = prod[3][3];
assign \21/3  = prod[3][4];
assign \20/3  = prod[3][5];
assign \19/3  = prod[3][6];
assign \18/3  = prod[3][7];
assign \17/3  = prod[3][8];
assign \16/3  = prod[3][9];
assign \15/3  = prod[3][10];
assign \14/2  = prod[3][11];
assign \13/2  = prod[3][12];
assign \12/1  = prod[3][13];
assign \11/1  = prod[3][14];
assign \10/0  = prod[3][15];
assign \9/0  = prod[3][16];
assign \23/4  = prod[4][0];
assign \22/4  = prod[4][1];
assign \21/4  = prod[4][2];
assign \20/4  = prod[4][3];
assign \19/4  = prod[4][4];
assign \18/4  = prod[4][5];
assign \17/4  = prod[4][6];
assign \16/4  = prod[4][7];
assign \15/4  = prod[4][8];
assign \14/3  = prod[4][9];
assign \13/3  = prod[4][10];
assign \12/2  = prod[4][11];
assign \11/2  = prod[4][12];
assign \10/1  = prod[4][13];
assign \9/1  = prod[4][14];
assign \8/0  = prod[4][15];
assign \7/0  = prod[4][16];
assign \21/5  = prod[5][0];
assign \20/5  = prod[5][1];
assign \19/5  = prod[5][2];
assign \18/5  = prod[5][3];
assign \17/5  = prod[5][4];
assign \16/5  = prod[5][5];
assign \15/5  = prod[5][6];
assign \14/4  = prod[5][7];
assign \13/4  = prod[5][8];
assign \12/3  = prod[5][9];
assign \11/3  = prod[5][10];
assign \10/2  = prod[5][11];
assign \9/2  = prod[5][12];
assign \8/1  = prod[5][13];
assign \7/1  = prod[5][14];
assign \6/0  = prod[5][15];
assign \5/0  = prod[5][16];
assign \19/6  = prod[6][0];
assign \18/6  = prod[6][1];
assign \17/6  = prod[6][2];
assign \16/6  = prod[6][3];
assign \15/6  = prod[6][4];
assign \14/5  = prod[6][5];
assign \13/5  = prod[6][6];
assign \12/4  = prod[6][7];
assign \11/4  = prod[6][8];
assign \10/3  = prod[6][9];
assign \9/3  = prod[6][10];
assign \8/2  = prod[6][11];
assign \7/2  = prod[6][12];
assign \6/1  = prod[6][13];
assign \5/1  = prod[6][14];
assign \4/0  = prod[6][15];
assign \3/0  = prod[6][16];
assign \17/7  = prod[7][0];
assign \16/7  = prod[7][1];
assign \15/7  = prod[7][2];
assign \14/6  = prod[7][3];
assign \13/6  = prod[7][4];
assign \12/5  = prod[7][5];
assign \11/5  = prod[7][6];
assign \10/4  = prod[7][7];
assign \9/4  = prod[7][8];
assign \8/3  = prod[7][9];
assign \7/3  = prod[7][10];
assign \6/2  = prod[7][11];
assign \5/2  = prod[7][12];
assign \4/1  = prod[7][13];
assign \3/1  = prod[7][14];
assign \2/0  = prod[7][15];
assign \1/0  = prod[7][16];
assign \0/0  = ~( data2[15] ^ data1[15] ) | pos_0[7] & ~neg_0[7];
assign \17/8  = data2[15];
assign \1/1  = 1'b1;
assign \2/1  = ~( data2[13] ^ data1[15] ) | pos_0[6] & ~neg_0[6];
assign \19/7  = data2[13];
assign \3/2  = 1'b1;
assign \4/2  = ~( data2[11] ^ data1[15] ) | pos_0[5] & ~neg_0[5];
assign \21/6  = data2[11];
assign \5/3  = 1'b1;
assign \6/3  = ~( data2[9] ^ data1[15] ) | pos_0[4] & ~neg_0[4];
assign \23/5  = data2[9];
assign \7/4  = 1'b1;
assign \8/4  = ~( data2[7] ^ data1[15] ) | pos_0[3] & ~neg_0[3];
assign \25/4  = data2[7];
assign \9/5  = 1'b1;
assign \10/5  = ~( data2[5] ^ data1[15] ) | pos_0[2] & ~neg_0[2];
assign \27/3  = data2[5];
assign \11/6  = 1'b1;
assign \12/6  = ~( data2[3] ^ data1[15] ) | pos_0[1] & ~neg_0[1];
assign \12/7  = ~( data2[1] ^ data1[15] ) | pos_0[0] & ~neg_0[0];
assign \29/2  = data2[3];
assign \13/7  = ~\12/7 ;
assign \14/7  = ~\12/7 ;
assign \31/1  = data2[1];
assign in1 = {\0/0 ,\s71 ,\s42 ,\s90 ,\s72 ,\s102 ,\s91 ,\s103 ,\s92 ,\sf1 ,\s104 ,\s105 ,\sf2 ,\sf3 ,\sf4 ,\sf5 ,\sf6 ,\sf7 ,\sf8 ,\sf9 ,\sf10 ,\sf11 ,\sf12 ,\sf13 ,\sf14 ,\s106 ,\s101 ,\s89 ,\s70 ,\s41 ,\30/0 ,\31/0 };
assign in2 = {\c71 ,1'b0,\c90 ,1'b0,\c102 ,1'b0,\c103 ,1'b0,\cf1 ,\c104 ,\c105 ,\cf2 ,\cf3 ,\cf4 ,\cf5 ,\cf6 ,\cf7 ,\cf8 ,\cf9 ,\cf10 ,\cf11 ,\cf12 ,\cf13 ,\cf14 ,\c106 ,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,\31/1 };

fullad csa0(\3/0 , \3/1 , \3/2 , \s1 , \c1 );
fullad csa1(\4/0 , \4/1 , \4/2 , \s2 , \c2 );
fullad csa2(\5/0 , \5/1 , \5/2 , \s3 , \c3 );
fullad csa3(\6/0 , \6/1 , \6/2 , \s4 , \c4 );
fullad csa4(\7/0 , \7/1 , \7/2 , \s5 , \c5 );
fullad csa5(\8/0 , \8/1 , \8/2 , \s6 , \c6 );
fullad csa6(\9/0 , \9/1 , \9/2 , \s7 , \c7 );
fullad csa7(\9/3 , \9/4 , \9/5 , \s8 , \c8 );
fullad csa8(\10/0 , \10/1 , \10/2 , \s9 , \c9 );
fullad csa9(\10/3 , \10/4 , \10/5 , \s10 , \c10 );
fullad csa10(\11/0 , \11/1 , \11/2 , \s11 , \c11 );
fullad csa11(\11/3 , \11/4 , \11/5 , \s12 , \c12 );
fullad csa12(\12/0 , \12/1 , \12/2 , \s13 , \c13 );
fullad csa13(\12/3 , \12/4 , \12/5 , \s14 , \c14 );
fullad csa14(\13/0 , \13/1 , \13/2 , \s15 , \c15 );
fullad csa15(\13/3 , \13/4 , \13/5 , \s16 , \c16 );
fullad csa16(\14/0 , \14/1 , \14/2 , \s17 , \c17 );
fullad csa17(\14/3 , \14/4 , \14/5 , \s18 , \c18 );
fullad csa18(\15/0 , \15/1 , \15/2 , \s19 , \c19 );
fullad csa19(\15/3 , \15/4 , \15/5 , \s20 , \c20 );
fullad csa20(\16/0 , \16/1 , \16/2 , \s21 , \c21 );
fullad csa21(\16/3 , \16/4 , \16/5 , \s22 , \c22 );
fullad csa22(\17/0 , \17/1 , \17/2 , \s23 , \c23 );
fullad csa23(\17/3 , \17/4 , \17/5 , \s24 , \c24 );
fullad csa24(\17/6 , \17/7 , \17/8 , \s25 , \c25 );
fullad csa25(\18/0 , \18/1 , \18/2 , \s26 , \c26 );
fullad csa26(\18/3 , \18/4 , \18/5 , \s27 , \c27 );
fullad csa27(\19/0 , \19/1 , \19/2 , \s28 , \c28 );
fullad csa28(\19/3 , \19/4 , \19/5 , \s29 , \c29 );
fullad csa29(\20/0 , \20/1 , \20/2 , \s30 , \c30 );
fullad csa30(\20/3 , \20/4 , \20/5 , \s31 , \c31 );
fullad csa31(\21/0 , \21/1 , \21/2 , \s32 , \c32 );
fullad csa32(\21/3 , \21/4 , \21/5 , \s33 , \c33 );
fullad csa33(\22/0 , \22/1 , \22/2 , \s34 , \c34 );
fullad csa34(\23/0 , \23/1 , \23/2 , \s35 , \c35 );
fullad csa35(\23/3 , \23/4 , \23/5 , \s36 , \c36 );
fullad csa36(\24/0 , \24/1 , \24/2 , \s37 , \c37 );
fullad csa37(\25/0 , \25/1 , \25/2 , \s38 , \c38 );
fullad csa38(\26/0 , \26/1 , \26/2 , \s39 , \c39 );
fullad csa39(\27/0 , \27/1 , \27/2 , \s40 , \c40 );
fullad csa40(\29/0 , \29/1 , \29/2 , \s41 , \c41 );
fullad csa41(\2/0 , \2/1 , \c1 , \s42 , \c42 );
fullad csa42(\5/3 , \s3 , \c4 , \s43 , \c43 );
fullad csa43(\6/3 , \s4 , \c5 , \s44 , \c44 );
fullad csa44(\7/3 , \7/4 , \s5 , \s45 , \c45 );
fullad csa45(\8/3 , \8/4 , \s6 , \s46 , \c46 );
fullad csa46(\s7 , \s8 , \c9 , \s47 , \c47 );
fullad csa47(\s9 , \s10 , \c11 , \s48 , \c48 );
fullad csa48(\11/6 , \s11 , \s12 , \s49 , \c49 );
fullad csa49(\12/6 , \12/7 , \s13 , \s50 , \c50 );
fullad csa50(\s14 , \c15 , \c16 , \s51 , \c51 );
fullad csa51(\13/6 , \13/7 , \s15 , \s52 , \c52 );
fullad csa52(\s16 , \c17 , \c18 , \s53 , \c53 );
fullad csa53(\14/6 , \14/7 , \s17 , \s54 , \c54 );
fullad csa54(\s18 , \c19 , \c20 , \s55 , \c55 );
fullad csa55(\15/6 , \15/7 , \s19 , \s56 , \c56 );
fullad csa56(\s20 , \c21 , \c22 , \s57 , \c57 );
fullad csa57(\16/6 , \16/7 , \s21 , \s58 , \c58 );
fullad csa58(\s22 , \c23 , \c24 , \s59 , \c59 );
fullad csa59(\s23 , \s24 , \s25 , \s60 , \c60 );
fullad csa60(\18/6 , \s26 , \s27 , \s61 , \c61 );
fullad csa61(\19/6 , \19/7 , \s28 , \s62 , \c62 );
fullad csa62(\s29 , \c30 , \c31 , \s63 , \c63 );
fullad csa63(\s30 , \s31 , \c32 , \s64 , \c64 );
fullad csa64(\21/6 , \s32 , \s33 , \s65 , \c65 );
fullad csa65(\22/3 , \22/4 , \s34 , \s66 , \c66 );
fullad csa66(\s35 , \s36 , \c37 , \s67 , \c67 );
fullad csa67(\24/3 , \s37 , \c38 , \s68 , \c68 );
fullad csa68(\25/3 , \25/4 , \s38 , \s69 , \c69 );
fullad csa69(\28/0 , \28/1 , \c41 , \s70 , \c70 );
fullad csa70(\1/0 , \1/1 , \c42 , \s71 , \c71 );
fullad csa71(\s2 , \c3 , \c43 , \s72 , \c72 );
fullad csa72(\c6 , \s45 , \c46 , \s73 , \c73 );
fullad csa73(\c7 , \c8 , \s46 , \s74 , \c74 );
fullad csa74(\c10 , \s47 , \c48 , \s75 , \c75 );
fullad csa75(\c12 , \s48 , \c49 , \s76 , \c76 );
fullad csa76(\c13 , \c14 , \s49 , \s77 , \c77 );
fullad csa77(\s50 , \s51 , \c52 , \s78 , \c78 );
fullad csa78(\s52 , \s53 , \c54 , \s79 , \c79 );
fullad csa79(\s54 , \s55 , \c56 , \s80 , \c80 );
fullad csa80(\s56 , \s57 , \c58 , \s81 , \c81 );
fullad csa81(\c25 , \s58 , \s59 , \s82 , \c82 );
fullad csa82(\c26 , \c27 , \s60 , \s83 , \c83 );
fullad csa83(\c28 , \c29 , \s61 , \s84 , \c84 );
fullad csa84(\s62 , \s63 , \c64 , \s85 , \c85 );
fullad csa85(\c33 , \s64 , \c65 , \s86 , \c86 );
fullad csa86(\c34 , \s65 , \c66 , \s87 , \c87 );
fullad csa87(\c35 , \c36 , \s66 , \s88 , \c88 );
fullad csa88(\27/3 , \s40 , \c70 , \s89 , \c89 );
fullad csa89(\s1 , \c2 , \c72 , \s90 , \c90 );
fullad csa90(\s44 , \c45 , \c73 , \s91 , \c91 );
fullad csa91(\c47 , \s74 , \c75 , \s92 , \c92 );
fullad csa92(\c50 , \c51 , \s77 , \s93 , \c93 );
fullad csa93(\c53 , \s78 , \c79 , \s94 , \c94 );
fullad csa94(\c55 , \s79 , \c80 , \s95 , \c95 );
fullad csa95(\c57 , \s80 , \c81 , \s96 , \c96 );
fullad csa96(\c59 , \s81 , \c82 , \s97 , \c97 );
fullad csa97(\c60 , \s82 , \c83 , \s98 , \c98 );
fullad csa98(\c61 , \s83 , \c84 , \s99 , \c99 );
fullad csa99(\c62 , \c63 , \s84 , \s100 , \c100 );
fullad csa100(\s39 , \c40 , \c89 , \s101 , \c101 );
fullad csa101(\s43 , \c44 , \c91 , \s102 , \c102 );
fullad csa102(\s73 , \c74 , \c92 , \s103 , \c103 );
halfad ha0(\s75 , \c76 , \sf1 , \cf1 );
fullad csa103(\s76 , \c77 , \c93 , \s104 , \c104 );
fullad csa104(\c78 , \s93 , \c94 , \s105 , \c105 );
halfad ha1(\s94 , \c95 , \sf2 , \cf2 );
halfad ha2(\s95 , \c96 , \sf3 , \cf3 );
halfad ha3(\s96 , \c97 , \sf4 , \cf4 );
halfad ha4(\s97 , \c98 , \sf5 , \cf5 );
halfad ha5(\s98 , \c99 , \sf6 , \cf6 );
halfad ha6(\s99 , \c100 , \sf7 , \cf7 );
halfad ha7(\c85 , \s100 , \sf8 , \cf8 );
halfad ha8(\s85 , \c86 , \sf9 , \cf9 );
halfad ha9(\s86 , \c87 , \sf10 , \cf10 );
halfad ha10(\s87 , \c88 , \sf11 , \cf11 );
halfad ha11(\c67 , \s88 , \sf12 , \cf12 );
halfad ha12(\s67 , \c68 , \sf13 , \cf13 );
halfad ha13(\s68 , \c69 , \sf14 , \cf14 );
fullad csa105(\c39 , \s69 , \c101 , \s106 , \c106 );

csa32 finaladd(in1, in2, out, ov);

endmodule



module booth_dec(
    input [2:0] booth_in,
    output selectM,
    output select2M );

wire tmp;
assign selectM = booth_in[0] ^ booth_in[1];
assign tmp = ~(booth_in[1] ^ booth_in[2]);
assign select2M = ~(selectM | tmp);

endmodule

module make_pp(
    input [15:0] mult,
    input selectM,
    input select2M,
    input neg,
    output [16:0] pp);


wire [16:0] padded;
wire [16:0] shifted;

assign padded = {mult[15], mult};
assign shifted = {mult, 1'b0};

generate
    genvar i;
    for (i=0; i<17; i=i+1) begin : pp_andor
        assign andm = padded[i] & selectM;
        assign and2m = shifted[i] & select2M;
        assign pos = ~(andm | and2m);
        assign pp[i] = ~pos ^ neg;
    end
endgenerate

endmodule
