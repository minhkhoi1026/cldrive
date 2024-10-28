//{"C":3,"F0_OUT":4,"F1_OUT":6,"P":0,"SK":2,"WK":1,"X0":7,"X1":11,"X2":8,"X3":12,"X4":9,"X5":13,"X6":10,"X7":14,"counter":16,"out":15,"outCipher":17,"x":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void F0(private uchar* x, private uchar* F0_OUT) {
  F0_OUT[hook(4, 0)] = (((x[hook(5, 0)]) << (1)) | ((x[hook(5, 0)]) >> (8 - 1))) ^ (((x[hook(5, 0)]) << (2)) | ((x[hook(5, 0)]) >> (8 - 2))) ^ (((x[hook(5, 0)]) << (7)) | ((x[hook(5, 0)]) >> (8 - 7)));
}

void F1(private uchar* x, private uchar* F1_OUT) {
  F1_OUT[hook(6, 0)] = (((x[hook(5, 0)]) << (3)) | ((x[hook(5, 0)]) >> (8 - 3))) ^ (((x[hook(5, 0)]) << (4)) | ((x[hook(5, 0)]) >> (8 - 4))) ^ (((x[hook(5, 0)]) << (6)) | ((x[hook(5, 0)]) >> (8 - 6)));
}

void hight_encrypt(private ulong* P, global uchar* WK, global uchar* SK, private ulong* out) {
 private
  uchar X0[1], X1[1], X2[1], X3[1], X4[1], X5[1], X6[1], X7[1];
 private
  uchar F0_OUT[1], F1_OUT[1];

  X0[hook(7, 0)] = ((P[hook(0, 0)] >> (8 * 0)) & 0xff) + WK[hook(1, 0)];
  X2[hook(8, 0)] = ((P[hook(0, 0)] >> (8 * 2)) & 0xff) ^ WK[hook(1, 1)];
  X4[hook(9, 0)] = ((P[hook(0, 0)] >> (8 * 4)) & 0xff) + WK[hook(1, 2)];
  X6[hook(10, 0)] = ((P[hook(0, 0)] >> (8 * 6)) & 0xff) ^ WK[hook(1, 3)];
  X1[hook(11, 0)] = ((P[hook(0, 0)] >> (8 * 1)) & 0xff);
  X3[hook(12, 0)] = ((P[hook(0, 0)] >> (8 * 3)) & 0xff);
  X5[hook(13, 0)] = ((P[hook(0, 0)] >> (8 * 5)) & 0xff);
  X7[hook(14, 0)] = ((P[hook(0, 0)] >> (8 * 7)) & 0xff);

  for (int i = 0; i < 31; ++i) {
    F0(X6, F0_OUT);
    uchar Xn0 = X7[hook(14, 0)] ^ (F0_OUT[hook(4, 0)] + SK[hook(2, 4 * i + 3)]);
    uchar Xn1 = X0[hook(7, 0)];
    F1(X0, F1_OUT);
    uchar Xn2 = X1[hook(11, 0)] + (F1_OUT[hook(6, 0)] ^ SK[hook(2, 4 * i)]);
    uchar Xn3 = X2[hook(8, 0)];
    F0(X2, F0_OUT);
    uchar Xn4 = X3[hook(12, 0)] ^ (F0_OUT[hook(4, 0)] + SK[hook(2, 4 * i + 1)]);
    uchar Xn5 = X4[hook(9, 0)];
    F1(X4, F1_OUT);
    uchar Xn6 = X5[hook(13, 0)] + (F1_OUT[hook(6, 0)] ^ SK[hook(2, 4 * i + 2)]);
    uchar Xn7 = X6[hook(10, 0)];

    X0[hook(7, 0)] = Xn0;
    X1[hook(11, 0)] = Xn1;
    X2[hook(8, 0)] = Xn2;
    X3[hook(12, 0)] = Xn3;
    X4[hook(9, 0)] = Xn4;
    X5[hook(13, 0)] = Xn5;
    X6[hook(10, 0)] = Xn6;
    X7[hook(14, 0)] = Xn7;
  }

  uchar Xn0 = X0[hook(7, 0)];
  F1(X0, F1_OUT);
  uchar Xn1 = X1[hook(11, 0)] + (F1_OUT[hook(6, 0)] ^ SK[hook(2, 124)]);
  uchar Xn2 = X2[hook(8, 0)];
  F0(X2, F0_OUT);
  uchar Xn3 = X3[hook(12, 0)] ^ (F0_OUT[hook(4, 0)] + SK[hook(2, 125)]);
  uchar Xn4 = X4[hook(9, 0)];
  F1(X4, F1_OUT);
  uchar Xn5 = X5[hook(13, 0)] + (F1_OUT[hook(6, 0)] ^ SK[hook(2, 126)]);
  uchar Xn6 = X6[hook(10, 0)];
  F0(X6, F0_OUT);
  uchar Xn7 = X7[hook(14, 0)] ^ (F0_OUT[hook(4, 0)] + SK[hook(2, 127)]);

  X0[hook(7, 0)] = Xn0;
  X1[hook(11, 0)] = Xn1;
  X2[hook(8, 0)] = Xn2;
  X3[hook(12, 0)] = Xn3;
  X4[hook(9, 0)] = Xn4;
  X5[hook(13, 0)] = Xn5;
  X6[hook(10, 0)] = Xn6;
  X7[hook(14, 0)] = Xn7;

  uchar C0 = X0[hook(7, 0)] + WK[hook(1, 4)];
  uchar C1 = X1[hook(11, 0)];
  uchar C2 = X2[hook(8, 0)] ^ WK[hook(1, 5)];
  uchar C3 = X3[hook(12, 0)];
  uchar C4 = X4[hook(9, 0)] + WK[hook(1, 6)];
  uchar C5 = X5[hook(13, 0)];
  uchar C6 = X6[hook(10, 0)] ^ WK[hook(1, 7)];
  uchar C7 = X7[hook(14, 0)];

  out[hook(15, 0)] = (((ulong)(C7) << (8 * 7)) | ((ulong)(C6) << (8 * 6)) | ((ulong)(C5) << (8 * 5)) | ((ulong)(C4) << (8 * 4)) | ((ulong)(C3) << (8 * 3)) | ((ulong)(C2) << (8 * 2)) | ((ulong)(C1) << (8 * 1)) | ((ulong)(C0) << (8 * 0)));
}

kernel void hightCtrCipher(global ulong* P, global uchar* WK, global uchar* SK, global ulong* C) {
 private
  int gid;
  gid = get_global_id(0);

 private
  ulong counter[1];

  counter[hook(16, 0)] = (ulong)gid;

 private
  ulong outCipher[1];

  hight_encrypt(counter, WK, SK, outCipher);

  C[hook(3, gid)] = outCipher[hook(17, 0)] ^ P[hook(0, gid)];
}