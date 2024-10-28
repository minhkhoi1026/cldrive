//{"E":7,"EE":16,"EEE":27,"EEEE":47,"EEEO":48,"EEO":28,"EO":17,"O":9,"block":1,"c":5,"coeff":0,"dst":10,"g_aiT16":30,"g_aiT16[0]":29,"g_aiT16[10]":45,"g_aiT16[11]":40,"g_aiT16[12]":33,"g_aiT16[13]":41,"g_aiT16[14]":46,"g_aiT16[15]":42,"g_aiT16[1]":35,"g_aiT16[2]":43,"g_aiT16[3]":36,"g_aiT16[4]":32,"g_aiT16[5]":37,"g_aiT16[6]":44,"g_aiT16[7]":38,"g_aiT16[8]":31,"g_aiT16[9]":39,"g_aiT16[k]":34,"g_aiT32":50,"g_aiT32[0]":49,"g_aiT32[10]":73,"g_aiT32[11]":60,"g_aiT32[12]":80,"g_aiT32[13]":61,"g_aiT32[14]":74,"g_aiT32[15]":62,"g_aiT32[16]":51,"g_aiT32[17]":63,"g_aiT32[18]":75,"g_aiT32[19]":64,"g_aiT32[1]":55,"g_aiT32[20]":81,"g_aiT32[21]":65,"g_aiT32[22]":76,"g_aiT32[23]":66,"g_aiT32[24]":53,"g_aiT32[25]":67,"g_aiT32[26]":77,"g_aiT32[27]":68,"g_aiT32[28]":82,"g_aiT32[29]":69,"g_aiT32[2]":71,"g_aiT32[30]":78,"g_aiT32[31]":70,"g_aiT32[3]":56,"g_aiT32[4]":79,"g_aiT32[5]":57,"g_aiT32[6]":72,"g_aiT32[7]":58,"g_aiT32[8]":52,"g_aiT32[9]":59,"g_aiT32[k]":54,"g_aiT4":12,"g_aiT4[0]":11,"g_aiT4[1]":14,"g_aiT4[2]":13,"g_aiT4[3]":15,"g_aiT8":19,"g_aiT8[0]":18,"g_aiT8[1]":23,"g_aiT8[2]":21,"g_aiT8[3]":24,"g_aiT8[4]":20,"g_aiT8[5]":25,"g_aiT8[6]":22,"g_aiT8[7]":26,"iHeight":3,"iWidth":2,"src":8,"tmp":6,"uiMode":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant char g_aucConvertToBit[(1 << (7)) + 1] = {-1, -1, -1, -1, 0, -1, -1, -1, 1, -1, -1, -1, -1, -1, -1, -1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 5};
constant int g_uiBitIncrement = 0;

constant short g_aiT4[4][4] = {{64, 64, 64, 64}, {83, 36, -36, -83}, {64, -64, -64, 64}, {36, -83, 83, -36}};

constant short g_aiT8[8][8] = {{64, 64, 64, 64, 64, 64, 64, 64}, {89, 75, 50, 18, -18, -50, -75, -89}, {83, 36, -36, -83, -83, -36, 36, 83}, {75, -18, -89, -50, 50, 89, 18, -75}, {64, -64, -64, 64, 64, -64, -64, 64}, {50, -89, 18, 75, -75, -18, 89, -50}, {36, -83, 83, -36, -36, 83, -83, 36}, {18, -50, 75, -89, 89, -75, 50, -18}};

constant short g_aiT16[16][16] = {{64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64}, {90, 87, 80, 70, 57, 43, 25, 9, -9, -25, -43, -57, -70, -80, -87, -90}, {89, 75, 50, 18, -18, -50, -75, -89, -89, -75, -50, -18, 18, 50, 75, 89}, {87, 57, 9, -43, -80, -90, -70, -25, 25, 70, 90, 80, 43, -9, -57, -87}, {83, 36, -36, -83, -83, -36, 36, 83, 83, 36, -36, -83, -83, -36, 36, 83}, {80, 9, -70, -87, -25, 57, 90, 43, -43, -90, -57, 25, 87, 70, -9, -80}, {75, -18, -89, -50, 50, 89, 18, -75, -75, 18, 89, 50, -50, -89, -18, 75}, {70, -43, -87, 9, 90, 25, -80, -57, 57, 80, -25, -90, -9, 87, 43, -70}, {64, -64, -64, 64, 64, -64, -64, 64, 64, -64, -64, 64, 64, -64, -64, 64}, {57, -80, -25, 90, -9, -87, 43, 70, -70, -43, 87, 9, -90, 25, 80, -57}, {50, -89, 18, 75, -75, -18, 89, -50, -50, 89, -18, -75, 75, 18, -89, 50}, {43, -90, 57, 25, -87, 70, 9, -80, 80, -9, -70, 87, -25, -57, 90, -43}, {36, -83, 83, -36, -36, 83, -83, 36, 36, -83, 83, -36, -36, 83, -83, 36}, {25, -70, 90, -80, 43, 9, -57, 87, -87, 57, -9, -43, 80, -90, 70, -25}, {18, -50, 75, -89, 89, -75, 50, -18, -18, 50, -75, 89, -89, 75, -50, 18}, {9, -25, 43, -57, 70, -80, 87, -90, 90, -87, 80, -70, 57, -43, 25, -9}};

constant short g_aiT32[32][32] = {{64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64}, {90, 90, 88, 85, 82, 78, 73, 67, 61, 54, 46, 38, 31, 22, 13, 4, -4, -13, -22, -31, -38, -46, -54, -61, -67, -73, -78, -82, -85, -88, -90, -90}, {90, 87, 80, 70, 57, 43, 25, 9, -9, -25, -43, -57, -70, -80, -87, -90, -90, -87, -80, -70, -57, -43, -25, -9, 9, 25, 43, 57, 70, 80, 87, 90}, {90, 82, 67, 46, 22, -4, -31, -54, -73, -85, -90, -88, -78, -61, -38, -13, 13, 38, 61, 78, 88, 90, 85, 73, 54, 31, 4, -22, -46, -67, -82, -90}, {89, 75, 50, 18, -18, -50, -75, -89, -89, -75, -50, -18, 18, 50, 75, 89, 89, 75, 50, 18, -18, -50, -75, -89, -89, -75, -50, -18, 18, 50, 75, 89}, {88, 67, 31, -13, -54, -82, -90, -78, -46, -4, 38, 73, 90, 85, 61, 22, -22, -61, -85, -90, -73, -38, 4, 46, 78, 90, 82, 54, 13, -31, -67, -88}, {87, 57, 9, -43, -80, -90, -70, -25, 25, 70, 90, 80, 43, -9, -57, -87, -87, -57, -9, 43, 80, 90, 70, 25, -25, -70, -90, -80, -43, 9, 57, 87}, {85, 46, -13, -67, -90, -73, -22, 38, 82, 88, 54, -4, -61, -90, -78, -31, 31, 78, 90, 61, 4, -54, -88, -82, -38, 22, 73, 90, 67, 13, -46, -85}, {83, 36, -36, -83, -83, -36, 36, 83, 83, 36, -36, -83, -83, -36, 36, 83, 83, 36, -36, -83, -83, -36, 36, 83, 83, 36, -36, -83, -83, -36, 36, 83}, {82, 22, -54, -90, -61, 13, 78, 85, 31, -46, -90, -67, 4, 73, 88, 38, -38, -88, -73, -4, 67, 90, 46, -31, -85, -78, -13, 61, 90, 54, -22, -82}, {80, 9, -70, -87, -25, 57, 90, 43, -43, -90, -57, 25, 87, 70, -9, -80, -80, -9, 70, 87, 25, -57, -90, -43, 43, 90, 57, -25, -87, -70, 9, 80}, {78, -4, -82, -73, 13, 85, 67, -22, -88, -61, 31, 90, 54, -38, -90, -46, 46, 90, 38, -54, -90, -31, 61, 88, 22, -67, -85, -13, 73, 82, 4, -78}, {75, -18, -89, -50, 50, 89, 18, -75, -75, 18, 89, 50, -50, -89, -18, 75, 75, -18, -89, -50, 50, 89, 18, -75, -75, 18, 89, 50, -50, -89, -18, 75}, {73, -31, -90, -22, 78, 67, -38, -90, -13, 82, 61, -46, -88, -4, 85, 54, -54, -85, 4, 88, 46, -61, -82, 13, 90, 38, -67, -78, 22, 90, 31, -73}, {70, -43, -87, 9, 90, 25, -80, -57, 57, 80, -25, -90, -9, 87, 43, -70, -70, 43, 87, -9, -90, -25, 80, 57, -57, -80, 25, 90, 9, -87, -43, 70}, {67, -54, -78, 38, 85, -22, -90, 4, 90, 13, -88, -31, 82, 46, -73, -61, 61, 73, -46, -82, 31, 88, -13, -90, -4, 90, 22, -85, -38, 78, 54, -67}, {64, -64, -64, 64, 64, -64, -64, 64, 64, -64, -64, 64, 64, -64, -64, 64, 64, -64, -64, 64, 64, -64, -64, 64, 64, -64, -64, 64, 64, -64, -64, 64}, {61, -73, -46, 82, 31, -88, -13, 90, -4, -90, 22, 85, -38, -78, 54, 67, -67, -54, 78, 38, -85, -22, 90, 4, -90, 13, 88, -31, -82, 46, 73, -61}, {57, -80, -25, 90, -9, -87, 43, 70, -70, -43, 87, 9, -90, 25, 80, -57, -57, 80, 25, -90, 9, 87, -43, -70, 70, 43, -87, -9, 90, -25, -80, 57}, {54, -85, -4, 88, -46, -61, 82, 13, -90, 38, 67, -78, -22, 90, -31, -73, 73, 31, -90, 22, 78, -67, -38, 90, -13, -82, 61, 46, -88, 4, 85, -54}, {50, -89, 18, 75, -75, -18, 89, -50, -50, 89, -18, -75, 75, 18, -89, 50, 50, -89, 18, 75, -75, -18, 89, -50, -50, 89, -18, -75, 75, 18, -89, 50}, {46, -90, 38, 54, -90, 31, 61, -88, 22, 67, -85, 13, 73, -82, 4, 78, -78, -4, 82, -73, -13, 85, -67, -22, 88, -61, -31, 90, -54, -38, 90, -46}, {43, -90, 57, 25, -87, 70, 9, -80, 80, -9, -70, 87, -25, -57, 90, -43, -43, 90, -57, -25, 87, -70, -9, 80, -80, 9, 70, -87, 25, 57, -90, 43}, {38, -88, 73, -4, -67, 90, -46, -31, 85, -78, 13, 61, -90, 54, 22, -82, 82, -22, -54, 90, -61, -13, 78, -85, 31, 46, -90, 67, 4, -73, 88, -38}, {36, -83, 83, -36, -36, 83, -83, 36, 36, -83, 83, -36, -36, 83, -83, 36, 36, -83, 83, -36, -36, 83, -83, 36, 36, -83, 83, -36, -36, 83, -83, 36}, {31, -78, 90, -61, 4, 54, -88, 82, -38, -22, 73, -90, 67, -13, -46, 85, -85, 46, 13, -67, 90, -73, 22, 38, -82, 88, -54, -4, 61, -90, 78, -31}, {25, -70, 90, -80, 43, 9, -57, 87, -87, 57, -9, -43, 80, -90, 70, -25, -25, 70, -90, 80, -43, -9, 57, -87, 87, -57, 9, 43, -80, 90, -70, 25}, {22, -61, 85, -90, 73, -38, -4, 46, -78, 90, -82, 54, -13, -31, 67, -88, 88, -67, 31, 13, -54, 82, -90, 78, -46, 4, 38, -73, 90, -85, 61, -22}, {18, -50, 75, -89, 89, -75, 50, -18, -18, 50, -75, 89, -89, 75, -50, 18, 18, -50, 75, -89, 89, -75, 50, -18, -18, 50, -75, 89, -89, 75, -50, 18}, {13, -38, 61, -78, 88, -90, 85, -73, 54, -31, 4, 22, -46, 67, -82, 90, -90, 82, -67, 46, -22, -4, 31, -54, 73, -85, 90, -88, 78, -61, 38, -13}, {9, -25, 43, -57, 70, -80, 87, -90, 90, -87, 80, -70, 57, -43, 25, -9, -9, 25, -43, 57, -70, 80, -87, 90, -90, 87, -80, 70, -57, 43, -25, 9}, {4, -13, 22, -31, 38, -46, 54, -61, 67, -73, 78, -82, 85, -88, 90, -90, 90, -90, 88, -85, 82, -78, 73, -67, 61, -54, 46, -38, 31, -22, 13, -4}};

