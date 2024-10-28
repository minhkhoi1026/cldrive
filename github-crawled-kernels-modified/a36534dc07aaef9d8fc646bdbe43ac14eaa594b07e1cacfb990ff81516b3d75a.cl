//{"(plA + 0)":7,"(plA + 1032)":11,"(plA + 1064)":12,"(plA + 1096)":13,"(plA + 1128)":14,"(plA + 32)":8,"(plA + 64)":9,"(plA + 96)":10,"(plB + 0)":15,"(plB + 32)":16,"(plB + 520)":17,"(plB + 552)":18,"A":4,"ALPHA":3,"B":5,"C":6,"K":2,"M":0,"N":1,"lA":20,"lB":22,"rA":19,"rB":21,"rC":24,"rC[0]":23,"rC[1]":25,"rC[2]":26,"rC[3]":27,"rC[4]":28,"rC[5]":29,"rC[6]":30,"rC[7]":31}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(16, 16, 1))) kernel void sgemm_kernel(unsigned int M, unsigned int N, unsigned int K, float ALPHA, global float* A, global float* B, global float* C) {
  float rC[8][4] = {{(float)0}};
  float rA[8];
  float rB[4];

  local float lA[2064];
  local float lB[1040];

  unsigned int gidx = get_group_id(0);
  unsigned int gidy = get_group_id(1);
  unsigned int idx = get_local_id(0);
  unsigned int idy = get_local_id(1);

  unsigned int idt = 16 * idy + idx;
  unsigned int idxT = idt % 32;
  unsigned int idyT = idt / 32;

  A += (gidx * 128 + idxT) + idyT * M;
  B += (gidy * 64 + idxT) + idyT * N;

  for (unsigned int block_k = 0; block_k < K; block_k += 16) {
    local float* plA = lA + idyT * 129 + idxT;
    local float* plB = lB + idyT * 65 + idxT;

    barrier(0x01);

    (plA + 0)[hook(7, 0)] = A[hook(4, 0 * M + 0)];
    (plA + 32)[hook(8, 0)] = A[hook(4, 0 * M + 32)];
    (plA + 64)[hook(9, 0)] = A[hook(4, 0 * M + 64)];
    (plA + 96)[hook(10, 0)] = A[hook(4, 0 * M + 96)];
    (plA + 1032)[hook(11, 0)] = A[hook(4, 8 * M + 0)];
    (plA + 1064)[hook(12, 0)] = A[hook(4, 8 * M + 32)];
    (plA + 1096)[hook(13, 0)] = A[hook(4, 8 * M + 64)];
    (plA + 1128)[hook(14, 0)] = A[hook(4, 8 * M + 96)];
    (plB + 0)[hook(15, 0)] = B[hook(5, 0 * N + 0)];
    (plB + 32)[hook(16, 0)] = B[hook(5, 0 * N + 32)];
    (plB + 520)[hook(17, 0)] = B[hook(5, 8 * N + 0)];
    (plB + 552)[hook(18, 0)] = B[hook(5, 8 * N + 32)];

    barrier(0x01);

    unsigned int offA = 1 * idx;
    unsigned int offB = 1 * idy;
    for (unsigned int k = 0; k < 16; k += 1) {
      for (unsigned int mm = 0; mm < 8; mm++) {
        rA[hook(19, mm * 1 + 0)] = lA[hook(20, offA + mm * 16 + 0 + 0 * 129)];
      }

      for (unsigned int nn = 0; nn < 4; nn++) {
        rB[hook(21, nn * 1 + 0)] = lB[hook(22, offB + nn * 16 + 0 + 0 * 65)];
      }
      offA += 129;
      offB += 65;

      rC[hook(24, 0)][hook(23, 0)] = fma(rA[hook(19, 0)], rB[hook(21, 0)], rC[hook(24, 0)][hook(23, 0)]);
      rC[hook(24, 1)][hook(25, 0)] = fma(rA[hook(19, 1)], rB[hook(21, 0)], rC[hook(24, 1)][hook(25, 0)]);
      rC[hook(24, 2)][hook(26, 0)] = fma(rA[hook(19, 2)], rB[hook(21, 0)], rC[hook(24, 2)][hook(26, 0)]);
      rC[hook(24, 3)][hook(27, 0)] = fma(rA[hook(19, 3)], rB[hook(21, 0)], rC[hook(24, 3)][hook(27, 0)]);
      rC[hook(24, 4)][hook(28, 0)] = fma(rA[hook(19, 4)], rB[hook(21, 0)], rC[hook(24, 4)][hook(28, 0)]);
      rC[hook(24, 5)][hook(29, 0)] = fma(rA[hook(19, 5)], rB[hook(21, 0)], rC[hook(24, 5)][hook(29, 0)]);
      rC[hook(24, 6)][hook(30, 0)] = fma(rA[hook(19, 6)], rB[hook(21, 0)], rC[hook(24, 6)][hook(30, 0)]);
      rC[hook(24, 7)][hook(31, 0)] = fma(rA[hook(19, 7)], rB[hook(21, 0)], rC[hook(24, 7)][hook(31, 0)]);
      rC[hook(24, 0)][hook(23, 1)] = fma(rA[hook(19, 0)], rB[hook(21, 1)], rC[hook(24, 0)][hook(23, 1)]);
      rC[hook(24, 1)][hook(25, 1)] = fma(rA[hook(19, 1)], rB[hook(21, 1)], rC[hook(24, 1)][hook(25, 1)]);
      rC[hook(24, 2)][hook(26, 1)] = fma(rA[hook(19, 2)], rB[hook(21, 1)], rC[hook(24, 2)][hook(26, 1)]);
      rC[hook(24, 3)][hook(27, 1)] = fma(rA[hook(19, 3)], rB[hook(21, 1)], rC[hook(24, 3)][hook(27, 1)]);
      rC[hook(24, 4)][hook(28, 1)] = fma(rA[hook(19, 4)], rB[hook(21, 1)], rC[hook(24, 4)][hook(28, 1)]);
      rC[hook(24, 5)][hook(29, 1)] = fma(rA[hook(19, 5)], rB[hook(21, 1)], rC[hook(24, 5)][hook(29, 1)]);
      rC[hook(24, 6)][hook(30, 1)] = fma(rA[hook(19, 6)], rB[hook(21, 1)], rC[hook(24, 6)][hook(30, 1)]);
      rC[hook(24, 7)][hook(31, 1)] = fma(rA[hook(19, 7)], rB[hook(21, 1)], rC[hook(24, 7)][hook(31, 1)]);
      rC[hook(24, 0)][hook(23, 2)] = fma(rA[hook(19, 0)], rB[hook(21, 2)], rC[hook(24, 0)][hook(23, 2)]);
      rC[hook(24, 1)][hook(25, 2)] = fma(rA[hook(19, 1)], rB[hook(21, 2)], rC[hook(24, 1)][hook(25, 2)]);
      rC[hook(24, 2)][hook(26, 2)] = fma(rA[hook(19, 2)], rB[hook(21, 2)], rC[hook(24, 2)][hook(26, 2)]);
      rC[hook(24, 3)][hook(27, 2)] = fma(rA[hook(19, 3)], rB[hook(21, 2)], rC[hook(24, 3)][hook(27, 2)]);
      rC[hook(24, 4)][hook(28, 2)] = fma(rA[hook(19, 4)], rB[hook(21, 2)], rC[hook(24, 4)][hook(28, 2)]);
      rC[hook(24, 5)][hook(29, 2)] = fma(rA[hook(19, 5)], rB[hook(21, 2)], rC[hook(24, 5)][hook(29, 2)]);
      rC[hook(24, 6)][hook(30, 2)] = fma(rA[hook(19, 6)], rB[hook(21, 2)], rC[hook(24, 6)][hook(30, 2)]);
      rC[hook(24, 7)][hook(31, 2)] = fma(rA[hook(19, 7)], rB[hook(21, 2)], rC[hook(24, 7)][hook(31, 2)]);
      rC[hook(24, 0)][hook(23, 3)] = fma(rA[hook(19, 0)], rB[hook(21, 3)], rC[hook(24, 0)][hook(23, 3)]);
      rC[hook(24, 1)][hook(25, 3)] = fma(rA[hook(19, 1)], rB[hook(21, 3)], rC[hook(24, 1)][hook(25, 3)]);
      rC[hook(24, 2)][hook(26, 3)] = fma(rA[hook(19, 2)], rB[hook(21, 3)], rC[hook(24, 2)][hook(26, 3)]);
      rC[hook(24, 3)][hook(27, 3)] = fma(rA[hook(19, 3)], rB[hook(21, 3)], rC[hook(24, 3)][hook(27, 3)]);
      rC[hook(24, 4)][hook(28, 3)] = fma(rA[hook(19, 4)], rB[hook(21, 3)], rC[hook(24, 4)][hook(28, 3)]);
      rC[hook(24, 5)][hook(29, 3)] = fma(rA[hook(19, 5)], rB[hook(21, 3)], rC[hook(24, 5)][hook(29, 3)]);
      rC[hook(24, 6)][hook(30, 3)] = fma(rA[hook(19, 6)], rB[hook(21, 3)], rC[hook(24, 6)][hook(30, 3)]);
      rC[hook(24, 7)][hook(31, 3)] = fma(rA[hook(19, 7)], rB[hook(21, 3)], rC[hook(24, 7)][hook(31, 3)]);
    }
    A += 16 * M;
    B += 16 * N;
  }
  C += gidx * 128;
  C += idx;
  C += gidy * 64 * M;
  C += idy * M;

  C[hook(6, 0 * M)] = rC[hook(24, 0)][hook(23, 0)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(24, 0)][hook(23, 1)] * ALPHA;
  C[hook(6, 32 * M)] = rC[hook(24, 0)][hook(23, 2)] * ALPHA;
  C[hook(6, 48 * M)] = rC[hook(24, 0)][hook(23, 3)] * ALPHA;
  C += 16;
  C[hook(6, 0 * M)] = rC[hook(24, 1)][hook(25, 0)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(24, 1)][hook(25, 1)] * ALPHA;
  C[hook(6, 32 * M)] = rC[hook(24, 1)][hook(25, 2)] * ALPHA;
  C[hook(6, 48 * M)] = rC[hook(24, 1)][hook(25, 3)] * ALPHA;
  C += 16;
  C[hook(6, 0 * M)] = rC[hook(24, 2)][hook(26, 0)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(24, 2)][hook(26, 1)] * ALPHA;
  C[hook(6, 32 * M)] = rC[hook(24, 2)][hook(26, 2)] * ALPHA;
  C[hook(6, 48 * M)] = rC[hook(24, 2)][hook(26, 3)] * ALPHA;
  C += 16;
  C[hook(6, 0 * M)] = rC[hook(24, 3)][hook(27, 0)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(24, 3)][hook(27, 1)] * ALPHA;
  C[hook(6, 32 * M)] = rC[hook(24, 3)][hook(27, 2)] * ALPHA;
  C[hook(6, 48 * M)] = rC[hook(24, 3)][hook(27, 3)] * ALPHA;
  C += 16;
  C[hook(6, 0 * M)] = rC[hook(24, 4)][hook(28, 0)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(24, 4)][hook(28, 1)] * ALPHA;
  C[hook(6, 32 * M)] = rC[hook(24, 4)][hook(28, 2)] * ALPHA;
  C[hook(6, 48 * M)] = rC[hook(24, 4)][hook(28, 3)] * ALPHA;
  C += 16;
  C[hook(6, 0 * M)] = rC[hook(24, 5)][hook(29, 0)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(24, 5)][hook(29, 1)] * ALPHA;
  C[hook(6, 32 * M)] = rC[hook(24, 5)][hook(29, 2)] * ALPHA;
  C[hook(6, 48 * M)] = rC[hook(24, 5)][hook(29, 3)] * ALPHA;
  C += 16;
  C[hook(6, 0 * M)] = rC[hook(24, 6)][hook(30, 0)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(24, 6)][hook(30, 1)] * ALPHA;
  C[hook(6, 32 * M)] = rC[hook(24, 6)][hook(30, 2)] * ALPHA;
  C[hook(6, 48 * M)] = rC[hook(24, 6)][hook(30, 3)] * ALPHA;
  C += 16;
  C[hook(6, 0 * M)] = rC[hook(24, 7)][hook(31, 0)] * ALPHA;
  C[hook(6, 16 * M)] = rC[hook(24, 7)][hook(31, 1)] * ALPHA;
  C[hook(6, 32 * M)] = rC[hook(24, 7)][hook(31, 2)] * ALPHA;
  C[hook(6, 48 * M)] = rC[hook(24, 7)][hook(31, 3)] * ALPHA;
  C += 16;
}