//{"(plA + 0)":7,"(plA + 16)":9,"(plA + 24)":10,"(plA + 8)":8,"(plB + 0)":11,"(plB + 16)":13,"(plB + 24)":14,"(plB + 8)":12,"A":4,"ALPHA":3,"B":5,"C":6,"K":2,"M":0,"N":1,"lA":17,"lB":20,"rA":16,"rA[kk]":15,"rB":19,"rB[kk]":18,"rC":22,"rC[0]":21,"rC[1]":23,"rC[2]":24,"rC[3]":25}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(8, 8, 1))) kernel void dgemm_kernel(unsigned int M, unsigned int N, unsigned int K, double ALPHA, global double* A, global double* B, global double* C) {
  double rC[4][4] = {{(double)0}};
  double rA[4][4];
  double rB[4][4];

  local double lA[264];
  local double lB[264];

  unsigned int gidx = get_group_id(0);
  unsigned int gidy = get_group_id(1);
  unsigned int idx = get_local_id(0);
  unsigned int idy = get_local_id(1);

  unsigned int idt = 8 * idy + idx;
  unsigned int idxT = idt % 8;
  unsigned int idyT = idt / 8;

  A += (gidx * 32 + idxT) + idyT * M;
  B += (gidy * 32 + idxT) + idyT * N;

  for (unsigned int block_k = 0; block_k < K; block_k += 8) {
    local double* plA = lA + idyT * 33 + idxT;
    local double* plB = lB + idyT * 33 + idxT;

    barrier(0x01);

    (plA + 0)[hook(7, 0)] = A[hook(4, 0)];
    (plA + 8)[hook(8, 0)] = A[hook(4, 8)];
    (plA + 16)[hook(9, 0)] = A[hook(4, 16)];
    (plA + 24)[hook(10, 0)] = A[hook(4, 24)];
    (plB + 0)[hook(11, 0)] = B[hook(5, 0)];
    (plB + 8)[hook(12, 0)] = B[hook(5, 8)];
    (plB + 16)[hook(13, 0)] = B[hook(5, 16)];
    (plB + 24)[hook(14, 0)] = B[hook(5, 24)];

    barrier(0x01);

    unsigned int offA = 1 * idx;
    unsigned int offB = 1 * idy;
    for (unsigned int k = 0; k < 8; k += 4) {
      for (unsigned int kk = 0; kk < 4; kk++) {
        for (unsigned int mm = 0; mm < 4; mm++) {
          rA[hook(16, kk)][hook(15, mm * 1 + 0)] = lA[hook(17, offA + mm * 8 + 0 + kk * 33)];
        }
      }

      for (unsigned int kk = 0; kk < 4; kk++) {
        for (unsigned int nn = 0; nn < 4; nn++) {
          rB[hook(19, kk)][hook(18, nn * 1 + 0)] = lB[hook(20, offB + nn * 8 + 0 + kk * 33)];
        }
      }
      offA += 132;
      offB += 132;

      for (unsigned int kk = 0; kk < 4; kk++) {
        rC[hook(22, 0)][hook(21, 0)] = fma(rA[hook(16, kk)][hook(15, 0)], rB[hook(19, kk)][hook(18, 0)], rC[hook(22, 0)][hook(21, 0)]);
        rC[hook(22, 1)][hook(23, 0)] = fma(rA[hook(16, kk)][hook(15, 1)], rB[hook(19, kk)][hook(18, 0)], rC[hook(22, 1)][hook(23, 0)]);
        rC[hook(22, 2)][hook(24, 0)] = fma(rA[hook(16, kk)][hook(15, 2)], rB[hook(19, kk)][hook(18, 0)], rC[hook(22, 2)][hook(24, 0)]);
        rC[hook(22, 3)][hook(25, 0)] = fma(rA[hook(16, kk)][hook(15, 3)], rB[hook(19, kk)][hook(18, 0)], rC[hook(22, 3)][hook(25, 0)]);

        rC[hook(22, 0)][hook(21, 1)] = fma(rA[hook(16, kk)][hook(15, 0)], rB[hook(19, kk)][hook(18, 1)], rC[hook(22, 0)][hook(21, 1)]);
        rC[hook(22, 1)][hook(23, 1)] = fma(rA[hook(16, kk)][hook(15, 1)], rB[hook(19, kk)][hook(18, 1)], rC[hook(22, 1)][hook(23, 1)]);
        rC[hook(22, 2)][hook(24, 1)] = fma(rA[hook(16, kk)][hook(15, 2)], rB[hook(19, kk)][hook(18, 1)], rC[hook(22, 2)][hook(24, 1)]);
        rC[hook(22, 3)][hook(25, 1)] = fma(rA[hook(16, kk)][hook(15, 3)], rB[hook(19, kk)][hook(18, 1)], rC[hook(22, 3)][hook(25, 1)]);

        rC[hook(22, 0)][hook(21, 2)] = fma(rA[hook(16, kk)][hook(15, 0)], rB[hook(19, kk)][hook(18, 2)], rC[hook(22, 0)][hook(21, 2)]);
        rC[hook(22, 1)][hook(23, 2)] = fma(rA[hook(16, kk)][hook(15, 1)], rB[hook(19, kk)][hook(18, 2)], rC[hook(22, 1)][hook(23, 2)]);
        rC[hook(22, 2)][hook(24, 2)] = fma(rA[hook(16, kk)][hook(15, 2)], rB[hook(19, kk)][hook(18, 2)], rC[hook(22, 2)][hook(24, 2)]);
        rC[hook(22, 3)][hook(25, 2)] = fma(rA[hook(16, kk)][hook(15, 3)], rB[hook(19, kk)][hook(18, 2)], rC[hook(22, 3)][hook(25, 2)]);

        rC[hook(22, 0)][hook(21, 3)] = fma(rA[hook(16, kk)][hook(15, 0)], rB[hook(19, kk)][hook(18, 3)], rC[hook(22, 0)][hook(21, 3)]);
        rC[hook(22, 1)][hook(23, 3)] = fma(rA[hook(16, kk)][hook(15, 1)], rB[hook(19, kk)][hook(18, 3)], rC[hook(22, 1)][hook(23, 3)]);
        rC[hook(22, 2)][hook(24, 3)] = fma(rA[hook(16, kk)][hook(15, 2)], rB[hook(19, kk)][hook(18, 3)], rC[hook(22, 2)][hook(24, 3)]);
        rC[hook(22, 3)][hook(25, 3)] = fma(rA[hook(16, kk)][hook(15, 3)], rB[hook(19, kk)][hook(18, 3)], rC[hook(22, 3)][hook(25, 3)]);
      }
    }
    A += 8 * M;
    B += 8 * N;
  }
  C += gidx * 32;
  C += idx;
  C += gidy * 32 * M;
  C += idy * M;

  C[hook(6, 0 * M)] = rC[hook(22, 0)][hook(21, 0)] * ALPHA;
  C[hook(6, 8 * M)] = rC[hook(22, 0)][hook(21, 1)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(22, 0)][hook(21, 2)] * ALPHA;
  C[hook(6, 24 * M)] = rC[hook(22, 0)][hook(21, 3)] * ALPHA;
  C += 8;

  C[hook(6, 0 * M)] = rC[hook(22, 1)][hook(23, 0)] * ALPHA;
  C[hook(6, 8 * M)] = rC[hook(22, 1)][hook(23, 1)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(22, 1)][hook(23, 2)] * ALPHA;
  C[hook(6, 24 * M)] = rC[hook(22, 1)][hook(23, 3)] * ALPHA;
  C += 8;

  C[hook(6, 0 * M)] = rC[hook(22, 2)][hook(24, 0)] * ALPHA;
  C[hook(6, 8 * M)] = rC[hook(22, 2)][hook(24, 1)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(22, 2)][hook(24, 2)] * ALPHA;
  C[hook(6, 24 * M)] = rC[hook(22, 2)][hook(24, 3)] * ALPHA;
  C += 8;

  C[hook(6, 0 * M)] = rC[hook(22, 3)][hook(25, 0)] * ALPHA;
  C[hook(6, 8 * M)] = rC[hook(22, 3)][hook(25, 1)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(22, 3)][hook(25, 2)] * ALPHA;
  C[hook(6, 24 * M)] = rC[hook(22, 3)][hook(25, 3)] * ALPHA;
  C += 8;
}