void fastForwardDst_gl(global short* block, local short* coeff, int shift) {
  int i, c[4];
  int rnd_factor = 1 << (shift - 1);

  for (i = 0; i < 4; i++) {
    c[hook(5, 0)] = block[hook(1, 4 * i + 0)] + block[hook(1, 4 * i + 3)];
    c[hook(5, 1)] = block[hook(1, 4 * i + 1)] + block[hook(1, 4 * i + 3)];
    c[hook(5, 2)] = block[hook(1, 4 * i + 0)] - block[hook(1, 4 * i + 1)];
    c[hook(5, 3)] = 74 * block[hook(1, 4 * i + 2)];

    coeff[hook(0, i)] = (29 * c[hook(5, 0)] + 55 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift;
    coeff[hook(0, 4 + i)] = (74 * (block[hook(1, 4 * i + 0)] + block[hook(1, 4 * i + 1)] - block[hook(1, 4 * i + 3)]) + rnd_factor) >> shift;
    coeff[hook(0, 8 + i)] = (29 * c[hook(5, 2)] + 55 * c[hook(5, 0)] - c[hook(5, 3)] + rnd_factor) >> shift;
    coeff[hook(0, 12 + i)] = (55 * c[hook(5, 2)] - 29 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift;
  }
}
void fastForwardDst_lg(local short* block, global short* coeff, int shift) {
  int i, c[4];
  int rnd_factor = 1 << (shift - 1);

  for (i = 0; i < 4; i++) {
    c[hook(5, 0)] = block[hook(1, 4 * i + 0)] + block[hook(1, 4 * i + 3)];
    c[hook(5, 1)] = block[hook(1, 4 * i + 1)] + block[hook(1, 4 * i + 3)];
    c[hook(5, 2)] = block[hook(1, 4 * i + 0)] - block[hook(1, 4 * i + 1)];
    c[hook(5, 3)] = 74 * block[hook(1, 4 * i + 2)];

    coeff[hook(0, i)] = (29 * c[hook(5, 0)] + 55 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift;
    coeff[hook(0, 4 + i)] = (74 * (block[hook(1, 4 * i + 0)] + block[hook(1, 4 * i + 1)] - block[hook(1, 4 * i + 3)]) + rnd_factor) >> shift;
    coeff[hook(0, 8 + i)] = (29 * c[hook(5, 2)] + 55 * c[hook(5, 0)] - c[hook(5, 3)] + rnd_factor) >> shift;
    coeff[hook(0, 12 + i)] = (55 * c[hook(5, 2)] - 29 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift;
  }
}

void fastInverseDst_gl(global short* tmp, local short* block, int shift) {
  int i, c[4];
  int rnd_factor = 1 << (shift - 1);

  for (i = 0; i < 4; i++) {
    c[hook(5, 0)] = tmp[hook(6, i)] + tmp[hook(6, 8 + i)];
    c[hook(5, 1)] = tmp[hook(6, 8 + i)] + tmp[hook(6, 12 + i)];
    c[hook(5, 2)] = tmp[hook(6, i)] - tmp[hook(6, 12 + i)];
    c[hook(5, 3)] = 74 * tmp[hook(6, 4 + i)];

    block[hook(1, 4 * i + 0)] = ((-32768) > ((29 * c[hook(5, 0)] + 55 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift) ? (-32768) : (32767) < ((29 * c[hook(5, 0)] + 55 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift) ? (32767) : ((29 * c[hook(5, 0)] + 55 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift));
    block[hook(1, 4 * i + 1)] = ((-32768) > ((55 * c[hook(5, 2)] - 29 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift) ? (-32768) : (32767) < ((55 * c[hook(5, 2)] - 29 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift) ? (32767) : ((55 * c[hook(5, 2)] - 29 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift));
    block[hook(1, 4 * i + 2)] = ((-32768) > ((74 * (tmp[hook(6, i)] - tmp[hook(6, 8 + i)] + tmp[hook(6, 12 + i)]) + rnd_factor) >> shift) ? (-32768) : (32767) < ((74 * (tmp[hook(6, i)] - tmp[hook(6, 8 + i)] + tmp[hook(6, 12 + i)]) + rnd_factor) >> shift) ? (32767) : ((74 * (tmp[hook(6, i)] - tmp[hook(6, 8 + i)] + tmp[hook(6, 12 + i)]) + rnd_factor) >> shift));
    block[hook(1, 4 * i + 3)] = ((-32768) > ((55 * c[hook(5, 0)] + 29 * c[hook(5, 2)] - c[hook(5, 3)] + rnd_factor) >> shift) ? (-32768) : (32767) < ((55 * c[hook(5, 0)] + 29 * c[hook(5, 2)] - c[hook(5, 3)] + rnd_factor) >> shift) ? (32767) : ((55 * c[hook(5, 0)] + 29 * c[hook(5, 2)] - c[hook(5, 3)] + rnd_factor) >> shift));
  }
}
void fastInverseDst_lg(local short* tmp, global short* block, int shift) {
  int i, c[4];
  int rnd_factor = 1 << (shift - 1);

  for (i = 0; i < 4; i++) {
    c[hook(5, 0)] = tmp[hook(6, i)] + tmp[hook(6, 8 + i)];
    c[hook(5, 1)] = tmp[hook(6, 8 + i)] + tmp[hook(6, 12 + i)];
    c[hook(5, 2)] = tmp[hook(6, i)] - tmp[hook(6, 12 + i)];
    c[hook(5, 3)] = 74 * tmp[hook(6, 4 + i)];

    block[hook(1, 4 * i + 0)] = ((-32768) > ((29 * c[hook(5, 0)] + 55 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift) ? (-32768) : (32767) < ((29 * c[hook(5, 0)] + 55 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift) ? (32767) : ((29 * c[hook(5, 0)] + 55 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift));
    block[hook(1, 4 * i + 1)] = ((-32768) > ((55 * c[hook(5, 2)] - 29 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift) ? (-32768) : (32767) < ((55 * c[hook(5, 2)] - 29 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift) ? (32767) : ((55 * c[hook(5, 2)] - 29 * c[hook(5, 1)] + c[hook(5, 3)] + rnd_factor) >> shift));
    block[hook(1, 4 * i + 2)] = ((-32768) > ((74 * (tmp[hook(6, i)] - tmp[hook(6, 8 + i)] + tmp[hook(6, 12 + i)]) + rnd_factor) >> shift) ? (-32768) : (32767) < ((74 * (tmp[hook(6, i)] - tmp[hook(6, 8 + i)] + tmp[hook(6, 12 + i)]) + rnd_factor) >> shift) ? (32767) : ((74 * (tmp[hook(6, i)] - tmp[hook(6, 8 + i)] + tmp[hook(6, 12 + i)]) + rnd_factor) >> shift));
    block[hook(1, 4 * i + 3)] = ((-32768) > ((55 * c[hook(5, 0)] + 29 * c[hook(5, 2)] - c[hook(5, 3)] + rnd_factor) >> shift) ? (-32768) : (32767) < ((55 * c[hook(5, 0)] + 29 * c[hook(5, 2)] - c[hook(5, 3)] + rnd_factor) >> shift) ? (32767) : ((55 * c[hook(5, 0)] + 29 * c[hook(5, 2)] - c[hook(5, 3)] + rnd_factor) >> shift));
  }
}

void partialButterfly4_gl(global short* src, local short* dst, int shift, int line) {
  int j;
  int E[2], O[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    E[hook(7, 0)] = src[hook(8, 0)] + src[hook(8, 3)];
    O[hook(9, 0)] = src[hook(8, 0)] - src[hook(8, 3)];
    E[hook(7, 1)] = src[hook(8, 1)] + src[hook(8, 2)];
    O[hook(9, 1)] = src[hook(8, 1)] - src[hook(8, 2)];

    dst[hook(10, 0 * line)] = (g_aiT4[hook(12, 0)][hook(11, 0)] * E[hook(7, 0)] + g_aiT4[hook(12, 0)][hook(11, 1)] * E[hook(7, 1)] + add) >> shift;
    dst[hook(10, 2 * line)] = (g_aiT4[hook(12, 2)][hook(13, 0)] * E[hook(7, 0)] + g_aiT4[hook(12, 2)][hook(13, 1)] * E[hook(7, 1)] + add) >> shift;
    dst[hook(10, 1 * line)] = (g_aiT4[hook(12, 1)][hook(14, 0)] * O[hook(9, 0)] + g_aiT4[hook(12, 1)][hook(14, 1)] * O[hook(9, 1)] + add) >> shift;
    dst[hook(10, 3 * line)] = (g_aiT4[hook(12, 3)][hook(15, 0)] * O[hook(9, 0)] + g_aiT4[hook(12, 3)][hook(15, 1)] * O[hook(9, 1)] + add) >> shift;

    src += 4;
    dst++;
  }
}
void partialButterfly4_lg(local short* src, global short* dst, int shift, int line) {
  int j;
  int E[2], O[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    E[hook(7, 0)] = src[hook(8, 0)] + src[hook(8, 3)];
    O[hook(9, 0)] = src[hook(8, 0)] - src[hook(8, 3)];
    E[hook(7, 1)] = src[hook(8, 1)] + src[hook(8, 2)];
    O[hook(9, 1)] = src[hook(8, 1)] - src[hook(8, 2)];

    dst[hook(10, 0 * line)] = (g_aiT4[hook(12, 0)][hook(11, 0)] * E[hook(7, 0)] + g_aiT4[hook(12, 0)][hook(11, 1)] * E[hook(7, 1)] + add) >> shift;
    dst[hook(10, 2 * line)] = (g_aiT4[hook(12, 2)][hook(13, 0)] * E[hook(7, 0)] + g_aiT4[hook(12, 2)][hook(13, 1)] * E[hook(7, 1)] + add) >> shift;
    dst[hook(10, 1 * line)] = (g_aiT4[hook(12, 1)][hook(14, 0)] * O[hook(9, 0)] + g_aiT4[hook(12, 1)][hook(14, 1)] * O[hook(9, 1)] + add) >> shift;
    dst[hook(10, 3 * line)] = (g_aiT4[hook(12, 3)][hook(15, 0)] * O[hook(9, 0)] + g_aiT4[hook(12, 3)][hook(15, 1)] * O[hook(9, 1)] + add) >> shift;

    src += 4;
    dst++;
  }
}

void partialButterflyInverse4_gl(global short* src, local short* dst, int shift, int line) {
  int j;
  int E[2], O[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    O[hook(9, 0)] = g_aiT4[hook(12, 1)][hook(14, 0)] * src[hook(8, 1 * line)] + g_aiT4[hook(12, 3)][hook(15, 0)] * src[hook(8, 3 * line)];
    O[hook(9, 1)] = g_aiT4[hook(12, 1)][hook(14, 1)] * src[hook(8, 1 * line)] + g_aiT4[hook(12, 3)][hook(15, 1)] * src[hook(8, 3 * line)];
    E[hook(7, 0)] = g_aiT4[hook(12, 0)][hook(11, 0)] * src[hook(8, 0 * line)] + g_aiT4[hook(12, 2)][hook(13, 0)] * src[hook(8, 2 * line)];
    E[hook(7, 1)] = g_aiT4[hook(12, 0)][hook(11, 1)] * src[hook(8, 0 * line)] + g_aiT4[hook(12, 2)][hook(13, 1)] * src[hook(8, 2 * line)];

    dst[hook(10, 0)] = ((-32768) > ((E[hook(7, 0)] + O[hook(9, 0)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 0)] + O[hook(9, 0)] + add) >> shift) ? (32767) : ((E[hook(7, 0)] + O[hook(9, 0)] + add) >> shift));
    dst[hook(10, 1)] = ((-32768) > ((E[hook(7, 1)] + O[hook(9, 1)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 1)] + O[hook(9, 1)] + add) >> shift) ? (32767) : ((E[hook(7, 1)] + O[hook(9, 1)] + add) >> shift));
    dst[hook(10, 2)] = ((-32768) > ((E[hook(7, 1)] - O[hook(9, 1)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 1)] - O[hook(9, 1)] + add) >> shift) ? (32767) : ((E[hook(7, 1)] - O[hook(9, 1)] + add) >> shift));
    dst[hook(10, 3)] = ((-32768) > ((E[hook(7, 0)] - O[hook(9, 0)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 0)] - O[hook(9, 0)] + add) >> shift) ? (32767) : ((E[hook(7, 0)] - O[hook(9, 0)] + add) >> shift));

    src++;
    dst += 4;
  }
}
void partialButterflyInverse4_lg(local short* src, global short* dst, int shift, int line) {
  int j;
  int E[2], O[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    O[hook(9, 0)] = g_aiT4[hook(12, 1)][hook(14, 0)] * src[hook(8, 1 * line)] + g_aiT4[hook(12, 3)][hook(15, 0)] * src[hook(8, 3 * line)];
    O[hook(9, 1)] = g_aiT4[hook(12, 1)][hook(14, 1)] * src[hook(8, 1 * line)] + g_aiT4[hook(12, 3)][hook(15, 1)] * src[hook(8, 3 * line)];
    E[hook(7, 0)] = g_aiT4[hook(12, 0)][hook(11, 0)] * src[hook(8, 0 * line)] + g_aiT4[hook(12, 2)][hook(13, 0)] * src[hook(8, 2 * line)];
    E[hook(7, 1)] = g_aiT4[hook(12, 0)][hook(11, 1)] * src[hook(8, 0 * line)] + g_aiT4[hook(12, 2)][hook(13, 1)] * src[hook(8, 2 * line)];

    dst[hook(10, 0)] = ((-32768) > ((E[hook(7, 0)] + O[hook(9, 0)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 0)] + O[hook(9, 0)] + add) >> shift) ? (32767) : ((E[hook(7, 0)] + O[hook(9, 0)] + add) >> shift));
    dst[hook(10, 1)] = ((-32768) > ((E[hook(7, 1)] + O[hook(9, 1)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 1)] + O[hook(9, 1)] + add) >> shift) ? (32767) : ((E[hook(7, 1)] + O[hook(9, 1)] + add) >> shift));
    dst[hook(10, 2)] = ((-32768) > ((E[hook(7, 1)] - O[hook(9, 1)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 1)] - O[hook(9, 1)] + add) >> shift) ? (32767) : ((E[hook(7, 1)] - O[hook(9, 1)] + add) >> shift));
    dst[hook(10, 3)] = ((-32768) > ((E[hook(7, 0)] - O[hook(9, 0)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 0)] - O[hook(9, 0)] + add) >> shift) ? (32767) : ((E[hook(7, 0)] - O[hook(9, 0)] + add) >> shift));

    src++;
    dst += 4;
  }
}

void partialButterfly8_gl(global short* src, local short* dst, int shift, int line) {
  int j, k;
  int E[4], O[4];
  int EE[2], EO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 4; k++) {
      E[hook(7, k)] = src[hook(8, k)] + src[hook(8, 7 - k)];
      O[hook(9, k)] = src[hook(8, k)] - src[hook(8, 7 - k)];
    }

    EE[hook(16, 0)] = E[hook(7, 0)] + E[hook(7, 3)];
    EO[hook(17, 0)] = E[hook(7, 0)] - E[hook(7, 3)];
    EE[hook(16, 1)] = E[hook(7, 1)] + E[hook(7, 2)];
    EO[hook(17, 1)] = E[hook(7, 1)] - E[hook(7, 2)];

    dst[hook(10, 0 * line)] = (g_aiT8[hook(19, 0)][hook(18, 0)] * EE[hook(16, 0)] + g_aiT8[hook(19, 0)][hook(18, 1)] * EE[hook(16, 1)] + add) >> shift;
    dst[hook(10, 4 * line)] = (g_aiT8[hook(19, 4)][hook(20, 0)] * EE[hook(16, 0)] + g_aiT8[hook(19, 4)][hook(20, 1)] * EE[hook(16, 1)] + add) >> shift;
    dst[hook(10, 2 * line)] = (g_aiT8[hook(19, 2)][hook(21, 0)] * EO[hook(17, 0)] + g_aiT8[hook(19, 2)][hook(21, 1)] * EO[hook(17, 1)] + add) >> shift;
    dst[hook(10, 6 * line)] = (g_aiT8[hook(19, 6)][hook(22, 0)] * EO[hook(17, 0)] + g_aiT8[hook(19, 6)][hook(22, 1)] * EO[hook(17, 1)] + add) >> shift;

    dst[hook(10, 1 * line)] = (g_aiT8[hook(19, 1)][hook(23, 0)] * O[hook(9, 0)] + g_aiT8[hook(19, 1)][hook(23, 1)] * O[hook(9, 1)] + g_aiT8[hook(19, 1)][hook(23, 2)] * O[hook(9, 2)] + g_aiT8[hook(19, 1)][hook(23, 3)] * O[hook(9, 3)] + add) >> shift;
    dst[hook(10, 3 * line)] = (g_aiT8[hook(19, 3)][hook(24, 0)] * O[hook(9, 0)] + g_aiT8[hook(19, 3)][hook(24, 1)] * O[hook(9, 1)] + g_aiT8[hook(19, 3)][hook(24, 2)] * O[hook(9, 2)] + g_aiT8[hook(19, 3)][hook(24, 3)] * O[hook(9, 3)] + add) >> shift;
    dst[hook(10, 5 * line)] = (g_aiT8[hook(19, 5)][hook(25, 0)] * O[hook(9, 0)] + g_aiT8[hook(19, 5)][hook(25, 1)] * O[hook(9, 1)] + g_aiT8[hook(19, 5)][hook(25, 2)] * O[hook(9, 2)] + g_aiT8[hook(19, 5)][hook(25, 3)] * O[hook(9, 3)] + add) >> shift;
    dst[hook(10, 7 * line)] = (g_aiT8[hook(19, 7)][hook(26, 0)] * O[hook(9, 0)] + g_aiT8[hook(19, 7)][hook(26, 1)] * O[hook(9, 1)] + g_aiT8[hook(19, 7)][hook(26, 2)] * O[hook(9, 2)] + g_aiT8[hook(19, 7)][hook(26, 3)] * O[hook(9, 3)] + add) >> shift;

    src += 8;
    dst++;
  }
}
void partialButterfly8_lg(local short* src, global short* dst, int shift, int line) {
  int j, k;
  int E[4], O[4];
  int EE[2], EO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 4; k++) {
      E[hook(7, k)] = src[hook(8, k)] + src[hook(8, 7 - k)];
      O[hook(9, k)] = src[hook(8, k)] - src[hook(8, 7 - k)];
    }

    EE[hook(16, 0)] = E[hook(7, 0)] + E[hook(7, 3)];
    EO[hook(17, 0)] = E[hook(7, 0)] - E[hook(7, 3)];
    EE[hook(16, 1)] = E[hook(7, 1)] + E[hook(7, 2)];
    EO[hook(17, 1)] = E[hook(7, 1)] - E[hook(7, 2)];

    dst[hook(10, 0 * line)] = (g_aiT8[hook(19, 0)][hook(18, 0)] * EE[hook(16, 0)] + g_aiT8[hook(19, 0)][hook(18, 1)] * EE[hook(16, 1)] + add) >> shift;
    dst[hook(10, 4 * line)] = (g_aiT8[hook(19, 4)][hook(20, 0)] * EE[hook(16, 0)] + g_aiT8[hook(19, 4)][hook(20, 1)] * EE[hook(16, 1)] + add) >> shift;
    dst[hook(10, 2 * line)] = (g_aiT8[hook(19, 2)][hook(21, 0)] * EO[hook(17, 0)] + g_aiT8[hook(19, 2)][hook(21, 1)] * EO[hook(17, 1)] + add) >> shift;
    dst[hook(10, 6 * line)] = (g_aiT8[hook(19, 6)][hook(22, 0)] * EO[hook(17, 0)] + g_aiT8[hook(19, 6)][hook(22, 1)] * EO[hook(17, 1)] + add) >> shift;

    dst[hook(10, 1 * line)] = (g_aiT8[hook(19, 1)][hook(23, 0)] * O[hook(9, 0)] + g_aiT8[hook(19, 1)][hook(23, 1)] * O[hook(9, 1)] + g_aiT8[hook(19, 1)][hook(23, 2)] * O[hook(9, 2)] + g_aiT8[hook(19, 1)][hook(23, 3)] * O[hook(9, 3)] + add) >> shift;
    dst[hook(10, 3 * line)] = (g_aiT8[hook(19, 3)][hook(24, 0)] * O[hook(9, 0)] + g_aiT8[hook(19, 3)][hook(24, 1)] * O[hook(9, 1)] + g_aiT8[hook(19, 3)][hook(24, 2)] * O[hook(9, 2)] + g_aiT8[hook(19, 3)][hook(24, 3)] * O[hook(9, 3)] + add) >> shift;
    dst[hook(10, 5 * line)] = (g_aiT8[hook(19, 5)][hook(25, 0)] * O[hook(9, 0)] + g_aiT8[hook(19, 5)][hook(25, 1)] * O[hook(9, 1)] + g_aiT8[hook(19, 5)][hook(25, 2)] * O[hook(9, 2)] + g_aiT8[hook(19, 5)][hook(25, 3)] * O[hook(9, 3)] + add) >> shift;
    dst[hook(10, 7 * line)] = (g_aiT8[hook(19, 7)][hook(26, 0)] * O[hook(9, 0)] + g_aiT8[hook(19, 7)][hook(26, 1)] * O[hook(9, 1)] + g_aiT8[hook(19, 7)][hook(26, 2)] * O[hook(9, 2)] + g_aiT8[hook(19, 7)][hook(26, 3)] * O[hook(9, 3)] + add) >> shift;

    src += 8;
    dst++;
  }
}

void partialButterflyInverse8_gl(global short* src, local short* dst, int shift, int line) {
  int j, k;
  int E[4], O[4];
  int EE[2], EO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 4; k++) {
      O[hook(9, k)] = g_aiT8[hook(19, 1)][hook(23, k)] * src[hook(8, 1 * line)] + g_aiT8[hook(19, 3)][hook(24, k)] * src[hook(8, 3 * line)] + g_aiT8[hook(19, 5)][hook(25, k)] * src[hook(8, 5 * line)] + g_aiT8[hook(19, 7)][hook(26, k)] * src[hook(8, 7 * line)];
    }

    EO[hook(17, 0)] = g_aiT8[hook(19, 2)][hook(21, 0)] * src[hook(8, 2 * line)] + g_aiT8[hook(19, 6)][hook(22, 0)] * src[hook(8, 6 * line)];
    EO[hook(17, 1)] = g_aiT8[hook(19, 2)][hook(21, 1)] * src[hook(8, 2 * line)] + g_aiT8[hook(19, 6)][hook(22, 1)] * src[hook(8, 6 * line)];
    EE[hook(16, 0)] = g_aiT8[hook(19, 0)][hook(18, 0)] * src[hook(8, 0 * line)] + g_aiT8[hook(19, 4)][hook(20, 0)] * src[hook(8, 4 * line)];
    EE[hook(16, 1)] = g_aiT8[hook(19, 0)][hook(18, 1)] * src[hook(8, 0 * line)] + g_aiT8[hook(19, 4)][hook(20, 1)] * src[hook(8, 4 * line)];

    E[hook(7, 0)] = EE[hook(16, 0)] + EO[hook(17, 0)];
    E[hook(7, 3)] = EE[hook(16, 0)] - EO[hook(17, 0)];
    E[hook(7, 1)] = EE[hook(16, 1)] + EO[hook(17, 1)];
    E[hook(7, 2)] = EE[hook(16, 1)] - EO[hook(17, 1)];
    for (k = 0; k < 4; k++) {
      dst[hook(10, k + 0)] = ((-32768) > ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (32767) : ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift));
      dst[hook(10, k + 4)] = ((-32768) > ((E[hook(7, 3 - k)] - O[hook(9, 3 - k)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 3 - k)] - O[hook(9, 3 - k)] + add) >> shift) ? (32767) : ((E[hook(7, 3 - k)] - O[hook(9, 3 - k)] + add) >> shift));
    }
    src++;
    dst += 8;
  }
}
void partialButterflyInverse8_lg(local short* src, global short* dst, int shift, int line) {
  int j, k;
  int E[4], O[4];
  int EE[2], EO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 4; k++) {
      O[hook(9, k)] = g_aiT8[hook(19, 1)][hook(23, k)] * src[hook(8, 1 * line)] + g_aiT8[hook(19, 3)][hook(24, k)] * src[hook(8, 3 * line)] + g_aiT8[hook(19, 5)][hook(25, k)] * src[hook(8, 5 * line)] + g_aiT8[hook(19, 7)][hook(26, k)] * src[hook(8, 7 * line)];
    }

    EO[hook(17, 0)] = g_aiT8[hook(19, 2)][hook(21, 0)] * src[hook(8, 2 * line)] + g_aiT8[hook(19, 6)][hook(22, 0)] * src[hook(8, 6 * line)];
    EO[hook(17, 1)] = g_aiT8[hook(19, 2)][hook(21, 1)] * src[hook(8, 2 * line)] + g_aiT8[hook(19, 6)][hook(22, 1)] * src[hook(8, 6 * line)];
    EE[hook(16, 0)] = g_aiT8[hook(19, 0)][hook(18, 0)] * src[hook(8, 0 * line)] + g_aiT8[hook(19, 4)][hook(20, 0)] * src[hook(8, 4 * line)];
    EE[hook(16, 1)] = g_aiT8[hook(19, 0)][hook(18, 1)] * src[hook(8, 0 * line)] + g_aiT8[hook(19, 4)][hook(20, 1)] * src[hook(8, 4 * line)];

    E[hook(7, 0)] = EE[hook(16, 0)] + EO[hook(17, 0)];
    E[hook(7, 3)] = EE[hook(16, 0)] - EO[hook(17, 0)];
    E[hook(7, 1)] = EE[hook(16, 1)] + EO[hook(17, 1)];
    E[hook(7, 2)] = EE[hook(16, 1)] - EO[hook(17, 1)];
    for (k = 0; k < 4; k++) {
      dst[hook(10, k + 0)] = ((-32768) > ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (32767) : ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift));
      dst[hook(10, k + 4)] = ((-32768) > ((E[hook(7, 3 - k)] - O[hook(9, 3 - k)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 3 - k)] - O[hook(9, 3 - k)] + add) >> shift) ? (32767) : ((E[hook(7, 3 - k)] - O[hook(9, 3 - k)] + add) >> shift));
    }
    src++;
    dst += 8;
  }
}

