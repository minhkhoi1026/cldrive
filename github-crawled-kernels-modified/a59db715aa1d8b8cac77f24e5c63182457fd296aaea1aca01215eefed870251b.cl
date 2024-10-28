//{"(plA + 0)":7,"(plA + 1032)":11,"(plA + 1064)":12,"(plA + 1096)":13,"(plA + 1128)":14,"(plA + 32)":8,"(plA + 64)":9,"(plA + 96)":10,"(plB + 0)":15,"(plB + 32)":16,"(plB + 520)":17,"(plB + 552)":18,"A":4,"ALPHA":3,"B":5,"C":6,"K":2,"M":0,"N":1,"lA":20,"lB":22,"rA":19,"rB":21,"rC":24,"rC[0]":23,"rC[1]":25,"rC[2]":26,"rC[3]":27,"rC[4]":28,"rC[5]":29,"rC[6]":30,"rC[7]":31}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) kernel void cgemm_kernel(unsigned int M, unsigned int N, unsigned int K, float2 ALPHA, global float2* A, global float2* B, global float2* C) {
  float2 rC[8][4] = {{0}};
  float2 rA[8];
  float2 rB[4];

  local float2 lA[2064];
  local float2 lB[1040];

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
    local float2* plA = lA + idyT * 129 + idxT;
    local float2* plB = lB + idyT * 65 + idxT;

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

      rC[hook(24, 0)][hook(23, 0)].s0 = fma(rA[hook(19, 0)].s0, rB[hook(21, 0)].s0, rC[hook(24, 0)][hook(23, 0)].s0);
      rC[hook(24, 1)][hook(25, 0)].s0 = fma(rA[hook(19, 1)].s0, rB[hook(21, 0)].s0, rC[hook(24, 1)][hook(25, 0)].s0);
      rC[hook(24, 2)][hook(26, 0)].s0 = fma(rA[hook(19, 2)].s0, rB[hook(21, 0)].s0, rC[hook(24, 2)][hook(26, 0)].s0);
      rC[hook(24, 3)][hook(27, 0)].s0 = fma(rA[hook(19, 3)].s0, rB[hook(21, 0)].s0, rC[hook(24, 3)][hook(27, 0)].s0);
      rC[hook(24, 4)][hook(28, 0)].s0 = fma(rA[hook(19, 4)].s0, rB[hook(21, 0)].s0, rC[hook(24, 4)][hook(28, 0)].s0);
      rC[hook(24, 5)][hook(29, 0)].s0 = fma(rA[hook(19, 5)].s0, rB[hook(21, 0)].s0, rC[hook(24, 5)][hook(29, 0)].s0);
      rC[hook(24, 6)][hook(30, 0)].s0 = fma(rA[hook(19, 6)].s0, rB[hook(21, 0)].s0, rC[hook(24, 6)][hook(30, 0)].s0);
      rC[hook(24, 7)][hook(31, 0)].s0 = fma(rA[hook(19, 7)].s0, rB[hook(21, 0)].s0, rC[hook(24, 7)][hook(31, 0)].s0);
      rC[hook(24, 0)][hook(23, 1)].s0 = fma(rA[hook(19, 0)].s0, rB[hook(21, 1)].s0, rC[hook(24, 0)][hook(23, 1)].s0);
      rC[hook(24, 1)][hook(25, 1)].s0 = fma(rA[hook(19, 1)].s0, rB[hook(21, 1)].s0, rC[hook(24, 1)][hook(25, 1)].s0);
      rC[hook(24, 2)][hook(26, 1)].s0 = fma(rA[hook(19, 2)].s0, rB[hook(21, 1)].s0, rC[hook(24, 2)][hook(26, 1)].s0);
      rC[hook(24, 3)][hook(27, 1)].s0 = fma(rA[hook(19, 3)].s0, rB[hook(21, 1)].s0, rC[hook(24, 3)][hook(27, 1)].s0);
      rC[hook(24, 4)][hook(28, 1)].s0 = fma(rA[hook(19, 4)].s0, rB[hook(21, 1)].s0, rC[hook(24, 4)][hook(28, 1)].s0);
      rC[hook(24, 5)][hook(29, 1)].s0 = fma(rA[hook(19, 5)].s0, rB[hook(21, 1)].s0, rC[hook(24, 5)][hook(29, 1)].s0);
      rC[hook(24, 6)][hook(30, 1)].s0 = fma(rA[hook(19, 6)].s0, rB[hook(21, 1)].s0, rC[hook(24, 6)][hook(30, 1)].s0);
      rC[hook(24, 7)][hook(31, 1)].s0 = fma(rA[hook(19, 7)].s0, rB[hook(21, 1)].s0, rC[hook(24, 7)][hook(31, 1)].s0);
      rC[hook(24, 0)][hook(23, 2)].s0 = fma(rA[hook(19, 0)].s0, rB[hook(21, 2)].s0, rC[hook(24, 0)][hook(23, 2)].s0);
      rC[hook(24, 1)][hook(25, 2)].s0 = fma(rA[hook(19, 1)].s0, rB[hook(21, 2)].s0, rC[hook(24, 1)][hook(25, 2)].s0);
      rC[hook(24, 2)][hook(26, 2)].s0 = fma(rA[hook(19, 2)].s0, rB[hook(21, 2)].s0, rC[hook(24, 2)][hook(26, 2)].s0);
      rC[hook(24, 3)][hook(27, 2)].s0 = fma(rA[hook(19, 3)].s0, rB[hook(21, 2)].s0, rC[hook(24, 3)][hook(27, 2)].s0);
      rC[hook(24, 4)][hook(28, 2)].s0 = fma(rA[hook(19, 4)].s0, rB[hook(21, 2)].s0, rC[hook(24, 4)][hook(28, 2)].s0);
      rC[hook(24, 5)][hook(29, 2)].s0 = fma(rA[hook(19, 5)].s0, rB[hook(21, 2)].s0, rC[hook(24, 5)][hook(29, 2)].s0);
      rC[hook(24, 6)][hook(30, 2)].s0 = fma(rA[hook(19, 6)].s0, rB[hook(21, 2)].s0, rC[hook(24, 6)][hook(30, 2)].s0);
      rC[hook(24, 7)][hook(31, 2)].s0 = fma(rA[hook(19, 7)].s0, rB[hook(21, 2)].s0, rC[hook(24, 7)][hook(31, 2)].s0);
      rC[hook(24, 0)][hook(23, 3)].s0 = fma(rA[hook(19, 0)].s0, rB[hook(21, 3)].s0, rC[hook(24, 0)][hook(23, 3)].s0);
      rC[hook(24, 1)][hook(25, 3)].s0 = fma(rA[hook(19, 1)].s0, rB[hook(21, 3)].s0, rC[hook(24, 1)][hook(25, 3)].s0);
      rC[hook(24, 2)][hook(26, 3)].s0 = fma(rA[hook(19, 2)].s0, rB[hook(21, 3)].s0, rC[hook(24, 2)][hook(26, 3)].s0);
      rC[hook(24, 3)][hook(27, 3)].s0 = fma(rA[hook(19, 3)].s0, rB[hook(21, 3)].s0, rC[hook(24, 3)][hook(27, 3)].s0);
      rC[hook(24, 4)][hook(28, 3)].s0 = fma(rA[hook(19, 4)].s0, rB[hook(21, 3)].s0, rC[hook(24, 4)][hook(28, 3)].s0);
      rC[hook(24, 5)][hook(29, 3)].s0 = fma(rA[hook(19, 5)].s0, rB[hook(21, 3)].s0, rC[hook(24, 5)][hook(29, 3)].s0);
      rC[hook(24, 6)][hook(30, 3)].s0 = fma(rA[hook(19, 6)].s0, rB[hook(21, 3)].s0, rC[hook(24, 6)][hook(30, 3)].s0);
      rC[hook(24, 7)][hook(31, 3)].s0 = fma(rA[hook(19, 7)].s0, rB[hook(21, 3)].s0, rC[hook(24, 7)][hook(31, 3)].s0);

      rC[hook(24, 0)][hook(23, 0)].s0 = fma(-rA[hook(19, 0)].s1, rB[hook(21, 0)].s1, rC[hook(24, 0)][hook(23, 0)].s0);
      rC[hook(24, 1)][hook(25, 0)].s0 = fma(-rA[hook(19, 1)].s1, rB[hook(21, 0)].s1, rC[hook(24, 1)][hook(25, 0)].s0);
      rC[hook(24, 2)][hook(26, 0)].s0 = fma(-rA[hook(19, 2)].s1, rB[hook(21, 0)].s1, rC[hook(24, 2)][hook(26, 0)].s0);
      rC[hook(24, 3)][hook(27, 0)].s0 = fma(-rA[hook(19, 3)].s1, rB[hook(21, 0)].s1, rC[hook(24, 3)][hook(27, 0)].s0);
      rC[hook(24, 4)][hook(28, 0)].s0 = fma(-rA[hook(19, 4)].s1, rB[hook(21, 0)].s1, rC[hook(24, 4)][hook(28, 0)].s0);
      rC[hook(24, 5)][hook(29, 0)].s0 = fma(-rA[hook(19, 5)].s1, rB[hook(21, 0)].s1, rC[hook(24, 5)][hook(29, 0)].s0);
      rC[hook(24, 6)][hook(30, 0)].s0 = fma(-rA[hook(19, 6)].s1, rB[hook(21, 0)].s1, rC[hook(24, 6)][hook(30, 0)].s0);
      rC[hook(24, 7)][hook(31, 0)].s0 = fma(-rA[hook(19, 7)].s1, rB[hook(21, 0)].s1, rC[hook(24, 7)][hook(31, 0)].s0);
      rC[hook(24, 0)][hook(23, 1)].s0 = fma(-rA[hook(19, 0)].s1, rB[hook(21, 1)].s1, rC[hook(24, 0)][hook(23, 1)].s0);
      rC[hook(24, 1)][hook(25, 1)].s0 = fma(-rA[hook(19, 1)].s1, rB[hook(21, 1)].s1, rC[hook(24, 1)][hook(25, 1)].s0);
      rC[hook(24, 2)][hook(26, 1)].s0 = fma(-rA[hook(19, 2)].s1, rB[hook(21, 1)].s1, rC[hook(24, 2)][hook(26, 1)].s0);
      rC[hook(24, 3)][hook(27, 1)].s0 = fma(-rA[hook(19, 3)].s1, rB[hook(21, 1)].s1, rC[hook(24, 3)][hook(27, 1)].s0);
      rC[hook(24, 4)][hook(28, 1)].s0 = fma(-rA[hook(19, 4)].s1, rB[hook(21, 1)].s1, rC[hook(24, 4)][hook(28, 1)].s0);
      rC[hook(24, 5)][hook(29, 1)].s0 = fma(-rA[hook(19, 5)].s1, rB[hook(21, 1)].s1, rC[hook(24, 5)][hook(29, 1)].s0);
      rC[hook(24, 6)][hook(30, 1)].s0 = fma(-rA[hook(19, 6)].s1, rB[hook(21, 1)].s1, rC[hook(24, 6)][hook(30, 1)].s0);
      rC[hook(24, 7)][hook(31, 1)].s0 = fma(-rA[hook(19, 7)].s1, rB[hook(21, 1)].s1, rC[hook(24, 7)][hook(31, 1)].s0);
      rC[hook(24, 0)][hook(23, 2)].s0 = fma(-rA[hook(19, 0)].s1, rB[hook(21, 2)].s1, rC[hook(24, 0)][hook(23, 2)].s0);
      rC[hook(24, 1)][hook(25, 2)].s0 = fma(-rA[hook(19, 1)].s1, rB[hook(21, 2)].s1, rC[hook(24, 1)][hook(25, 2)].s0);
      rC[hook(24, 2)][hook(26, 2)].s0 = fma(-rA[hook(19, 2)].s1, rB[hook(21, 2)].s1, rC[hook(24, 2)][hook(26, 2)].s0);
      rC[hook(24, 3)][hook(27, 2)].s0 = fma(-rA[hook(19, 3)].s1, rB[hook(21, 2)].s1, rC[hook(24, 3)][hook(27, 2)].s0);
      rC[hook(24, 4)][hook(28, 2)].s0 = fma(-rA[hook(19, 4)].s1, rB[hook(21, 2)].s1, rC[hook(24, 4)][hook(28, 2)].s0);
      rC[hook(24, 5)][hook(29, 2)].s0 = fma(-rA[hook(19, 5)].s1, rB[hook(21, 2)].s1, rC[hook(24, 5)][hook(29, 2)].s0);
      rC[hook(24, 6)][hook(30, 2)].s0 = fma(-rA[hook(19, 6)].s1, rB[hook(21, 2)].s1, rC[hook(24, 6)][hook(30, 2)].s0);
      rC[hook(24, 7)][hook(31, 2)].s0 = fma(-rA[hook(19, 7)].s1, rB[hook(21, 2)].s1, rC[hook(24, 7)][hook(31, 2)].s0);
      rC[hook(24, 0)][hook(23, 3)].s0 = fma(-rA[hook(19, 0)].s1, rB[hook(21, 3)].s1, rC[hook(24, 0)][hook(23, 3)].s0);
      rC[hook(24, 1)][hook(25, 3)].s0 = fma(-rA[hook(19, 1)].s1, rB[hook(21, 3)].s1, rC[hook(24, 1)][hook(25, 3)].s0);
      rC[hook(24, 2)][hook(26, 3)].s0 = fma(-rA[hook(19, 2)].s1, rB[hook(21, 3)].s1, rC[hook(24, 2)][hook(26, 3)].s0);
      rC[hook(24, 3)][hook(27, 3)].s0 = fma(-rA[hook(19, 3)].s1, rB[hook(21, 3)].s1, rC[hook(24, 3)][hook(27, 3)].s0);
      rC[hook(24, 4)][hook(28, 3)].s0 = fma(-rA[hook(19, 4)].s1, rB[hook(21, 3)].s1, rC[hook(24, 4)][hook(28, 3)].s0);
      rC[hook(24, 5)][hook(29, 3)].s0 = fma(-rA[hook(19, 5)].s1, rB[hook(21, 3)].s1, rC[hook(24, 5)][hook(29, 3)].s0);
      rC[hook(24, 6)][hook(30, 3)].s0 = fma(-rA[hook(19, 6)].s1, rB[hook(21, 3)].s1, rC[hook(24, 6)][hook(30, 3)].s0);
      rC[hook(24, 7)][hook(31, 3)].s0 = fma(-rA[hook(19, 7)].s1, rB[hook(21, 3)].s1, rC[hook(24, 7)][hook(31, 3)].s0);

      rC[hook(24, 0)][hook(23, 0)].s1 = fma(rA[hook(19, 0)].s1, rB[hook(21, 0)].s0, rC[hook(24, 0)][hook(23, 0)].s1);
      rC[hook(24, 1)][hook(25, 0)].s1 = fma(rA[hook(19, 1)].s1, rB[hook(21, 0)].s0, rC[hook(24, 1)][hook(25, 0)].s1);
      rC[hook(24, 2)][hook(26, 0)].s1 = fma(rA[hook(19, 2)].s1, rB[hook(21, 0)].s0, rC[hook(24, 2)][hook(26, 0)].s1);
      rC[hook(24, 3)][hook(27, 0)].s1 = fma(rA[hook(19, 3)].s1, rB[hook(21, 0)].s0, rC[hook(24, 3)][hook(27, 0)].s1);
      rC[hook(24, 4)][hook(28, 0)].s1 = fma(rA[hook(19, 4)].s1, rB[hook(21, 0)].s0, rC[hook(24, 4)][hook(28, 0)].s1);
      rC[hook(24, 5)][hook(29, 0)].s1 = fma(rA[hook(19, 5)].s1, rB[hook(21, 0)].s0, rC[hook(24, 5)][hook(29, 0)].s1);
      rC[hook(24, 6)][hook(30, 0)].s1 = fma(rA[hook(19, 6)].s1, rB[hook(21, 0)].s0, rC[hook(24, 6)][hook(30, 0)].s1);
      rC[hook(24, 7)][hook(31, 0)].s1 = fma(rA[hook(19, 7)].s1, rB[hook(21, 0)].s0, rC[hook(24, 7)][hook(31, 0)].s1);
      rC[hook(24, 0)][hook(23, 1)].s1 = fma(rA[hook(19, 0)].s1, rB[hook(21, 1)].s0, rC[hook(24, 0)][hook(23, 1)].s1);
      rC[hook(24, 1)][hook(25, 1)].s1 = fma(rA[hook(19, 1)].s1, rB[hook(21, 1)].s0, rC[hook(24, 1)][hook(25, 1)].s1);
      rC[hook(24, 2)][hook(26, 1)].s1 = fma(rA[hook(19, 2)].s1, rB[hook(21, 1)].s0, rC[hook(24, 2)][hook(26, 1)].s1);
      rC[hook(24, 3)][hook(27, 1)].s1 = fma(rA[hook(19, 3)].s1, rB[hook(21, 1)].s0, rC[hook(24, 3)][hook(27, 1)].s1);
      rC[hook(24, 4)][hook(28, 1)].s1 = fma(rA[hook(19, 4)].s1, rB[hook(21, 1)].s0, rC[hook(24, 4)][hook(28, 1)].s1);
      rC[hook(24, 5)][hook(29, 1)].s1 = fma(rA[hook(19, 5)].s1, rB[hook(21, 1)].s0, rC[hook(24, 5)][hook(29, 1)].s1);
      rC[hook(24, 6)][hook(30, 1)].s1 = fma(rA[hook(19, 6)].s1, rB[hook(21, 1)].s0, rC[hook(24, 6)][hook(30, 1)].s1);
      rC[hook(24, 7)][hook(31, 1)].s1 = fma(rA[hook(19, 7)].s1, rB[hook(21, 1)].s0, rC[hook(24, 7)][hook(31, 1)].s1);
      rC[hook(24, 0)][hook(23, 2)].s1 = fma(rA[hook(19, 0)].s1, rB[hook(21, 2)].s0, rC[hook(24, 0)][hook(23, 2)].s1);
      rC[hook(24, 1)][hook(25, 2)].s1 = fma(rA[hook(19, 1)].s1, rB[hook(21, 2)].s0, rC[hook(24, 1)][hook(25, 2)].s1);
      rC[hook(24, 2)][hook(26, 2)].s1 = fma(rA[hook(19, 2)].s1, rB[hook(21, 2)].s0, rC[hook(24, 2)][hook(26, 2)].s1);
      rC[hook(24, 3)][hook(27, 2)].s1 = fma(rA[hook(19, 3)].s1, rB[hook(21, 2)].s0, rC[hook(24, 3)][hook(27, 2)].s1);
      rC[hook(24, 4)][hook(28, 2)].s1 = fma(rA[hook(19, 4)].s1, rB[hook(21, 2)].s0, rC[hook(24, 4)][hook(28, 2)].s1);
      rC[hook(24, 5)][hook(29, 2)].s1 = fma(rA[hook(19, 5)].s1, rB[hook(21, 2)].s0, rC[hook(24, 5)][hook(29, 2)].s1);
      rC[hook(24, 6)][hook(30, 2)].s1 = fma(rA[hook(19, 6)].s1, rB[hook(21, 2)].s0, rC[hook(24, 6)][hook(30, 2)].s1);
      rC[hook(24, 7)][hook(31, 2)].s1 = fma(rA[hook(19, 7)].s1, rB[hook(21, 2)].s0, rC[hook(24, 7)][hook(31, 2)].s1);
      rC[hook(24, 0)][hook(23, 3)].s1 = fma(rA[hook(19, 0)].s1, rB[hook(21, 3)].s0, rC[hook(24, 0)][hook(23, 3)].s1);
      rC[hook(24, 1)][hook(25, 3)].s1 = fma(rA[hook(19, 1)].s1, rB[hook(21, 3)].s0, rC[hook(24, 1)][hook(25, 3)].s1);
      rC[hook(24, 2)][hook(26, 3)].s1 = fma(rA[hook(19, 2)].s1, rB[hook(21, 3)].s0, rC[hook(24, 2)][hook(26, 3)].s1);
      rC[hook(24, 3)][hook(27, 3)].s1 = fma(rA[hook(19, 3)].s1, rB[hook(21, 3)].s0, rC[hook(24, 3)][hook(27, 3)].s1);
      rC[hook(24, 4)][hook(28, 3)].s1 = fma(rA[hook(19, 4)].s1, rB[hook(21, 3)].s0, rC[hook(24, 4)][hook(28, 3)].s1);
      rC[hook(24, 5)][hook(29, 3)].s1 = fma(rA[hook(19, 5)].s1, rB[hook(21, 3)].s0, rC[hook(24, 5)][hook(29, 3)].s1);
      rC[hook(24, 6)][hook(30, 3)].s1 = fma(rA[hook(19, 6)].s1, rB[hook(21, 3)].s0, rC[hook(24, 6)][hook(30, 3)].s1);
      rC[hook(24, 7)][hook(31, 3)].s1 = fma(rA[hook(19, 7)].s1, rB[hook(21, 3)].s0, rC[hook(24, 7)][hook(31, 3)].s1);

      rC[hook(24, 0)][hook(23, 0)].s1 = fma(rA[hook(19, 0)].s0, rB[hook(21, 0)].s1, rC[hook(24, 0)][hook(23, 0)].s1);
      rC[hook(24, 1)][hook(25, 0)].s1 = fma(rA[hook(19, 1)].s0, rB[hook(21, 0)].s1, rC[hook(24, 1)][hook(25, 0)].s1);
      rC[hook(24, 2)][hook(26, 0)].s1 = fma(rA[hook(19, 2)].s0, rB[hook(21, 0)].s1, rC[hook(24, 2)][hook(26, 0)].s1);
      rC[hook(24, 3)][hook(27, 0)].s1 = fma(rA[hook(19, 3)].s0, rB[hook(21, 0)].s1, rC[hook(24, 3)][hook(27, 0)].s1);
      rC[hook(24, 4)][hook(28, 0)].s1 = fma(rA[hook(19, 4)].s0, rB[hook(21, 0)].s1, rC[hook(24, 4)][hook(28, 0)].s1);
      rC[hook(24, 5)][hook(29, 0)].s1 = fma(rA[hook(19, 5)].s0, rB[hook(21, 0)].s1, rC[hook(24, 5)][hook(29, 0)].s1);
      rC[hook(24, 6)][hook(30, 0)].s1 = fma(rA[hook(19, 6)].s0, rB[hook(21, 0)].s1, rC[hook(24, 6)][hook(30, 0)].s1);
      rC[hook(24, 7)][hook(31, 0)].s1 = fma(rA[hook(19, 7)].s0, rB[hook(21, 0)].s1, rC[hook(24, 7)][hook(31, 0)].s1);
      rC[hook(24, 0)][hook(23, 1)].s1 = fma(rA[hook(19, 0)].s0, rB[hook(21, 1)].s1, rC[hook(24, 0)][hook(23, 1)].s1);
      rC[hook(24, 1)][hook(25, 1)].s1 = fma(rA[hook(19, 1)].s0, rB[hook(21, 1)].s1, rC[hook(24, 1)][hook(25, 1)].s1);
      rC[hook(24, 2)][hook(26, 1)].s1 = fma(rA[hook(19, 2)].s0, rB[hook(21, 1)].s1, rC[hook(24, 2)][hook(26, 1)].s1);
      rC[hook(24, 3)][hook(27, 1)].s1 = fma(rA[hook(19, 3)].s0, rB[hook(21, 1)].s1, rC[hook(24, 3)][hook(27, 1)].s1);
      rC[hook(24, 4)][hook(28, 1)].s1 = fma(rA[hook(19, 4)].s0, rB[hook(21, 1)].s1, rC[hook(24, 4)][hook(28, 1)].s1);
      rC[hook(24, 5)][hook(29, 1)].s1 = fma(rA[hook(19, 5)].s0, rB[hook(21, 1)].s1, rC[hook(24, 5)][hook(29, 1)].s1);
      rC[hook(24, 6)][hook(30, 1)].s1 = fma(rA[hook(19, 6)].s0, rB[hook(21, 1)].s1, rC[hook(24, 6)][hook(30, 1)].s1);
      rC[hook(24, 7)][hook(31, 1)].s1 = fma(rA[hook(19, 7)].s0, rB[hook(21, 1)].s1, rC[hook(24, 7)][hook(31, 1)].s1);
      rC[hook(24, 0)][hook(23, 2)].s1 = fma(rA[hook(19, 0)].s0, rB[hook(21, 2)].s1, rC[hook(24, 0)][hook(23, 2)].s1);
      rC[hook(24, 1)][hook(25, 2)].s1 = fma(rA[hook(19, 1)].s0, rB[hook(21, 2)].s1, rC[hook(24, 1)][hook(25, 2)].s1);
      rC[hook(24, 2)][hook(26, 2)].s1 = fma(rA[hook(19, 2)].s0, rB[hook(21, 2)].s1, rC[hook(24, 2)][hook(26, 2)].s1);
      rC[hook(24, 3)][hook(27, 2)].s1 = fma(rA[hook(19, 3)].s0, rB[hook(21, 2)].s1, rC[hook(24, 3)][hook(27, 2)].s1);
      rC[hook(24, 4)][hook(28, 2)].s1 = fma(rA[hook(19, 4)].s0, rB[hook(21, 2)].s1, rC[hook(24, 4)][hook(28, 2)].s1);
      rC[hook(24, 5)][hook(29, 2)].s1 = fma(rA[hook(19, 5)].s0, rB[hook(21, 2)].s1, rC[hook(24, 5)][hook(29, 2)].s1);
      rC[hook(24, 6)][hook(30, 2)].s1 = fma(rA[hook(19, 6)].s0, rB[hook(21, 2)].s1, rC[hook(24, 6)][hook(30, 2)].s1);
      rC[hook(24, 7)][hook(31, 2)].s1 = fma(rA[hook(19, 7)].s0, rB[hook(21, 2)].s1, rC[hook(24, 7)][hook(31, 2)].s1);
      rC[hook(24, 0)][hook(23, 3)].s1 = fma(rA[hook(19, 0)].s0, rB[hook(21, 3)].s1, rC[hook(24, 0)][hook(23, 3)].s1);
      rC[hook(24, 1)][hook(25, 3)].s1 = fma(rA[hook(19, 1)].s0, rB[hook(21, 3)].s1, rC[hook(24, 1)][hook(25, 3)].s1);
      rC[hook(24, 2)][hook(26, 3)].s1 = fma(rA[hook(19, 2)].s0, rB[hook(21, 3)].s1, rC[hook(24, 2)][hook(26, 3)].s1);
      rC[hook(24, 3)][hook(27, 3)].s1 = fma(rA[hook(19, 3)].s0, rB[hook(21, 3)].s1, rC[hook(24, 3)][hook(27, 3)].s1);
      rC[hook(24, 4)][hook(28, 3)].s1 = fma(rA[hook(19, 4)].s0, rB[hook(21, 3)].s1, rC[hook(24, 4)][hook(28, 3)].s1);
      rC[hook(24, 5)][hook(29, 3)].s1 = fma(rA[hook(19, 5)].s0, rB[hook(21, 3)].s1, rC[hook(24, 5)][hook(29, 3)].s1);
      rC[hook(24, 6)][hook(30, 3)].s1 = fma(rA[hook(19, 6)].s0, rB[hook(21, 3)].s1, rC[hook(24, 6)][hook(30, 3)].s1);
      rC[hook(24, 7)][hook(31, 3)].s1 = fma(rA[hook(19, 7)].s0, rB[hook(21, 3)].s1, rC[hook(24, 7)][hook(31, 3)].s1);
    }
    A += 16 * M;
    B += 16 * N;
  }
  C += gidx * 128;
  C += idx;
  C += gidy * 64 * M;
  C += idy * M;

  C[hook(6, 0 * M)].s0 = rC[hook(24, 0)][hook(23, 0)].s0 * ALPHA.s0 - rC[hook(24, 0)][hook(23, 0)].s1 * ALPHA.s1;
  C[hook(6, 0 * M)].s1 = rC[hook(24, 0)][hook(23, 0)].s0 * ALPHA.s1 + rC[hook(24, 0)][hook(23, 0)].s1 * ALPHA.s0;
  C[hook(6, 16 * M)].s0 = rC[hook(24, 0)][hook(23, 1)].s0 * ALPHA.s0 - rC[hook(24, 0)][hook(23, 1)].s1 * ALPHA.s1;
  C[hook(6, 16 * M)].s1 = rC[hook(24, 0)][hook(23, 1)].s0 * ALPHA.s1 + rC[hook(24, 0)][hook(23, 1)].s1 * ALPHA.s0;
  C[hook(6, 32 * M)].s0 = rC[hook(24, 0)][hook(23, 2)].s0 * ALPHA.s0 - rC[hook(24, 0)][hook(23, 2)].s1 * ALPHA.s1;
  C[hook(6, 32 * M)].s1 = rC[hook(24, 0)][hook(23, 2)].s0 * ALPHA.s1 + rC[hook(24, 0)][hook(23, 2)].s1 * ALPHA.s0;
  C[hook(6, 48 * M)].s0 = rC[hook(24, 0)][hook(23, 3)].s0 * ALPHA.s0 - rC[hook(24, 0)][hook(23, 3)].s1 * ALPHA.s1;
  C[hook(6, 48 * M)].s1 = rC[hook(24, 0)][hook(23, 3)].s0 * ALPHA.s1 + rC[hook(24, 0)][hook(23, 3)].s1 * ALPHA.s0;
  C += 16;

  C[hook(6, 0 * M)].s0 = rC[hook(24, 1)][hook(25, 0)].s0 * ALPHA.s0 - rC[hook(24, 1)][hook(25, 0)].s1 * ALPHA.s1;
  C[hook(6, 0 * M)].s1 = rC[hook(24, 1)][hook(25, 0)].s0 * ALPHA.s1 + rC[hook(24, 1)][hook(25, 0)].s1 * ALPHA.s0;
  C[hook(6, 16 * M)].s0 = rC[hook(24, 1)][hook(25, 1)].s0 * ALPHA.s0 - rC[hook(24, 1)][hook(25, 1)].s1 * ALPHA.s1;
  C[hook(6, 16 * M)].s1 = rC[hook(24, 1)][hook(25, 1)].s0 * ALPHA.s1 + rC[hook(24, 1)][hook(25, 1)].s1 * ALPHA.s0;
  C[hook(6, 32 * M)].s0 = rC[hook(24, 1)][hook(25, 2)].s0 * ALPHA.s0 - rC[hook(24, 1)][hook(25, 2)].s1 * ALPHA.s1;
  C[hook(6, 32 * M)].s1 = rC[hook(24, 1)][hook(25, 2)].s0 * ALPHA.s1 + rC[hook(24, 1)][hook(25, 2)].s1 * ALPHA.s0;
  C[hook(6, 48 * M)].s0 = rC[hook(24, 1)][hook(25, 3)].s0 * ALPHA.s0 - rC[hook(24, 1)][hook(25, 3)].s1 * ALPHA.s1;
  C[hook(6, 48 * M)].s1 = rC[hook(24, 1)][hook(25, 3)].s0 * ALPHA.s1 + rC[hook(24, 1)][hook(25, 3)].s1 * ALPHA.s0;
  C += 16;

  C[hook(6, 0 * M)].s0 = rC[hook(24, 2)][hook(26, 0)].s0 * ALPHA.s0 - rC[hook(24, 2)][hook(26, 0)].s1 * ALPHA.s1;
  C[hook(6, 0 * M)].s1 = rC[hook(24, 2)][hook(26, 0)].s0 * ALPHA.s1 + rC[hook(24, 2)][hook(26, 0)].s1 * ALPHA.s0;
  C[hook(6, 16 * M)].s0 = rC[hook(24, 2)][hook(26, 1)].s0 * ALPHA.s0 - rC[hook(24, 2)][hook(26, 1)].s1 * ALPHA.s1;
  C[hook(6, 16 * M)].s1 = rC[hook(24, 2)][hook(26, 1)].s0 * ALPHA.s1 + rC[hook(24, 2)][hook(26, 1)].s1 * ALPHA.s0;
  C[hook(6, 32 * M)].s0 = rC[hook(24, 2)][hook(26, 2)].s0 * ALPHA.s0 - rC[hook(24, 2)][hook(26, 2)].s1 * ALPHA.s1;
  C[hook(6, 32 * M)].s1 = rC[hook(24, 2)][hook(26, 2)].s0 * ALPHA.s1 + rC[hook(24, 2)][hook(26, 2)].s1 * ALPHA.s0;
  C[hook(6, 48 * M)].s0 = rC[hook(24, 2)][hook(26, 3)].s0 * ALPHA.s0 - rC[hook(24, 2)][hook(26, 3)].s1 * ALPHA.s1;
  C[hook(6, 48 * M)].s1 = rC[hook(24, 2)][hook(26, 3)].s0 * ALPHA.s1 + rC[hook(24, 2)][hook(26, 3)].s1 * ALPHA.s0;
  C += 16;

  C[hook(6, 0 * M)].s0 = rC[hook(24, 3)][hook(27, 0)].s0 * ALPHA.s0 - rC[hook(24, 3)][hook(27, 0)].s1 * ALPHA.s1;
  C[hook(6, 0 * M)].s1 = rC[hook(24, 3)][hook(27, 0)].s0 * ALPHA.s1 + rC[hook(24, 3)][hook(27, 0)].s1 * ALPHA.s0;
  C[hook(6, 16 * M)].s0 = rC[hook(24, 3)][hook(27, 1)].s0 * ALPHA.s0 - rC[hook(24, 3)][hook(27, 1)].s1 * ALPHA.s1;
  C[hook(6, 16 * M)].s1 = rC[hook(24, 3)][hook(27, 1)].s0 * ALPHA.s1 + rC[hook(24, 3)][hook(27, 1)].s1 * ALPHA.s0;
  C[hook(6, 32 * M)].s0 = rC[hook(24, 3)][hook(27, 2)].s0 * ALPHA.s0 - rC[hook(24, 3)][hook(27, 2)].s1 * ALPHA.s1;
  C[hook(6, 32 * M)].s1 = rC[hook(24, 3)][hook(27, 2)].s0 * ALPHA.s1 + rC[hook(24, 3)][hook(27, 2)].s1 * ALPHA.s0;
  C[hook(6, 48 * M)].s0 = rC[hook(24, 3)][hook(27, 3)].s0 * ALPHA.s0 - rC[hook(24, 3)][hook(27, 3)].s1 * ALPHA.s1;
  C[hook(6, 48 * M)].s1 = rC[hook(24, 3)][hook(27, 3)].s0 * ALPHA.s1 + rC[hook(24, 3)][hook(27, 3)].s1 * ALPHA.s0;
  C += 16;

  C[hook(6, 0 * M)].s0 = rC[hook(24, 4)][hook(28, 0)].s0 * ALPHA.s0 - rC[hook(24, 4)][hook(28, 0)].s1 * ALPHA.s1;
  C[hook(6, 0 * M)].s1 = rC[hook(24, 4)][hook(28, 0)].s0 * ALPHA.s1 + rC[hook(24, 4)][hook(28, 0)].s1 * ALPHA.s0;
  C[hook(6, 16 * M)].s0 = rC[hook(24, 4)][hook(28, 1)].s0 * ALPHA.s0 - rC[hook(24, 4)][hook(28, 1)].s1 * ALPHA.s1;
  C[hook(6, 16 * M)].s1 = rC[hook(24, 4)][hook(28, 1)].s0 * ALPHA.s1 + rC[hook(24, 4)][hook(28, 1)].s1 * ALPHA.s0;
  C[hook(6, 32 * M)].s0 = rC[hook(24, 4)][hook(28, 2)].s0 * ALPHA.s0 - rC[hook(24, 4)][hook(28, 2)].s1 * ALPHA.s1;
  C[hook(6, 32 * M)].s1 = rC[hook(24, 4)][hook(28, 2)].s0 * ALPHA.s1 + rC[hook(24, 4)][hook(28, 2)].s1 * ALPHA.s0;
  C[hook(6, 48 * M)].s0 = rC[hook(24, 4)][hook(28, 3)].s0 * ALPHA.s0 - rC[hook(24, 4)][hook(28, 3)].s1 * ALPHA.s1;
  C[hook(6, 48 * M)].s1 = rC[hook(24, 4)][hook(28, 3)].s0 * ALPHA.s1 + rC[hook(24, 4)][hook(28, 3)].s1 * ALPHA.s0;
  C += 16;

  C[hook(6, 0 * M)].s0 = rC[hook(24, 5)][hook(29, 0)].s0 * ALPHA.s0 - rC[hook(24, 5)][hook(29, 0)].s1 * ALPHA.s1;
  C[hook(6, 0 * M)].s1 = rC[hook(24, 5)][hook(29, 0)].s0 * ALPHA.s1 + rC[hook(24, 5)][hook(29, 0)].s1 * ALPHA.s0;
  C[hook(6, 16 * M)].s0 = rC[hook(24, 5)][hook(29, 1)].s0 * ALPHA.s0 - rC[hook(24, 5)][hook(29, 1)].s1 * ALPHA.s1;
  C[hook(6, 16 * M)].s1 = rC[hook(24, 5)][hook(29, 1)].s0 * ALPHA.s1 + rC[hook(24, 5)][hook(29, 1)].s1 * ALPHA.s0;
  C[hook(6, 32 * M)].s0 = rC[hook(24, 5)][hook(29, 2)].s0 * ALPHA.s0 - rC[hook(24, 5)][hook(29, 2)].s1 * ALPHA.s1;
  C[hook(6, 32 * M)].s1 = rC[hook(24, 5)][hook(29, 2)].s0 * ALPHA.s1 + rC[hook(24, 5)][hook(29, 2)].s1 * ALPHA.s0;
  C[hook(6, 48 * M)].s0 = rC[hook(24, 5)][hook(29, 3)].s0 * ALPHA.s0 - rC[hook(24, 5)][hook(29, 3)].s1 * ALPHA.s1;
  C[hook(6, 48 * M)].s1 = rC[hook(24, 5)][hook(29, 3)].s0 * ALPHA.s1 + rC[hook(24, 5)][hook(29, 3)].s1 * ALPHA.s0;
  C += 16;

  C[hook(6, 0 * M)].s0 = rC[hook(24, 6)][hook(30, 0)].s0 * ALPHA.s0 - rC[hook(24, 6)][hook(30, 0)].s1 * ALPHA.s1;
  C[hook(6, 0 * M)].s1 = rC[hook(24, 6)][hook(30, 0)].s0 * ALPHA.s1 + rC[hook(24, 6)][hook(30, 0)].s1 * ALPHA.s0;
  C[hook(6, 16 * M)].s0 = rC[hook(24, 6)][hook(30, 1)].s0 * ALPHA.s0 - rC[hook(24, 6)][hook(30, 1)].s1 * ALPHA.s1;
  C[hook(6, 16 * M)].s1 = rC[hook(24, 6)][hook(30, 1)].s0 * ALPHA.s1 + rC[hook(24, 6)][hook(30, 1)].s1 * ALPHA.s0;
  C[hook(6, 32 * M)].s0 = rC[hook(24, 6)][hook(30, 2)].s0 * ALPHA.s0 - rC[hook(24, 6)][hook(30, 2)].s1 * ALPHA.s1;
  C[hook(6, 32 * M)].s1 = rC[hook(24, 6)][hook(30, 2)].s0 * ALPHA.s1 + rC[hook(24, 6)][hook(30, 2)].s1 * ALPHA.s0;
  C[hook(6, 48 * M)].s0 = rC[hook(24, 6)][hook(30, 3)].s0 * ALPHA.s0 - rC[hook(24, 6)][hook(30, 3)].s1 * ALPHA.s1;
  C[hook(6, 48 * M)].s1 = rC[hook(24, 6)][hook(30, 3)].s0 * ALPHA.s1 + rC[hook(24, 6)][hook(30, 3)].s1 * ALPHA.s0;
  C += 16;

  C[hook(6, 0 * M)].s0 = rC[hook(24, 7)][hook(31, 0)].s0 * ALPHA.s0 - rC[hook(24, 7)][hook(31, 0)].s1 * ALPHA.s1;
  C[hook(6, 0 * M)].s1 = rC[hook(24, 7)][hook(31, 0)].s0 * ALPHA.s1 + rC[hook(24, 7)][hook(31, 0)].s1 * ALPHA.s0;
  C[hook(6, 16 * M)].s0 = rC[hook(24, 7)][hook(31, 1)].s0 * ALPHA.s0 - rC[hook(24, 7)][hook(31, 1)].s1 * ALPHA.s1;
  C[hook(6, 16 * M)].s1 = rC[hook(24, 7)][hook(31, 1)].s0 * ALPHA.s1 + rC[hook(24, 7)][hook(31, 1)].s1 * ALPHA.s0;
  C[hook(6, 32 * M)].s0 = rC[hook(24, 7)][hook(31, 2)].s0 * ALPHA.s0 - rC[hook(24, 7)][hook(31, 2)].s1 * ALPHA.s1;
  C[hook(6, 32 * M)].s1 = rC[hook(24, 7)][hook(31, 2)].s0 * ALPHA.s1 + rC[hook(24, 7)][hook(31, 2)].s1 * ALPHA.s0;
  C[hook(6, 48 * M)].s0 = rC[hook(24, 7)][hook(31, 3)].s0 * ALPHA.s0 - rC[hook(24, 7)][hook(31, 3)].s1 * ALPHA.s1;
  C[hook(6, 48 * M)].s1 = rC[hook(24, 7)][hook(31, 3)].s0 * ALPHA.s1 + rC[hook(24, 7)][hook(31, 3)].s1 * ALPHA.s0;
  C += 16;
}