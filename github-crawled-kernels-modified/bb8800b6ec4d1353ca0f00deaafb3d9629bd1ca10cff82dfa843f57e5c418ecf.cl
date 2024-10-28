//{"BK":15,"BN":14,"C":5,"H":6,"K":8,"M":85,"M[0]":84,"M[1]":86,"M[i]":88,"N":4,"Nmask":22,"Nwidth":23,"P":9,"Q":10,"TA":54,"TB":63,"TM":76,"TM[0]":75,"TM[1]":78,"TM[2]":80,"TM[3]":82,"TP":12,"TPmask":16,"TPshift":18,"TPwidth":17,"TQ":13,"TQmask":19,"TQshift":21,"TQwidth":20,"TU":58,"TU[0]":57,"TU[1]":60,"TU[2]":62,"TU[3]":59,"TV":32,"TV[0]":31,"TV[1]":38,"TV[2]":39,"TV[3]":35,"U":65,"U[0]":64,"U[1]":67,"U[2]":68,"U[3]":66,"U[i]":70,"V":41,"V[0]":40,"V[1]":43,"V[2]":44,"V[3]":42,"V[i]":46,"W":7,"bias":3,"filters":2,"inputs":0,"m":73,"m[0]":77,"m[1]":79,"m[2]":81,"m[3]":83,"m[i]":72,"outputs":1,"pO":87,"pRSM":74,"pRSU":48,"pRSV":50,"pU":53,"pV":30,"pWSM":71,"pWSU":69,"pWSV":45,"pad":11,"preds":27,"preds[i]":26,"r":25,"rA":47,"rB":49,"r[i]":24,"u":52,"u[0]":55,"u[1]":61,"u[2]":56,"u[i]":51,"v":29,"v[0]":33,"v[1]":36,"v[2]":34,"v[3]":37,"v[i]":28}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void winograd_2x2_3x3_16x16(global float* inputs, global float* outputs, global float* filters, global float* bias, int N, int C, int H, int W, int K, int P, int Q, int pad, int TP, int TQ, int BN, int BK, int TPmask, int TPwidth, int TPshift, int TQmask, int TQwidth, int TQshift, int Nmask, int Nwidth) {
  int tptqbnbk = get_group_id(0);
  int tp = tptqbnbk / (TQ * BN * BK);
  int tqbnbk = tptqbnbk - tp * (TQ * BN * BK);
  int tq = tqbnbk / (BN * BK);
  int bnbk = tqbnbk - tq * (BN * BK);
  int bn = bnbk / (BK);
  int bk = bnbk - bn * (BK);

  int tid = get_local_id(0);
  int tidlow = tid & 15;
  int c = (tid & 0x70) >> 4;
  int ci = c - (C & 7 ? 8 - (C & 7) : 0);
  tp = (tp << TPwidth) + ((tid & TPmask) >> TPshift);
  tq = (tq << TQwidth) + ((tid & TQmask) >> TQshift);
  int h = (tp << 1) - pad, w = (tq << 1) - pad;
  int n = ((get_group_id(2) * BN + bn) << Nwidth) + (tid & Nmask);
  int k = ((get_group_id(1) * BK + bk) << 4) + tidlow;

  local float SM[2 * 8 * 16 * 16];
  local float* pRSV = SM + (tid & 0xf0) + (tid & 0x3);
  local float* pRSU = SM + 8 * 16 * 16 + (tid & 0xf0) + ((tid & 0xc) >> 2);

  float r[4][4], rA[4], rB[4];
  for (int i = 0; i < 4; ++i) {
    for (int j = 0; j < 4; ++j) {
      r[hook(25, i)][hook(24, j)] = 0;
    }
  }

  if (tid < 128) {
    float v[4][4], TV[4][4], V[4][4];

    bool preds[4][4];
    for (int i = 0; i < 4; ++i) {
      for (int j = 0; j < 4; ++j) {
        preds[hook(27, i)][hook(26, j)] = n < N && 0 <= h + i && h + i < H && 0 <= w + j && w + j < W;
      }
    }

    global float* pV = inputs + ((ci * H + h) * W + w) * N + n;
    for (int i = 0; i < 4; ++i) {
      for (int j = 0; j < 4; ++j) {
        v[hook(29, i)][hook(28, j)] = ci >= 0 && preds[hook(27, i)][hook(26, j)] ? pV[hook(30, (i * W + j) * N)] : 0;
      }
    }

    local float* pWSV = SM + c * 16 * 16 + tidlow;
    while (true) {
      TV[hook(32, 0)][hook(31, 0)] = v[hook(29, 0)][hook(33, 0)] - v[hook(29, 2)][hook(34, 0)];
      TV[hook(32, 0)][hook(31, 1)] = v[hook(29, 0)][hook(33, 1)] - v[hook(29, 2)][hook(34, 1)];
      TV[hook(32, 0)][hook(31, 2)] = v[hook(29, 0)][hook(33, 2)] - v[hook(29, 2)][hook(34, 2)];
      TV[hook(32, 0)][hook(31, 3)] = v[hook(29, 0)][hook(33, 3)] - v[hook(29, 2)][hook(34, 3)];

      TV[hook(32, 3)][hook(35, 0)] = v[hook(29, 1)][hook(36, 0)] - v[hook(29, 3)][hook(37, 0)];
      TV[hook(32, 3)][hook(35, 1)] = v[hook(29, 1)][hook(36, 1)] - v[hook(29, 3)][hook(37, 1)];
      TV[hook(32, 3)][hook(35, 2)] = v[hook(29, 1)][hook(36, 2)] - v[hook(29, 3)][hook(37, 2)];
      TV[hook(32, 3)][hook(35, 3)] = v[hook(29, 1)][hook(36, 3)] - v[hook(29, 3)][hook(37, 3)];

      TV[hook(32, 1)][hook(38, 0)] = v[hook(29, 1)][hook(36, 0)] + v[hook(29, 2)][hook(34, 0)];
      TV[hook(32, 1)][hook(38, 1)] = v[hook(29, 1)][hook(36, 1)] + v[hook(29, 2)][hook(34, 1)];
      TV[hook(32, 1)][hook(38, 2)] = v[hook(29, 1)][hook(36, 2)] + v[hook(29, 2)][hook(34, 2)];
      TV[hook(32, 1)][hook(38, 3)] = v[hook(29, 1)][hook(36, 3)] + v[hook(29, 2)][hook(34, 3)];

      TV[hook(32, 2)][hook(39, 0)] = v[hook(29, 2)][hook(34, 0)] - v[hook(29, 1)][hook(36, 0)];
      TV[hook(32, 2)][hook(39, 1)] = v[hook(29, 2)][hook(34, 1)] - v[hook(29, 1)][hook(36, 1)];
      TV[hook(32, 2)][hook(39, 2)] = v[hook(29, 2)][hook(34, 2)] - v[hook(29, 1)][hook(36, 2)];
      TV[hook(32, 2)][hook(39, 3)] = v[hook(29, 2)][hook(34, 3)] - v[hook(29, 1)][hook(36, 3)];

      V[hook(41, 0)][hook(40, 0)] = TV[hook(32, 0)][hook(31, 0)] - TV[hook(32, 0)][hook(31, 2)];
      V[hook(41, 0)][hook(40, 3)] = TV[hook(32, 0)][hook(31, 1)] - TV[hook(32, 0)][hook(31, 3)];
      V[hook(41, 3)][hook(42, 0)] = TV[hook(32, 3)][hook(35, 0)] - TV[hook(32, 3)][hook(35, 2)];
      V[hook(41, 3)][hook(42, 3)] = TV[hook(32, 3)][hook(35, 1)] - TV[hook(32, 3)][hook(35, 3)];

      V[hook(41, 1)][hook(43, 0)] = TV[hook(32, 1)][hook(38, 0)] - TV[hook(32, 1)][hook(38, 2)];
      V[hook(41, 2)][hook(44, 0)] = TV[hook(32, 2)][hook(39, 0)] - TV[hook(32, 2)][hook(39, 2)];
      V[hook(41, 1)][hook(43, 3)] = TV[hook(32, 1)][hook(38, 1)] - TV[hook(32, 1)][hook(38, 3)];
      V[hook(41, 2)][hook(44, 3)] = TV[hook(32, 2)][hook(39, 1)] - TV[hook(32, 2)][hook(39, 3)];

      V[hook(41, 2)][hook(44, 1)] = TV[hook(32, 2)][hook(39, 1)] + TV[hook(32, 2)][hook(39, 2)];
      V[hook(41, 2)][hook(44, 2)] = TV[hook(32, 2)][hook(39, 2)] - TV[hook(32, 2)][hook(39, 1)];

      V[hook(41, 0)][hook(40, 1)] = TV[hook(32, 0)][hook(31, 1)] + TV[hook(32, 0)][hook(31, 2)];
      V[hook(41, 0)][hook(40, 2)] = TV[hook(32, 0)][hook(31, 2)] - TV[hook(32, 0)][hook(31, 1)];
      V[hook(41, 1)][hook(43, 1)] = TV[hook(32, 1)][hook(38, 1)] + TV[hook(32, 1)][hook(38, 2)];
      V[hook(41, 1)][hook(43, 2)] = TV[hook(32, 1)][hook(38, 2)] - TV[hook(32, 1)][hook(38, 1)];
      V[hook(41, 3)][hook(42, 1)] = TV[hook(32, 3)][hook(35, 1)] + TV[hook(32, 3)][hook(35, 2)];
      V[hook(41, 3)][hook(42, 2)] = TV[hook(32, 3)][hook(35, 2)] - TV[hook(32, 3)][hook(35, 1)];

      for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
          pWSV[hook(45, (i * 4 + j) * 16)] = V[hook(41, i)][hook(46, j)];
        }
      }

      barrier(0x01);

      for (int l = 0; l < 8; ++l) {
        for (int i = 0; i < 4; ++i) {
          rA[hook(47, i)] = pRSU[hook(48, l * 16 * 16 + i * 4)];
          rB[hook(49, i)] = pRSV[hook(50, l * 16 * 16 + i * 4)];
        }
        for (int i = 0; i < 4; ++i) {
          for (int j = 0; j < 4; ++j) {
            r[hook(25, i)][hook(24, j)] += rA[hook(47, i)] * rB[hook(49, j)];
          }
        }
      }

      barrier(0x01);

      ci += 8;
      if (ci >= C)
        break;
      pV += 8 * H * W * N;

      for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
          v[hook(29, i)][hook(28, j)] = preds[hook(27, i)][hook(26, j)] ? pV[hook(30, (i * W + j) * N)] : 0;
        }
      }
    }
  } else {
    float u[3][3], TU[4][3], TA[3], TB[4], U[4][4];

    bool pred = k < K;

    global float* pU = filters + ci * 3 * 3 * K + k;
    for (int i = 0; i < 3; ++i) {
      for (int j = 0; j < 3; ++j) {
        u[hook(52, i)][hook(51, j)] = ci >= 0 && pred ? pU[hook(53, (i * 3 + j) * K)] : 0;
      }
    }

    local float* pWSU = SM + (c + 8) * 16 * 16 + tidlow;
    while (true) {
      TA[hook(54, 0)] = (u[hook(52, 0)][hook(55, 0)] + u[hook(52, 2)][hook(56, 0)]) * 0.5;
      TA[hook(54, 1)] = (u[hook(52, 0)][hook(55, 1)] + u[hook(52, 2)][hook(56, 1)]) * 0.5;
      TA[hook(54, 2)] = (u[hook(52, 0)][hook(55, 2)] + u[hook(52, 2)][hook(56, 2)]) * 0.5;
      TU[hook(58, 0)][hook(57, 0)] = u[hook(52, 0)][hook(55, 0)];
      TU[hook(58, 0)][hook(57, 1)] = u[hook(52, 0)][hook(55, 1)];
      TU[hook(58, 0)][hook(57, 2)] = u[hook(52, 0)][hook(55, 2)];
      TU[hook(58, 3)][hook(59, 0)] = u[hook(52, 2)][hook(56, 0)];
      TU[hook(58, 3)][hook(59, 1)] = u[hook(52, 2)][hook(56, 1)];
      TU[hook(58, 3)][hook(59, 2)] = u[hook(52, 2)][hook(56, 2)];
      TU[hook(58, 1)][hook(60, 0)] = TA[hook(54, 0)] + u[hook(52, 1)][hook(61, 0)] * 0.5;
      TU[hook(58, 2)][hook(62, 0)] = TA[hook(54, 0)] - u[hook(52, 1)][hook(61, 0)] * 0.5;
      TU[hook(58, 1)][hook(60, 1)] = TA[hook(54, 1)] + u[hook(52, 1)][hook(61, 1)] * 0.5;
      TU[hook(58, 2)][hook(62, 1)] = TA[hook(54, 1)] - u[hook(52, 1)][hook(61, 1)] * 0.5;
      TU[hook(58, 1)][hook(60, 2)] = TA[hook(54, 2)] + u[hook(52, 1)][hook(61, 2)] * 0.5;
      TU[hook(58, 2)][hook(62, 2)] = TA[hook(54, 2)] - u[hook(52, 1)][hook(61, 2)] * 0.5;
      TB[hook(63, 0)] = (TU[hook(58, 0)][hook(57, 0)] + TU[hook(58, 0)][hook(57, 2)]) * 0.5;
      TB[hook(63, 1)] = (TU[hook(58, 1)][hook(60, 0)] + TU[hook(58, 1)][hook(60, 2)]) * 0.5;
      TB[hook(63, 2)] = (TU[hook(58, 2)][hook(62, 0)] + TU[hook(58, 2)][hook(62, 2)]) * 0.5;
      TB[hook(63, 3)] = (TU[hook(58, 3)][hook(59, 0)] + TU[hook(58, 3)][hook(59, 2)]) * 0.5;
      U[hook(65, 0)][hook(64, 0)] = TU[hook(58, 0)][hook(57, 0)];
      U[hook(65, 0)][hook(64, 3)] = TU[hook(58, 0)][hook(57, 2)];
      U[hook(65, 3)][hook(66, 0)] = TU[hook(58, 3)][hook(59, 0)];
      U[hook(65, 3)][hook(66, 3)] = TU[hook(58, 3)][hook(59, 2)];
      U[hook(65, 1)][hook(67, 0)] = TU[hook(58, 1)][hook(60, 0)];
      U[hook(65, 2)][hook(68, 0)] = TU[hook(58, 2)][hook(62, 0)];
      U[hook(65, 1)][hook(67, 3)] = TU[hook(58, 1)][hook(60, 2)];
      U[hook(65, 2)][hook(68, 3)] = TU[hook(58, 2)][hook(62, 2)];
      U[hook(65, 1)][hook(67, 1)] = TB[hook(63, 1)] + TU[hook(58, 1)][hook(60, 1)] * 0.5;
      U[hook(65, 1)][hook(67, 2)] = TB[hook(63, 1)] - TU[hook(58, 1)][hook(60, 1)] * 0.5;
      U[hook(65, 2)][hook(68, 1)] = TB[hook(63, 2)] + TU[hook(58, 2)][hook(62, 1)] * 0.5;
      U[hook(65, 2)][hook(68, 2)] = TB[hook(63, 2)] - TU[hook(58, 2)][hook(62, 1)] * 0.5;
      U[hook(65, 0)][hook(64, 1)] = TB[hook(63, 0)] + TU[hook(58, 0)][hook(57, 1)] * 0.5;
      U[hook(65, 0)][hook(64, 2)] = TB[hook(63, 0)] - TU[hook(58, 0)][hook(57, 1)] * 0.5;
      U[hook(65, 3)][hook(66, 1)] = TB[hook(63, 3)] + TU[hook(58, 3)][hook(59, 1)] * 0.5;
      U[hook(65, 3)][hook(66, 2)] = TB[hook(63, 3)] - TU[hook(58, 3)][hook(59, 1)] * 0.5;

      for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
          pWSU[hook(69, (i * 4 + j) * 16)] = U[hook(65, i)][hook(70, j)];
        }
      }

      barrier(0x01);

      for (int l = 0; l < 8; ++l) {
        for (int i = 0; i < 4; ++i) {
          rA[hook(47, i)] = pRSU[hook(48, l * 16 * 16 + i * 4)];
          rB[hook(49, i)] = pRSV[hook(50, l * 16 * 16 + i * 4)];
        }
        for (int i = 0; i < 4; ++i) {
          for (int j = 0; j < 4; ++j) {
            r[hook(25, i)][hook(24, j)] += rA[hook(47, i)] * rB[hook(49, j)];
          }
        }
      }

      barrier(0x01);

      ci += 8;
      if (ci >= C)
        break;
      pU += 8 * 3 * 3 * K;

      for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
          u[hook(52, i)][hook(51, j)] = pred ? pU[hook(53, (i * 3 + j) * K)] : 0;
        }
      }
    }
  }

  {
    local float* pWSM = SM + ((tid & 0x0c) << 6) + ((tid & 0xf0) << 0) + (tid & 0x03);
    local float* pRSM = SM + ((tid & 0xf0) << 4) + tidlow;
    int oh = h + pad, ow = w + pad, on = n;
    int ok = k - tidlow + ((tid & 0xf0) >> 4);
    global float* pO = outputs + ((ok * P + oh) * Q + ow) * N + on;

    bool preds[2][2];
    for (int i = 0; i < 2; ++i) {
      for (int j = 0; j < 2; ++j) {
        preds[hook(27, i)][hook(26, j)] = on < N && 0 <= oh + i && oh + i < P && 0 <= ow + j && ow + j < Q;
      }
    }

    {
      for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
          pWSM[hook(71, (i << 10) + (j << 2))] = r[hook(25, i)][hook(24, j)];
        }
      }

      barrier(0x01);

      float m[4][4], TM[4][2], M[2][2];
      for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
          m[hook(73, i)][hook(72, j)] = pRSM[hook(74, (i * 4 + j) * 16)];
        }
      }

      barrier(0x01);

      TM[hook(76, 0)][hook(75, 0)] = m[hook(73, 0)][hook(77, 0)] + m[hook(73, 0)][hook(77, 1)] + m[hook(73, 0)][hook(77, 2)];
      TM[hook(76, 0)][hook(75, 1)] = m[hook(73, 0)][hook(77, 1)] - m[hook(73, 0)][hook(77, 2)] - m[hook(73, 0)][hook(77, 3)];
      TM[hook(76, 1)][hook(78, 0)] = m[hook(73, 1)][hook(79, 0)] + m[hook(73, 1)][hook(79, 1)] + m[hook(73, 1)][hook(79, 2)];
      TM[hook(76, 1)][hook(78, 1)] = m[hook(73, 1)][hook(79, 1)] - m[hook(73, 1)][hook(79, 2)] - m[hook(73, 1)][hook(79, 3)];
      TM[hook(76, 2)][hook(80, 0)] = m[hook(73, 2)][hook(81, 0)] + m[hook(73, 2)][hook(81, 1)] + m[hook(73, 2)][hook(81, 2)];
      TM[hook(76, 2)][hook(80, 1)] = m[hook(73, 2)][hook(81, 1)] - m[hook(73, 2)][hook(81, 2)] - m[hook(73, 2)][hook(81, 3)];
      TM[hook(76, 3)][hook(82, 0)] = m[hook(73, 3)][hook(83, 0)] + m[hook(73, 3)][hook(83, 1)] + m[hook(73, 3)][hook(83, 2)];
      TM[hook(76, 3)][hook(82, 1)] = m[hook(73, 3)][hook(83, 1)] - m[hook(73, 3)][hook(83, 2)] - m[hook(73, 3)][hook(83, 3)];

      M[hook(85, 0)][hook(84, 0)] = TM[hook(76, 0)][hook(75, 0)] + TM[hook(76, 1)][hook(78, 0)] + TM[hook(76, 2)][hook(80, 0)];
      M[hook(85, 0)][hook(84, 1)] = TM[hook(76, 0)][hook(75, 1)] + TM[hook(76, 1)][hook(78, 1)] + TM[hook(76, 2)][hook(80, 1)];
      M[hook(85, 1)][hook(86, 0)] = TM[hook(76, 1)][hook(78, 0)] - TM[hook(76, 2)][hook(80, 0)] - TM[hook(76, 3)][hook(82, 0)];
      M[hook(85, 1)][hook(86, 1)] = TM[hook(76, 1)][hook(78, 1)] - TM[hook(76, 2)][hook(80, 1)] - TM[hook(76, 3)][hook(82, 1)];

      for (int i = 0; i < 2; ++i) {
        for (int j = 0; j < 2; ++j) {
          if (ok < K && preds[hook(27, i)][hook(26, j)]) {
            pO[hook(87, (i * Q + j) * N)] = M[hook(85, i)][hook(88, j)] + bias[hook(3, ok)];
          }
        }
      }
    }
  }
}