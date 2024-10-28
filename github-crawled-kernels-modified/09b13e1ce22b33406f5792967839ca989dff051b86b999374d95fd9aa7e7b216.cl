//{"A":3,"Areg":12,"Asub":9,"Asub[a_row]":13,"Asub[row]":8,"B":4,"Bsub":11,"Bsub[b_row]":14,"Bsub[row]":10,"C":5,"K":2,"M":0,"N":1,"accum":7,"accum[a_row]":15,"accum[row]":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SPGMM2(const int M, const int N, const int K, const global float* A, const global float* B, global float* C) {
  const int local_m = get_local_id(0);
  const int local_n = get_local_id(1);
  const int global_m = get_global_id(0);
  const int global_n = get_global_id(1);

  local float Asub[16][16];
  local float Bsub[16][16];

  float Areg[16];
  float Breg;
  float accum[16][16];

  for (int row = 0; row < 16; row++) {
    for (int col = 0; col < 16; col++) {
      accum[hook(7, row)][hook(6, col)] = 0.0f;
    }
  }

  const int n_tiles = K / 16;
  for (int t = 0; t < n_tiles; t++) {
    for (int row = 0; row < 16; row++) {
      for (int col = 0; col < 16; col++) {
        Asub[hook(9, row)][hook(8, col)] = A[hook(3, (global_m + local_m + row) * K + t * 16 + col)];
        Bsub[hook(11, row)][hook(10, col)] = B[hook(4, (global_n + local_n + row) * K + t * 16 + col)];
      }
    }

    barrier(0x01);
    for (int a_row = 0; a_row < 16; a_row++) {
      for (int col = 0; col < 16; col++) {
        Areg[hook(12, col)] = Asub[hook(9, a_row)][hook(13, col)];
      }

      for (int b_row = 0; b_row < 16; b_row++) {
        for (int col = 0; col < 16; col++) {
          Breg = Bsub[hook(11, b_row)][hook(14, col)];
          accum[hook(7, a_row)][hook(15, b_row)] += Breg * Areg[hook(12, col)];
        }
      }
    }
    barrier(0x01);
  }

  for (int row = 0; row < 16; row++) {
    for (int col = 0; col < 16; col++) {
      C[hook(5, (global_m + local_m + row) * N + global_n + local_n + col)] = accum[hook(7, row)][hook(6, col)];
    }
  }
}