void partialButterfly16_gl(global short* src, local short* dst, int shift, int line) {
  int j, k;
  int E[8], O[8];
  int EE[4], EO[4];
  int EEE[2], EEO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 8; k++) {
      E[hook(7, k)] = src[hook(8, k)] + src[hook(8, 15 - k)];
      O[hook(9, k)] = src[hook(8, k)] - src[hook(8, 15 - k)];
    }

    for (k = 0; k < 4; k++) {
      EE[hook(16, k)] = E[hook(7, k)] + E[hook(7, 7 - k)];
      EO[hook(17, k)] = E[hook(7, k)] - E[hook(7, 7 - k)];
    }

    EEE[hook(27, 0)] = EE[hook(16, 0)] + EE[hook(16, 3)];
    EEO[hook(28, 0)] = EE[hook(16, 0)] - EE[hook(16, 3)];
    EEE[hook(27, 1)] = EE[hook(16, 1)] + EE[hook(16, 2)];
    EEO[hook(28, 1)] = EE[hook(16, 1)] - EE[hook(16, 2)];

    dst[hook(10, 0 * line)] = (g_aiT16[hook(30, 0)][hook(29, 0)] * EEE[hook(27, 0)] + g_aiT16[hook(30, 0)][hook(29, 1)] * EEE[hook(27, 1)] + add) >> shift;
    dst[hook(10, 8 * line)] = (g_aiT16[hook(30, 8)][hook(31, 0)] * EEE[hook(27, 0)] + g_aiT16[hook(30, 8)][hook(31, 1)] * EEE[hook(27, 1)] + add) >> shift;
    dst[hook(10, 4 * line)] = (g_aiT16[hook(30, 4)][hook(32, 0)] * EEO[hook(28, 0)] + g_aiT16[hook(30, 4)][hook(32, 1)] * EEO[hook(28, 1)] + add) >> shift;
    dst[hook(10, 12 * line)] = (g_aiT16[hook(30, 12)][hook(33, 0)] * EEO[hook(28, 0)] + g_aiT16[hook(30, 12)][hook(33, 1)] * EEO[hook(28, 1)] + add) >> shift;

    for (k = 2; k < 16; k += 4) {
      dst[hook(10, k * line)] = (g_aiT16[hook(30, k)][hook(34, 0)] * EO[hook(17, 0)] + g_aiT16[hook(30, k)][hook(34, 1)] * EO[hook(17, 1)] + g_aiT16[hook(30, k)][hook(34, 2)] * EO[hook(17, 2)] + g_aiT16[hook(30, k)][hook(34, 3)] * EO[hook(17, 3)] + add) >> shift;
    }

    for (k = 1; k < 16; k += 2) {
      dst[hook(10, k * line)] = (g_aiT16[hook(30, k)][hook(34, 0)] * O[hook(9, 0)] + g_aiT16[hook(30, k)][hook(34, 1)] * O[hook(9, 1)] + g_aiT16[hook(30, k)][hook(34, 2)] * O[hook(9, 2)] + g_aiT16[hook(30, k)][hook(34, 3)] * O[hook(9, 3)] + g_aiT16[hook(30, k)][hook(34, 4)] * O[hook(9, 4)] + g_aiT16[hook(30, k)][hook(34, 5)] * O[hook(9, 5)] + g_aiT16[hook(30, k)][hook(34, 6)] * O[hook(9, 6)] + g_aiT16[hook(30, k)][hook(34, 7)] * O[hook(9, 7)] + add) >> shift;
    }

    src += 16;
    dst++;
  }
}
void partialButterfly16_lg(local short* src, global short* dst, int shift, int line) {
  int j, k;
  int E[8], O[8];
  int EE[4], EO[4];
  int EEE[2], EEO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 8; k++) {
      E[hook(7, k)] = src[hook(8, k)] + src[hook(8, 15 - k)];
      O[hook(9, k)] = src[hook(8, k)] - src[hook(8, 15 - k)];
    }

    for (k = 0; k < 4; k++) {
      EE[hook(16, k)] = E[hook(7, k)] + E[hook(7, 7 - k)];
      EO[hook(17, k)] = E[hook(7, k)] - E[hook(7, 7 - k)];
    }

    EEE[hook(27, 0)] = EE[hook(16, 0)] + EE[hook(16, 3)];
    EEO[hook(28, 0)] = EE[hook(16, 0)] - EE[hook(16, 3)];
    EEE[hook(27, 1)] = EE[hook(16, 1)] + EE[hook(16, 2)];
    EEO[hook(28, 1)] = EE[hook(16, 1)] - EE[hook(16, 2)];

    dst[hook(10, 0 * line)] = (g_aiT16[hook(30, 0)][hook(29, 0)] * EEE[hook(27, 0)] + g_aiT16[hook(30, 0)][hook(29, 1)] * EEE[hook(27, 1)] + add) >> shift;
    dst[hook(10, 8 * line)] = (g_aiT16[hook(30, 8)][hook(31, 0)] * EEE[hook(27, 0)] + g_aiT16[hook(30, 8)][hook(31, 1)] * EEE[hook(27, 1)] + add) >> shift;
    dst[hook(10, 4 * line)] = (g_aiT16[hook(30, 4)][hook(32, 0)] * EEO[hook(28, 0)] + g_aiT16[hook(30, 4)][hook(32, 1)] * EEO[hook(28, 1)] + add) >> shift;
    dst[hook(10, 12 * line)] = (g_aiT16[hook(30, 12)][hook(33, 0)] * EEO[hook(28, 0)] + g_aiT16[hook(30, 12)][hook(33, 1)] * EEO[hook(28, 1)] + add) >> shift;

    for (k = 2; k < 16; k += 4) {
      dst[hook(10, k * line)] = (g_aiT16[hook(30, k)][hook(34, 0)] * EO[hook(17, 0)] + g_aiT16[hook(30, k)][hook(34, 1)] * EO[hook(17, 1)] + g_aiT16[hook(30, k)][hook(34, 2)] * EO[hook(17, 2)] + g_aiT16[hook(30, k)][hook(34, 3)] * EO[hook(17, 3)] + add) >> shift;
    }

    for (k = 1; k < 16; k += 2) {
      dst[hook(10, k * line)] = (g_aiT16[hook(30, k)][hook(34, 0)] * O[hook(9, 0)] + g_aiT16[hook(30, k)][hook(34, 1)] * O[hook(9, 1)] + g_aiT16[hook(30, k)][hook(34, 2)] * O[hook(9, 2)] + g_aiT16[hook(30, k)][hook(34, 3)] * O[hook(9, 3)] + g_aiT16[hook(30, k)][hook(34, 4)] * O[hook(9, 4)] + g_aiT16[hook(30, k)][hook(34, 5)] * O[hook(9, 5)] + g_aiT16[hook(30, k)][hook(34, 6)] * O[hook(9, 6)] + g_aiT16[hook(30, k)][hook(34, 7)] * O[hook(9, 7)] + add) >> shift;
    }

    src += 16;
    dst++;
  }
}

