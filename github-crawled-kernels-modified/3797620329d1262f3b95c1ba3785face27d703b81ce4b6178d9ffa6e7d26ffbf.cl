//{"A":3,"Asub":9,"Asub[r]":8,"Asub[row]":14,"B":4,"Breg":12,"Bsub":11,"Bsub[col]":13,"Bsub[r]":10,"C":5,"K":2,"M":0,"N":1,"acc":7,"acc[wm]":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SPGMM(const int M, const int N, const int K, const global float* A, const global float* B, global float* C) {
  const int tidm = get_local_id(0);
  const int tidn = get_local_id(1);
  const int offsetM = get_group_id(0) * 128;
  const int offsetN = get_group_id(1) * 128;

  local float Asub[128][16];
  local float Bsub[128][16 + 2];

  float Areg;
  float Breg[8];
  float acc[8][8];

  for (int wm = 0; wm < 8; wm++) {
    for (int wn = 0; wn < 8; wn++) {
      acc[hook(7, wm)][hook(6, wn)] = 0.0f;
    }
  }

  const int nTiles = K / 16;
  for (int t = 0; t < nTiles; t++) {
    for (int wm = 0; wm < 8; wm++) {
      int r = tidm + (128 / 8) * wm;

      for (int c = 0; c < 16; c++) {
        Asub[hook(9, r)][hook(8, c)] = A[hook(3, (offsetM + r) * K + 16 * t + c)];
        Bsub[hook(11, r)][hook(10, c)] = B[hook(4, (offsetN + r) * K + 16 * t + c)];
      }
    }

    barrier(0x01);

    for (int k = 0; k < 16; k++) {
      for (int wn = 0; wn < 8; wn++) {
        int col = tidn + wn * (128 / 8);
        Breg[hook(12, wn)] = Bsub[hook(11, col)][hook(13, k)];
      }

      for (int wm = 0; wm < 8; wm++) {
        int row = tidm + wm * (128 / 8);
        Areg = Asub[hook(9, row)][hook(14, k)];
        for (int wn = 0; wn < 8; wn++) {
          acc[hook(7, wm)][hook(6, wn)] += Areg * Breg[hook(12, wn)];
        }
      }
    }

    barrier(0x01);
  }

  for (int wm = 0; wm < 8; wm++) {
    int globalRow = offsetM + tidm + wm * (128 / 8);
    for (int wn = 0; wn < 8; wn++) {
      int globalCol = offsetN + tidn + wn * (128 / 8);
      C[hook(5, globalRow * N + globalCol)] = acc[hook(7, wm)][hook(6, wn)];
    }
  }
}