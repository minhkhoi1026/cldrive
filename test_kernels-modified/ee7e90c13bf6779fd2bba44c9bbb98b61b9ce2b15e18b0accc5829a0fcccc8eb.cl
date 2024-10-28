//{"Imag":3,"Real":2,"old_Im":1,"old_Re":0,"sin_lookup":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
short constant sin_lookup[126] = {32767, 0, 32767, 0, 0, 32767, 32767, 0, 23169, 23169, 0, 32767, -23169, 23169, 32767, 0, 30272, 12539, 23169, 23169, 12539, 30272, 0, 32767, -12539, 30272, -23169, 23169, -30272, 12539, 32767, 0, 32137, 6392, 30272, 12539, 27244, 18204, 23169, 23169, 18204, 27244, 12539, 30272, 6392, 32137, 0, 32767, -6392, 32137, -12539, 30272, -18204, 27244, -23169, 23169, -27244, 18204, -30272, 12539, -32137, 6392, 32767, 0, 32609, 3211, 32137, 6392, 31356, 9511, 30272, 12539, 28897, 15446, 27244, 18204, 25329, 20787, 23169, 23169, 20787, 25329, 18204, 27244, 15446, 28897, 12539, 30272, 9511, 31356, 6392, 32137, 3211, 32609, 0, 32767, -3211, 32609, -6392, 32137, -9511, 31356, -12539, 30272, -15446, 28897, -18204, 27244, -20787, 25329, -23169, 23169, -25329, 20787, -27244, 18204, -28897, 15446, -30272, 12539, -31356, 9511, -32137, 6392, -32609, 3211};

short FIX_MPY(short a, short b) {
  int c = (int)a * (int)b;
  return (c >> 15) + ((c >> 14) & 1);
}