void partialButterflyInverse16_gl(global short* src, local short* dst, int shift, int line) {
  int j, k;
  int E[8], O[8];
  int EE[4], EO[4];
  int EEE[2], EEO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 8; k++) {
      O[hook(9, k)] = g_aiT16[hook(30, 1)][hook(35, k)] * src[hook(8, 1 * line)] + g_aiT16[hook(30, 3)][hook(36, k)] * src[hook(8, 3 * line)] + g_aiT16[hook(30, 5)][hook(37, k)] * src[hook(8, 5 * line)] + g_aiT16[hook(30, 7)][hook(38, k)] * src[hook(8, 7 * line)] + g_aiT16[hook(30, 9)][hook(39, k)] * src[hook(8, 9 * line)] + g_aiT16[hook(30, 11)][hook(40, k)] * src[hook(8, 11 * line)] + g_aiT16[hook(30, 13)][hook(41, k)] * src[hook(8, 13 * line)] + g_aiT16[hook(30, 15)][hook(42, k)] * src[hook(8, 15 * line)];
    }
    for (k = 0; k < 4; k++) {
      EO[hook(17, k)] = g_aiT16[hook(30, 2)][hook(43, k)] * src[hook(8, 2 * line)] + g_aiT16[hook(30, 6)][hook(44, k)] * src[hook(8, 6 * line)] + g_aiT16[hook(30, 10)][hook(45, k)] * src[hook(8, 10 * line)] + g_aiT16[hook(30, 14)][hook(46, k)] * src[hook(8, 14 * line)];
    }
    EEO[hook(28, 0)] = g_aiT16[hook(30, 4)][hook(32, 0)] * src[hook(8, 4 * line)] + g_aiT16[hook(30, 12)][hook(33, 0)] * src[hook(8, 12 * line)];
    EEE[hook(27, 0)] = g_aiT16[hook(30, 0)][hook(29, 0)] * src[hook(8, 0 * line)] + g_aiT16[hook(30, 8)][hook(31, 0)] * src[hook(8, 8 * line)];
    EEO[hook(28, 1)] = g_aiT16[hook(30, 4)][hook(32, 1)] * src[hook(8, 4 * line)] + g_aiT16[hook(30, 12)][hook(33, 1)] * src[hook(8, 12 * line)];
    EEE[hook(27, 1)] = g_aiT16[hook(30, 0)][hook(29, 1)] * src[hook(8, 0 * line)] + g_aiT16[hook(30, 8)][hook(31, 1)] * src[hook(8, 8 * line)];

    for (k = 0; k < 2; k++) {
      EE[hook(16, k)] = EEE[hook(27, k)] + EEO[hook(28, k)];
      EE[hook(16, k + 2)] = EEE[hook(27, 1 - k)] - EEO[hook(28, 1 - k)];
    }
    for (k = 0; k < 4; k++) {
      E[hook(7, k + 0)] = EE[hook(16, k + 0)] + EO[hook(17, k + 0)];
      E[hook(7, k + 4)] = EE[hook(16, 3 - k)] - EO[hook(17, 3 - k)];
    }
    for (k = 0; k < 8; k++) {
      dst[hook(10, k + 0)] = ((-32768) > ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (32767) : ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift));
      dst[hook(10, k + 8)] = ((-32768) > ((E[hook(7, 7 - k)] - O[hook(9, 7 - k)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 7 - k)] - O[hook(9, 7 - k)] + add) >> shift) ? (32767) : ((E[hook(7, 7 - k)] - O[hook(9, 7 - k)] + add) >> shift));
    }
    src++;
    dst += 16;
  }
}
void partialButterflyInverse16_lg(local short* src, global short* dst, int shift, int line) {
  int j, k;
  int E[8], O[8];
  int EE[4], EO[4];
  int EEE[2], EEO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 8; k++) {
      O[hook(9, k)] = g_aiT16[hook(30, 1)][hook(35, k)] * src[hook(8, 1 * line)] + g_aiT16[hook(30, 3)][hook(36, k)] * src[hook(8, 3 * line)] + g_aiT16[hook(30, 5)][hook(37, k)] * src[hook(8, 5 * line)] + g_aiT16[hook(30, 7)][hook(38, k)] * src[hook(8, 7 * line)] + g_aiT16[hook(30, 9)][hook(39, k)] * src[hook(8, 9 * line)] + g_aiT16[hook(30, 11)][hook(40, k)] * src[hook(8, 11 * line)] + g_aiT16[hook(30, 13)][hook(41, k)] * src[hook(8, 13 * line)] + g_aiT16[hook(30, 15)][hook(42, k)] * src[hook(8, 15 * line)];
    }
    for (k = 0; k < 4; k++) {
      EO[hook(17, k)] = g_aiT16[hook(30, 2)][hook(43, k)] * src[hook(8, 2 * line)] + g_aiT16[hook(30, 6)][hook(44, k)] * src[hook(8, 6 * line)] + g_aiT16[hook(30, 10)][hook(45, k)] * src[hook(8, 10 * line)] + g_aiT16[hook(30, 14)][hook(46, k)] * src[hook(8, 14 * line)];
    }
    EEO[hook(28, 0)] = g_aiT16[hook(30, 4)][hook(32, 0)] * src[hook(8, 4 * line)] + g_aiT16[hook(30, 12)][hook(33, 0)] * src[hook(8, 12 * line)];
    EEE[hook(27, 0)] = g_aiT16[hook(30, 0)][hook(29, 0)] * src[hook(8, 0 * line)] + g_aiT16[hook(30, 8)][hook(31, 0)] * src[hook(8, 8 * line)];
    EEO[hook(28, 1)] = g_aiT16[hook(30, 4)][hook(32, 1)] * src[hook(8, 4 * line)] + g_aiT16[hook(30, 12)][hook(33, 1)] * src[hook(8, 12 * line)];
    EEE[hook(27, 1)] = g_aiT16[hook(30, 0)][hook(29, 1)] * src[hook(8, 0 * line)] + g_aiT16[hook(30, 8)][hook(31, 1)] * src[hook(8, 8 * line)];

    for (k = 0; k < 2; k++) {
      EE[hook(16, k)] = EEE[hook(27, k)] + EEO[hook(28, k)];
      EE[hook(16, k + 2)] = EEE[hook(27, 1 - k)] - EEO[hook(28, 1 - k)];
    }
    for (k = 0; k < 4; k++) {
      E[hook(7, k + 0)] = EE[hook(16, k + 0)] + EO[hook(17, k + 0)];
      E[hook(7, k + 4)] = EE[hook(16, 3 - k)] - EO[hook(17, 3 - k)];
    }
    for (k = 0; k < 8; k++) {
      dst[hook(10, k + 0)] = ((-32768) > ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (32767) : ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift));
      dst[hook(10, k + 8)] = ((-32768) > ((E[hook(7, 7 - k)] - O[hook(9, 7 - k)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 7 - k)] - O[hook(9, 7 - k)] + add) >> shift) ? (32767) : ((E[hook(7, 7 - k)] - O[hook(9, 7 - k)] + add) >> shift));
    }
    src++;
    dst += 16;
  }
}

