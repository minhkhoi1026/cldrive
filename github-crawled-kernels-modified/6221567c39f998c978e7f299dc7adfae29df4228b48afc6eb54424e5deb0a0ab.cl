//{"A":0,"B":2,"C":4,"alpha":7,"b_s":11,"b_s[get_local_id(1)]":10,"b_s[j]":12,"beta":8,"c":9,"k":6,"lda":1,"ldb":3,"ldc":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mysgemmNT(global const float* A, int lda, global const float* B, int ldb, global float* C, int ldc, int k, float alpha, float beta) {
  float c[16];
  for (int i = 0; i < 16; i++)
    c[hook(9, i)] = 0.0f;

  int mid = get_local_id(1) * get_local_size(0) + get_local_id(0);
  int m = get_group_id(0) * 16 + mid;
  int n = get_group_id(1) * 16 + get_local_id(0);

  local float b_s[16][16];

  for (int i = 0; i < k; i += 16) {
    float a;
    b_s[hook(11, get_local_id(1))][hook(10, get_local_id(0))] = B[hook(2, n + (i + get_local_id(1)) * ldb)];
    barrier(0x01);
    for (int j = 0; j < 16; j++) {
      a = A[hook(0, m + (i + j) * lda)];
      for (int kk = 0; kk < 16; kk++)
        c[hook(9, kk)] += a * b_s[hook(11, j)][hook(12, kk)];
    }
    barrier(0x01);
  }
  int t = ldc * get_group_id(1) * 16 + m;
  for (int i = 0; i < 16; i++) {
    C[hook(4, t + i * ldc)] = C[hook(4, t + i * ldc)] * beta + alpha * c[hook(9, i)];
  }
}