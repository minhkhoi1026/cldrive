//{"cols":2,"dim":4,"out":6,"partialSums":7,"rowDelimiters":3,"val":0,"vec":1,"vecWidth":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spmv_csr_vector_kernel(global const float* restrict val, global const float* restrict vec, global const int* restrict cols, global const int* restrict rowDelimiters, const int dim, const int vecWidth, global float* restrict out) {
  int t = get_local_id(0);

  int id = t & (vecWidth - 1);

  int vecsPerBlock = get_local_size(0) / vecWidth;
  int myRow = (get_group_id(0) * vecsPerBlock) + (t / vecWidth);

  local volatile float partialSums[128];
  partialSums[hook(7, t)] = 0;

  if (myRow < dim) {
    int vecStart = rowDelimiters[hook(3, myRow)];
    int vecEnd = rowDelimiters[hook(3, myRow + 1)];
    float mySum = 0;
    for (int j = vecStart + id; j < vecEnd; j += vecWidth) {
      int col = cols[hook(2, j)];

      mySum += val[hook(0, j)] * vec[hook(1, col)];
    }

    partialSums[hook(7, t)] = mySum;
    barrier(0x01);

    int bar = vecWidth / 2;
    while (bar > 0) {
      if (id < bar)
        partialSums[hook(7, t)] += partialSums[hook(7, t + bar)];
      barrier(0x01);
      bar = bar / 2;
    }

    if (id == 0) {
      out[hook(6, myRow)] = partialSums[hook(7, t)];
    }
  }
}