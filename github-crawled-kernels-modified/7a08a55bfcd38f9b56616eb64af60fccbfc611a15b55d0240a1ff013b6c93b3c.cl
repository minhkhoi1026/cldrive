//{"A":0,"D":4,"alpha":3,"b":7,"m":1,"n":2,"pa":5,"pb":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tmm(global float* A, int m, int n, float alpha, global float* D) {
  int lidX = get_local_id(0);
  unsigned int lsizeX = get_local_size(0);

  unsigned int matI = get_group_id(1);
  unsigned int matJ = get_group_id(0);

  if (matI < matJ)
    return;

  local float4 a[64], b[64];
  float4 result;
  local unsigned int cnt;
  result = 0;
  cnt = 0;
  barrier(0x01);
  do {
    int global_block_base = (lidX + cnt * lsizeX) * 3;
    float4 pa[3], pb[3];

    for (unsigned int j = 0; j < 3 && (cnt * lsizeX + lidX) * 3 < n / 4; j++) {
      pa[hook(5, j)] = *(global float4*)&A[hook(0, matI * n + (global_block_base + j) * 4)];
      if (matI != matJ)
        pb[hook(6, j)] = *(global float4*)&A[hook(0, matJ * n + (global_block_base + j) * 4)];
      else
        pb[hook(6, j)] = pa[hook(5, j)];
    }

    if (global_block_base + 3 - 1 >= n / 4) {
      for (int i = 0; i < 3; i++) {
        if (global_block_base + i >= n / 4)
          pb[hook(6, i)] = 0;
      }
    }

    pb[hook(6, 0)] *= pa[hook(5, 0)];

    for (int j = 1; j < 3; j++)
      pb[hook(6, 0)] = fma(pb[hook(6, j)], pa[hook(5, j)], pb[hook(6, 0)]);

    b[hook(7, lidX)] = pb[hook(6, 0)];
    barrier(0x01);

    for (int offset = 64 / 2; offset > 0; offset >>= 1) {
      if (lidX < offset)
        b[hook(7, lidX)] += b[hook(7, (lidX + offset))];
      barrier(0x01);
    }
    if (lidX == 0) {
      result += b[hook(7, 0)];
      cnt++;
    }
    barrier(0x01);
  } while (cnt * 3 * lsizeX < n / 4);
  if (lidX == 0) {
    float ret = (result.s0 + result.s1 + result.s2 + result.s3) * alpha;
    D[hook(4, matI * m + matJ)] = ret;
    if (matI != matJ)
      D[hook(4, matJ * m + matI)] = ret;
  }
}