void partialButterfly32_gl(global short* src, local short* dst, int shift, int line) {
  int j, k;
  int E[16], O[16];
  int EE[8], EO[8];
  int EEE[4], EEO[4];
  int EEEE[2], EEEO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 16; k++) {
      E[hook(7, k)] = src[hook(8, k)] + src[hook(8, 31 - k)];
      O[hook(9, k)] = src[hook(8, k)] - src[hook(8, 31 - k)];
    }

    for (k = 0; k < 8; k++) {
      EE[hook(16, k)] = E[hook(7, k)] + E[hook(7, 15 - k)];
      EO[hook(17, k)] = E[hook(7, k)] - E[hook(7, 15 - k)];
    }

    for (k = 0; k < 4; k++) {
      EEE[hook(27, k)] = EE[hook(16, k)] + EE[hook(16, 7 - k)];
      EEO[hook(28, k)] = EE[hook(16, k)] - EE[hook(16, 7 - k)];
    }

    EEEE[hook(47, 0)] = EEE[hook(27, 0)] + EEE[hook(27, 3)];
    EEEO[hook(48, 0)] = EEE[hook(27, 0)] - EEE[hook(27, 3)];
    EEEE[hook(47, 1)] = EEE[hook(27, 1)] + EEE[hook(27, 2)];
    EEEO[hook(48, 1)] = EEE[hook(27, 1)] - EEE[hook(27, 2)];

    dst[hook(10, 0 * line)] = (g_aiT32[hook(50, 0)][hook(49, 0)] * EEEE[hook(47, 0)] + g_aiT32[hook(50, 0)][hook(49, 1)] * EEEE[hook(47, 1)] + add) >> shift;
    dst[hook(10, 16 * line)] = (g_aiT32[hook(50, 16)][hook(51, 0)] * EEEE[hook(47, 0)] + g_aiT32[hook(50, 16)][hook(51, 1)] * EEEE[hook(47, 1)] + add) >> shift;
    dst[hook(10, 8 * line)] = (g_aiT32[hook(50, 8)][hook(52, 0)] * EEEO[hook(48, 0)] + g_aiT32[hook(50, 8)][hook(52, 1)] * EEEO[hook(48, 1)] + add) >> shift;
    dst[hook(10, 24 * line)] = (g_aiT32[hook(50, 24)][hook(53, 0)] * EEEO[hook(48, 0)] + g_aiT32[hook(50, 24)][hook(53, 1)] * EEEO[hook(48, 1)] + add) >> shift;
    for (k = 4; k < 32; k += 8) {
      dst[hook(10, k * line)] = (g_aiT32[hook(50, k)][hook(54, 0)] * EEO[hook(28, 0)] + g_aiT32[hook(50, k)][hook(54, 1)] * EEO[hook(28, 1)] + g_aiT32[hook(50, k)][hook(54, 2)] * EEO[hook(28, 2)] + g_aiT32[hook(50, k)][hook(54, 3)] * EEO[hook(28, 3)] + add) >> shift;
    }
    for (k = 2; k < 32; k += 4) {
      dst[hook(10, k * line)] = (g_aiT32[hook(50, k)][hook(54, 0)] * EO[hook(17, 0)] + g_aiT32[hook(50, k)][hook(54, 1)] * EO[hook(17, 1)] + g_aiT32[hook(50, k)][hook(54, 2)] * EO[hook(17, 2)] + g_aiT32[hook(50, k)][hook(54, 3)] * EO[hook(17, 3)] + g_aiT32[hook(50, k)][hook(54, 4)] * EO[hook(17, 4)] + g_aiT32[hook(50, k)][hook(54, 5)] * EO[hook(17, 5)] + g_aiT32[hook(50, k)][hook(54, 6)] * EO[hook(17, 6)] + g_aiT32[hook(50, k)][hook(54, 7)] * EO[hook(17, 7)] + add) >> shift;
    }
    for (k = 1; k < 32; k += 2) {
      dst[hook(10, k * line)] = (g_aiT32[hook(50, k)][hook(54, 0)] * O[hook(9, 0)] + g_aiT32[hook(50, k)][hook(54, 1)] * O[hook(9, 1)] + g_aiT32[hook(50, k)][hook(54, 2)] * O[hook(9, 2)] + g_aiT32[hook(50, k)][hook(54, 3)] * O[hook(9, 3)] + g_aiT32[hook(50, k)][hook(54, 4)] * O[hook(9, 4)] + g_aiT32[hook(50, k)][hook(54, 5)] * O[hook(9, 5)] + g_aiT32[hook(50, k)][hook(54, 6)] * O[hook(9, 6)] + g_aiT32[hook(50, k)][hook(54, 7)] * O[hook(9, 7)] + g_aiT32[hook(50, k)][hook(54, 8)] * O[hook(9, 8)] + g_aiT32[hook(50, k)][hook(54, 9)] * O[hook(9, 9)] + g_aiT32[hook(50, k)][hook(54, 10)] * O[hook(9, 10)] + g_aiT32[hook(50, k)][hook(54, 11)] * O[hook(9, 11)] + g_aiT32[hook(50, k)][hook(54, 12)] * O[hook(9, 12)] + g_aiT32[hook(50, k)][hook(54, 13)] * O[hook(9, 13)] + g_aiT32[hook(50, k)][hook(54, 14)] * O[hook(9, 14)] + g_aiT32[hook(50, k)][hook(54, 15)] * O[hook(9, 15)] + add) >> shift;
    }
    src += 32;
    dst++;
  }
}
void partialButterfly32_lg(local short* src, global short* dst, int shift, int line) {
  int j, k;
  int E[16], O[16];
  int EE[8], EO[8];
  int EEE[4], EEO[4];
  int EEEE[2], EEEO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 16; k++) {
      E[hook(7, k)] = src[hook(8, k)] + src[hook(8, 31 - k)];
      O[hook(9, k)] = src[hook(8, k)] - src[hook(8, 31 - k)];
    }

    for (k = 0; k < 8; k++) {
      EE[hook(16, k)] = E[hook(7, k)] + E[hook(7, 15 - k)];
      EO[hook(17, k)] = E[hook(7, k)] - E[hook(7, 15 - k)];
    }

    for (k = 0; k < 4; k++) {
      EEE[hook(27, k)] = EE[hook(16, k)] + EE[hook(16, 7 - k)];
      EEO[hook(28, k)] = EE[hook(16, k)] - EE[hook(16, 7 - k)];
    }

    EEEE[hook(47, 0)] = EEE[hook(27, 0)] + EEE[hook(27, 3)];
    EEEO[hook(48, 0)] = EEE[hook(27, 0)] - EEE[hook(27, 3)];
    EEEE[hook(47, 1)] = EEE[hook(27, 1)] + EEE[hook(27, 2)];
    EEEO[hook(48, 1)] = EEE[hook(27, 1)] - EEE[hook(27, 2)];

    dst[hook(10, 0 * line)] = (g_aiT32[hook(50, 0)][hook(49, 0)] * EEEE[hook(47, 0)] + g_aiT32[hook(50, 0)][hook(49, 1)] * EEEE[hook(47, 1)] + add) >> shift;
    dst[hook(10, 16 * line)] = (g_aiT32[hook(50, 16)][hook(51, 0)] * EEEE[hook(47, 0)] + g_aiT32[hook(50, 16)][hook(51, 1)] * EEEE[hook(47, 1)] + add) >> shift;
    dst[hook(10, 8 * line)] = (g_aiT32[hook(50, 8)][hook(52, 0)] * EEEO[hook(48, 0)] + g_aiT32[hook(50, 8)][hook(52, 1)] * EEEO[hook(48, 1)] + add) >> shift;
    dst[hook(10, 24 * line)] = (g_aiT32[hook(50, 24)][hook(53, 0)] * EEEO[hook(48, 0)] + g_aiT32[hook(50, 24)][hook(53, 1)] * EEEO[hook(48, 1)] + add) >> shift;
    for (k = 4; k < 32; k += 8) {
      dst[hook(10, k * line)] = (g_aiT32[hook(50, k)][hook(54, 0)] * EEO[hook(28, 0)] + g_aiT32[hook(50, k)][hook(54, 1)] * EEO[hook(28, 1)] + g_aiT32[hook(50, k)][hook(54, 2)] * EEO[hook(28, 2)] + g_aiT32[hook(50, k)][hook(54, 3)] * EEO[hook(28, 3)] + add) >> shift;
    }
    for (k = 2; k < 32; k += 4) {
      dst[hook(10, k * line)] = (g_aiT32[hook(50, k)][hook(54, 0)] * EO[hook(17, 0)] + g_aiT32[hook(50, k)][hook(54, 1)] * EO[hook(17, 1)] + g_aiT32[hook(50, k)][hook(54, 2)] * EO[hook(17, 2)] + g_aiT32[hook(50, k)][hook(54, 3)] * EO[hook(17, 3)] + g_aiT32[hook(50, k)][hook(54, 4)] * EO[hook(17, 4)] + g_aiT32[hook(50, k)][hook(54, 5)] * EO[hook(17, 5)] + g_aiT32[hook(50, k)][hook(54, 6)] * EO[hook(17, 6)] + g_aiT32[hook(50, k)][hook(54, 7)] * EO[hook(17, 7)] + add) >> shift;
    }
    for (k = 1; k < 32; k += 2) {
      dst[hook(10, k * line)] = (g_aiT32[hook(50, k)][hook(54, 0)] * O[hook(9, 0)] + g_aiT32[hook(50, k)][hook(54, 1)] * O[hook(9, 1)] + g_aiT32[hook(50, k)][hook(54, 2)] * O[hook(9, 2)] + g_aiT32[hook(50, k)][hook(54, 3)] * O[hook(9, 3)] + g_aiT32[hook(50, k)][hook(54, 4)] * O[hook(9, 4)] + g_aiT32[hook(50, k)][hook(54, 5)] * O[hook(9, 5)] + g_aiT32[hook(50, k)][hook(54, 6)] * O[hook(9, 6)] + g_aiT32[hook(50, k)][hook(54, 7)] * O[hook(9, 7)] + g_aiT32[hook(50, k)][hook(54, 8)] * O[hook(9, 8)] + g_aiT32[hook(50, k)][hook(54, 9)] * O[hook(9, 9)] + g_aiT32[hook(50, k)][hook(54, 10)] * O[hook(9, 10)] + g_aiT32[hook(50, k)][hook(54, 11)] * O[hook(9, 11)] + g_aiT32[hook(50, k)][hook(54, 12)] * O[hook(9, 12)] + g_aiT32[hook(50, k)][hook(54, 13)] * O[hook(9, 13)] + g_aiT32[hook(50, k)][hook(54, 14)] * O[hook(9, 14)] + g_aiT32[hook(50, k)][hook(54, 15)] * O[hook(9, 15)] + add) >> shift;
    }
    src += 32;
    dst++;
  }
}