kernel void fft(global short* restrict old_Re, global short* restrict old_Im, global short* restrict Real, global short* restrict Imag) {
  short m, i, j, l, sin_index = 0, istep, shift, W_Imag, W_Real, qi, qr, ti, tr;

  Real[hook(2, 0)] = old_Re[hook(0, 0)];
  Imag[hook(3, 0)] = old_Im[hook(1, 0)];
  Real[hook(2, 1)] = old_Re[hook(0, 32)];
  Imag[hook(3, 1)] = old_Im[hook(1, 32)];
  Real[hook(2, 2)] = old_Re[hook(0, 16)];
  Imag[hook(3, 2)] = old_Im[hook(1, 16)];
  Real[hook(2, 3)] = old_Re[hook(0, 48)];
  Imag[hook(3, 3)] = old_Im[hook(1, 48)];
  Real[hook(2, 4)] = old_Re[hook(0, 8)];
  Imag[hook(3, 4)] = old_Im[hook(1, 8)];
  Real[hook(2, 5)] = old_Re[hook(0, 40)];
  Imag[hook(3, 5)] = old_Im[hook(1, 40)];
  Real[hook(2, 6)] = old_Re[hook(0, 24)];
  Imag[hook(3, 6)] = old_Im[hook(1, 24)];
  Real[hook(2, 7)] = old_Re[hook(0, 56)];
  Imag[hook(3, 7)] = old_Im[hook(1, 56)];
  Real[hook(2, 8)] = old_Re[hook(0, 4)];
  Imag[hook(3, 8)] = old_Im[hook(1, 4)];
  Real[hook(2, 9)] = old_Re[hook(0, 36)];
  Imag[hook(3, 9)] = old_Im[hook(1, 36)];
  Real[hook(2, 10)] = old_Re[hook(0, 20)];
  Imag[hook(3, 10)] = old_Im[hook(1, 20)];
  Real[hook(2, 11)] = old_Re[hook(0, 52)];
  Imag[hook(3, 11)] = old_Im[hook(1, 52)];
  Real[hook(2, 12)] = old_Re[hook(0, 12)];
  Imag[hook(3, 12)] = old_Im[hook(1, 12)];
  Real[hook(2, 13)] = old_Re[hook(0, 44)];
  Imag[hook(3, 13)] = old_Im[hook(1, 44)];
  Real[hook(2, 14)] = old_Re[hook(0, 28)];
  Imag[hook(3, 14)] = old_Im[hook(1, 28)];
  Real[hook(2, 15)] = old_Re[hook(0, 60)];
  Imag[hook(3, 15)] = old_Im[hook(1, 60)];
  Real[hook(2, 16)] = old_Re[hook(0, 2)];
  Imag[hook(3, 16)] = old_Im[hook(1, 2)];
  Real[hook(2, 17)] = old_Re[hook(0, 34)];
  Imag[hook(3, 17)] = old_Im[hook(1, 34)];
  Real[hook(2, 18)] = old_Re[hook(0, 18)];
  Imag[hook(3, 18)] = old_Im[hook(1, 18)];
  Real[hook(2, 19)] = old_Re[hook(0, 50)];
  Imag[hook(3, 19)] = old_Im[hook(1, 50)];
  Real[hook(2, 20)] = old_Re[hook(0, 10)];
  Imag[hook(3, 20)] = old_Im[hook(1, 10)];
  Real[hook(2, 21)] = old_Re[hook(0, 42)];
  Imag[hook(3, 21)] = old_Im[hook(1, 42)];
  Real[hook(2, 22)] = old_Re[hook(0, 26)];
  Imag[hook(3, 22)] = old_Im[hook(1, 26)];
  Real[hook(2, 23)] = old_Re[hook(0, 58)];
  Imag[hook(3, 23)] = old_Im[hook(1, 58)];
  Real[hook(2, 24)] = old_Re[hook(0, 6)];
  Imag[hook(3, 24)] = old_Im[hook(1, 6)];
  Real[hook(2, 25)] = old_Re[hook(0, 38)];
  Imag[hook(3, 25)] = old_Im[hook(1, 38)];
  Real[hook(2, 26)] = old_Re[hook(0, 22)];
  Imag[hook(3, 26)] = old_Im[hook(1, 22)];
  Real[hook(2, 27)] = old_Re[hook(0, 54)];
  Imag[hook(3, 27)] = old_Im[hook(1, 54)];
  Real[hook(2, 28)] = old_Re[hook(0, 14)];
  Imag[hook(3, 28)] = old_Im[hook(1, 14)];
  Real[hook(2, 29)] = old_Re[hook(0, 46)];
  Imag[hook(3, 29)] = old_Im[hook(1, 46)];
  Real[hook(2, 30)] = old_Re[hook(0, 30)];
  Imag[hook(3, 30)] = old_Im[hook(1, 30)];
  Real[hook(2, 31)] = old_Re[hook(0, 62)];
  Imag[hook(3, 31)] = old_Im[hook(1, 62)];
  Real[hook(2, 32)] = old_Re[hook(0, 1)];
  Imag[hook(3, 32)] = old_Im[hook(1, 1)];
  Real[hook(2, 33)] = old_Re[hook(0, 33)];
  Imag[hook(3, 33)] = old_Im[hook(1, 33)];
  Real[hook(2, 34)] = old_Re[hook(0, 17)];
  Imag[hook(3, 34)] = old_Im[hook(1, 17)];
  Real[hook(2, 35)] = old_Re[hook(0, 49)];
  Imag[hook(3, 35)] = old_Im[hook(1, 49)];
  Real[hook(2, 36)] = old_Re[hook(0, 9)];
  Imag[hook(3, 36)] = old_Im[hook(1, 9)];
  Real[hook(2, 37)] = old_Re[hook(0, 41)];
  Imag[hook(3, 37)] = old_Im[hook(1, 41)];
  Real[hook(2, 38)] = old_Re[hook(0, 25)];
  Imag[hook(3, 38)] = old_Im[hook(1, 25)];
  Real[hook(2, 39)] = old_Re[hook(0, 57)];
  Imag[hook(3, 39)] = old_Im[hook(1, 57)];
  Real[hook(2, 40)] = old_Re[hook(0, 5)];
  Imag[hook(3, 40)] = old_Im[hook(1, 5)];
  Real[hook(2, 41)] = old_Re[hook(0, 37)];
  Imag[hook(3, 41)] = old_Im[hook(1, 37)];
  Real[hook(2, 42)] = old_Re[hook(0, 21)];
  Imag[hook(3, 42)] = old_Im[hook(1, 21)];
  Real[hook(2, 43)] = old_Re[hook(0, 53)];
  Imag[hook(3, 43)] = old_Im[hook(1, 53)];
  Real[hook(2, 44)] = old_Re[hook(0, 13)];
  Imag[hook(3, 44)] = old_Im[hook(1, 13)];
  Real[hook(2, 45)] = old_Re[hook(0, 45)];
  Imag[hook(3, 45)] = old_Im[hook(1, 45)];
  Real[hook(2, 46)] = old_Re[hook(0, 29)];
  Imag[hook(3, 46)] = old_Im[hook(1, 29)];
  Real[hook(2, 47)] = old_Re[hook(0, 61)];
  Imag[hook(3, 47)] = old_Im[hook(1, 61)];
  Real[hook(2, 48)] = old_Re[hook(0, 3)];
  Imag[hook(3, 48)] = old_Im[hook(1, 3)];
  Real[hook(2, 49)] = old_Re[hook(0, 35)];
  Imag[hook(3, 49)] = old_Im[hook(1, 35)];
  Real[hook(2, 50)] = old_Re[hook(0, 19)];
  Imag[hook(3, 50)] = old_Im[hook(1, 19)];
  Real[hook(2, 51)] = old_Re[hook(0, 51)];
  Imag[hook(3, 51)] = old_Im[hook(1, 51)];
  Real[hook(2, 52)] = old_Re[hook(0, 11)];
  Imag[hook(3, 52)] = old_Im[hook(1, 11)];
  Real[hook(2, 53)] = old_Re[hook(0, 43)];
  Imag[hook(3, 53)] = old_Im[hook(1, 43)];
  Real[hook(2, 54)] = old_Re[hook(0, 27)];
  Imag[hook(3, 54)] = old_Im[hook(1, 27)];
  Real[hook(2, 55)] = old_Re[hook(0, 59)];
  Imag[hook(3, 55)] = old_Im[hook(1, 59)];
  Real[hook(2, 56)] = old_Re[hook(0, 7)];
  Imag[hook(3, 56)] = old_Im[hook(1, 7)];
  Real[hook(2, 57)] = old_Re[hook(0, 39)];
  Imag[hook(3, 57)] = old_Im[hook(1, 39)];
  Real[hook(2, 58)] = old_Re[hook(0, 23)];
  Imag[hook(3, 58)] = old_Im[hook(1, 23)];
  Real[hook(2, 59)] = old_Re[hook(0, 55)];
  Imag[hook(3, 59)] = old_Im[hook(1, 55)];
  Real[hook(2, 60)] = old_Re[hook(0, 15)];
  Imag[hook(3, 60)] = old_Im[hook(1, 15)];
  Real[hook(2, 61)] = old_Re[hook(0, 47)];
  Imag[hook(3, 61)] = old_Im[hook(1, 47)];
  Real[hook(2, 62)] = old_Re[hook(0, 31)];
  Imag[hook(3, 62)] = old_Im[hook(1, 31)];
  Real[hook(2, 63)] = old_Re[hook(0, 63)];
  Imag[hook(3, 63)] = old_Im[hook(1, 63)];

  l = 1;
  while (l < 128) {
    if (0)
      shift = 128 - 1;
    else
      shift = 0;

    istep = l << 1;
    for (m = 0; m < l; m++) {
      W_Imag = sin_lookup[hook(4, sin_index)];
      W_Real = sin_lookup[hook(4, sin_index + 1)];
      sin_index = sin_index + 2;
      if (0)
        W_Real = -W_Real;
      if (shift) {
        W_Imag >>= 1;
        W_Real >>= 1;
      }
      for (i = m; i < 128; i += istep) {
        j = i + l;

        ti = FIX_MPY(W_Imag, Imag[hook(3, j)]) - FIX_MPY(W_Real, Real[hook(2, j)]);
        tr = FIX_MPY(W_Imag, Real[hook(2, j)]) + FIX_MPY(W_Real, Imag[hook(3, j)]);
        qi = Imag[hook(3, i)];
        qr = Real[hook(2, i)];
        if (shift) {
          qi >>= 1;
          qr >>= 1;
        }
        Imag[hook(3, j)] = qi - ti;
        Real[hook(2, j)] = qr - tr;
        Imag[hook(3, i)] = qi + ti;
        Real[hook(2, i)] = qr + tr;
      }
    }
    l = istep;
  }
}