void partialButterflyInverse32_gl(global short* src, local short* dst, int shift, int line) {
  int j, k;
  int E[16], O[16];
  int EE[8], EO[8];
  int EEE[4], EEO[4];
  int EEEE[2], EEEO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 16; k++) {
      O[hook(9, k)] = g_aiT32[hook(50, 1)][hook(55, k)] * src[hook(8, 1 * line)] + g_aiT32[hook(50, 3)][hook(56, k)] * src[hook(8, 3 * line)] + g_aiT32[hook(50, 5)][hook(57, k)] * src[hook(8, 5 * line)] + g_aiT32[hook(50, 7)][hook(58, k)] * src[hook(8, 7 * line)] + g_aiT32[hook(50, 9)][hook(59, k)] * src[hook(8, 9 * line)] + g_aiT32[hook(50, 11)][hook(60, k)] * src[hook(8, 11 * line)] + g_aiT32[hook(50, 13)][hook(61, k)] * src[hook(8, 13 * line)] + g_aiT32[hook(50, 15)][hook(62, k)] * src[hook(8, 15 * line)] + g_aiT32[hook(50, 17)][hook(63, k)] * src[hook(8, 17 * line)] + g_aiT32[hook(50, 19)][hook(64, k)] * src[hook(8, 19 * line)] + g_aiT32[hook(50, 21)][hook(65, k)] * src[hook(8, 21 * line)] + g_aiT32[hook(50, 23)][hook(66, k)] * src[hook(8, 23 * line)] + g_aiT32[hook(50, 25)][hook(67, k)] * src[hook(8, 25 * line)] + g_aiT32[hook(50, 27)][hook(68, k)] * src[hook(8, 27 * line)] + g_aiT32[hook(50, 29)][hook(69, k)] * src[hook(8, 29 * line)] + g_aiT32[hook(50, 31)][hook(70, k)] * src[hook(8, 31 * line)];
    }
    for (k = 0; k < 8; k++) {
      EO[hook(17, k)] = g_aiT32[hook(50, 2)][hook(71, k)] * src[hook(8, 2 * line)] + g_aiT32[hook(50, 6)][hook(72, k)] * src[hook(8, 6 * line)] + g_aiT32[hook(50, 10)][hook(73, k)] * src[hook(8, 10 * line)] + g_aiT32[hook(50, 14)][hook(74, k)] * src[hook(8, 14 * line)] + g_aiT32[hook(50, 18)][hook(75, k)] * src[hook(8, 18 * line)] + g_aiT32[hook(50, 22)][hook(76, k)] * src[hook(8, 22 * line)] + g_aiT32[hook(50, 26)][hook(77, k)] * src[hook(8, 26 * line)] + g_aiT32[hook(50, 30)][hook(78, k)] * src[hook(8, 30 * line)];
    }
    for (k = 0; k < 4; k++) {
      EEO[hook(28, k)] = g_aiT32[hook(50, 4)][hook(79, k)] * src[hook(8, 4 * line)] + g_aiT32[hook(50, 12)][hook(80, k)] * src[hook(8, 12 * line)] + g_aiT32[hook(50, 20)][hook(81, k)] * src[hook(8, 20 * line)] + g_aiT32[hook(50, 28)][hook(82, k)] * src[hook(8, 28 * line)];
    }
    EEEO[hook(48, 0)] = g_aiT32[hook(50, 8)][hook(52, 0)] * src[hook(8, 8 * line)] + g_aiT32[hook(50, 24)][hook(53, 0)] * src[hook(8, 24 * line)];
    EEEO[hook(48, 1)] = g_aiT32[hook(50, 8)][hook(52, 1)] * src[hook(8, 8 * line)] + g_aiT32[hook(50, 24)][hook(53, 1)] * src[hook(8, 24 * line)];
    EEEE[hook(47, 0)] = g_aiT32[hook(50, 0)][hook(49, 0)] * src[hook(8, 0 * line)] + g_aiT32[hook(50, 16)][hook(51, 0)] * src[hook(8, 16 * line)];
    EEEE[hook(47, 1)] = g_aiT32[hook(50, 0)][hook(49, 1)] * src[hook(8, 0 * line)] + g_aiT32[hook(50, 16)][hook(51, 1)] * src[hook(8, 16 * line)];

    EEE[hook(27, 0)] = EEEE[hook(47, 0)] + EEEO[hook(48, 0)];
    EEE[hook(27, 3)] = EEEE[hook(47, 0)] - EEEO[hook(48, 0)];
    EEE[hook(27, 1)] = EEEE[hook(47, 1)] + EEEO[hook(48, 1)];
    EEE[hook(27, 2)] = EEEE[hook(47, 1)] - EEEO[hook(48, 1)];
    for (k = 0; k < 4; k++) {
      EE[hook(16, k + 0)] = EEE[hook(27, k + 0)] + EEO[hook(28, k + 0)];
      EE[hook(16, k + 4)] = EEE[hook(27, 3 - k)] - EEO[hook(28, 3 - k)];
    }
    for (k = 0; k < 8; k++) {
      E[hook(7, k + 0)] = EE[hook(16, k + 0)] + EO[hook(17, k + 0)];
      E[hook(7, k + 8)] = EE[hook(16, 7 - k)] - EO[hook(17, 7 - k)];
    }
    for (k = 0; k < 16; k++) {
      dst[hook(10, k + 0)] = ((-32768) > ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (32767) : ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift));
      dst[hook(10, k + 16)] = ((-32768) > ((E[hook(7, 15 - k)] - O[hook(9, 15 - k)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 15 - k)] - O[hook(9, 15 - k)] + add) >> shift) ? (32767) : ((E[hook(7, 15 - k)] - O[hook(9, 15 - k)] + add) >> shift));
    }
    src++;
    dst += 32;
  }
}
void partialButterflyInverse32_lg(local short* src, global short* dst, int shift, int line) {
  int j, k;
  int E[16], O[16];
  int EE[8], EO[8];
  int EEE[4], EEO[4];
  int EEEE[2], EEEO[2];
  int add = 1 << (shift - 1);

  for (j = 0; j < line; j++) {
    for (k = 0; k < 16; k++) {
      O[hook(9, k)] = g_aiT32[hook(50, 1)][hook(55, k)] * src[hook(8, 1 * line)] + g_aiT32[hook(50, 3)][hook(56, k)] * src[hook(8, 3 * line)] + g_aiT32[hook(50, 5)][hook(57, k)] * src[hook(8, 5 * line)] + g_aiT32[hook(50, 7)][hook(58, k)] * src[hook(8, 7 * line)] + g_aiT32[hook(50, 9)][hook(59, k)] * src[hook(8, 9 * line)] + g_aiT32[hook(50, 11)][hook(60, k)] * src[hook(8, 11 * line)] + g_aiT32[hook(50, 13)][hook(61, k)] * src[hook(8, 13 * line)] + g_aiT32[hook(50, 15)][hook(62, k)] * src[hook(8, 15 * line)] + g_aiT32[hook(50, 17)][hook(63, k)] * src[hook(8, 17 * line)] + g_aiT32[hook(50, 19)][hook(64, k)] * src[hook(8, 19 * line)] + g_aiT32[hook(50, 21)][hook(65, k)] * src[hook(8, 21 * line)] + g_aiT32[hook(50, 23)][hook(66, k)] * src[hook(8, 23 * line)] + g_aiT32[hook(50, 25)][hook(67, k)] * src[hook(8, 25 * line)] + g_aiT32[hook(50, 27)][hook(68, k)] * src[hook(8, 27 * line)] + g_aiT32[hook(50, 29)][hook(69, k)] * src[hook(8, 29 * line)] + g_aiT32[hook(50, 31)][hook(70, k)] * src[hook(8, 31 * line)];
    }
    for (k = 0; k < 8; k++) {
      EO[hook(17, k)] = g_aiT32[hook(50, 2)][hook(71, k)] * src[hook(8, 2 * line)] + g_aiT32[hook(50, 6)][hook(72, k)] * src[hook(8, 6 * line)] + g_aiT32[hook(50, 10)][hook(73, k)] * src[hook(8, 10 * line)] + g_aiT32[hook(50, 14)][hook(74, k)] * src[hook(8, 14 * line)] + g_aiT32[hook(50, 18)][hook(75, k)] * src[hook(8, 18 * line)] + g_aiT32[hook(50, 22)][hook(76, k)] * src[hook(8, 22 * line)] + g_aiT32[hook(50, 26)][hook(77, k)] * src[hook(8, 26 * line)] + g_aiT32[hook(50, 30)][hook(78, k)] * src[hook(8, 30 * line)];
    }
    for (k = 0; k < 4; k++) {
      EEO[hook(28, k)] = g_aiT32[hook(50, 4)][hook(79, k)] * src[hook(8, 4 * line)] + g_aiT32[hook(50, 12)][hook(80, k)] * src[hook(8, 12 * line)] + g_aiT32[hook(50, 20)][hook(81, k)] * src[hook(8, 20 * line)] + g_aiT32[hook(50, 28)][hook(82, k)] * src[hook(8, 28 * line)];
    }
    EEEO[hook(48, 0)] = g_aiT32[hook(50, 8)][hook(52, 0)] * src[hook(8, 8 * line)] + g_aiT32[hook(50, 24)][hook(53, 0)] * src[hook(8, 24 * line)];
    EEEO[hook(48, 1)] = g_aiT32[hook(50, 8)][hook(52, 1)] * src[hook(8, 8 * line)] + g_aiT32[hook(50, 24)][hook(53, 1)] * src[hook(8, 24 * line)];
    EEEE[hook(47, 0)] = g_aiT32[hook(50, 0)][hook(49, 0)] * src[hook(8, 0 * line)] + g_aiT32[hook(50, 16)][hook(51, 0)] * src[hook(8, 16 * line)];
    EEEE[hook(47, 1)] = g_aiT32[hook(50, 0)][hook(49, 1)] * src[hook(8, 0 * line)] + g_aiT32[hook(50, 16)][hook(51, 1)] * src[hook(8, 16 * line)];

    EEE[hook(27, 0)] = EEEE[hook(47, 0)] + EEEO[hook(48, 0)];
    EEE[hook(27, 3)] = EEEE[hook(47, 0)] - EEEO[hook(48, 0)];
    EEE[hook(27, 1)] = EEEE[hook(47, 1)] + EEEO[hook(48, 1)];
    EEE[hook(27, 2)] = EEEE[hook(47, 1)] - EEEO[hook(48, 1)];
    for (k = 0; k < 4; k++) {
      EE[hook(16, k + 0)] = EEE[hook(27, k + 0)] + EEO[hook(28, k + 0)];
      EE[hook(16, k + 4)] = EEE[hook(27, 3 - k)] - EEO[hook(28, 3 - k)];
    }
    for (k = 0; k < 8; k++) {
      E[hook(7, k + 0)] = EE[hook(16, k + 0)] + EO[hook(17, k + 0)];
      E[hook(7, k + 8)] = EE[hook(16, 7 - k)] - EO[hook(17, 7 - k)];
    }
    for (k = 0; k < 16; k++) {
      dst[hook(10, k + 0)] = ((-32768) > ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift) ? (32767) : ((E[hook(7, k + 0)] + O[hook(9, k + 0)] + add) >> shift));
      dst[hook(10, k + 16)] = ((-32768) > ((E[hook(7, 15 - k)] - O[hook(9, 15 - k)] + add) >> shift) ? (-32768) : (32767) < ((E[hook(7, 15 - k)] - O[hook(9, 15 - k)] + add) >> shift) ? (32767) : ((E[hook(7, 15 - k)] - O[hook(9, 15 - k)] + add) >> shift));
    }
    src++;
    dst += 32;
  }
}

kernel void xITrMxN(global short* coeff, global short* block, const int iWidth, const int iHeight, const unsigned int uiMode) {
  int shift_1st = 7;
  int shift_2nd = 12 - g_uiBitIncrement;

  local short tmp[64 * 64];

  if (iWidth == 4 && iHeight == 4) {
    if (uiMode != 65535) {
      fastInverseDst_gl(coeff, tmp, shift_1st);
      fastInverseDst_lg(tmp, block, shift_2nd);
    } else {
      partialButterflyInverse4_gl(coeff, tmp, shift_1st, iWidth);
      partialButterflyInverse4_lg(tmp, block, shift_2nd, iHeight);
    }
  } else if (iWidth == 8 && iHeight == 8) {
    partialButterflyInverse8_gl(coeff, tmp, shift_1st, iWidth);
    partialButterflyInverse8_lg(tmp, block, shift_2nd, iHeight);
  } else if (iWidth == 16 && iHeight == 16) {
    partialButterflyInverse16_gl(coeff, tmp, shift_1st, iWidth);
    partialButterflyInverse16_lg(tmp, block, shift_2nd, iHeight);
  } else if (iWidth == 32 && iHeight == 32) {
    partialButterflyInverse32_gl(coeff, tmp, shift_1st, iWidth);
    partialButterflyInverse32_lg(tmp, block, shift_2nd, iHeight);
  }
}