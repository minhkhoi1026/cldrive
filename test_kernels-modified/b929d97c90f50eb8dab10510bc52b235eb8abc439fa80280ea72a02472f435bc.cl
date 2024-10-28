//{"cols":2,"dim":4,"out":5,"partialSums":6,"rowDelimiters":3,"val":0,"vec":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spmv_csr_vector_kernel(global const float* restrict val, global const float* restrict vec, global const int* restrict cols, global const int* restrict rowDelimiters, const int dim, global float* restrict out) {
  int t = get_local_id(0);

  int id = t & (32 - 1);

  int threadsPerBlock = get_local_size(0) / 32;
  int myRow = (get_group_id(0) * threadsPerBlock) + (t / 32);

  local volatile float partialSums[128];
  partialSums[hook(6, t)] = 0;

  if (myRow < dim) {
    int vecStart = rowDelimiters[hook(3, myRow)];
    int vecEnd = rowDelimiters[hook(3, myRow + 1)];
    float mySum = 0;
    for (int j = vecStart + id; j < vecEnd; j += 32) {
      int col = cols[hook(2, j)];
      mySum += val[hook(0, j)] * vec[hook(1, col)];
    }

    partialSums[hook(6, t)] = mySum;
    barrier(0x01);

    if (id < 16)
      partialSums[hook(6, t)] += partialSums[hook(6, t + 16)];
    barrier(0x01);
    if (id < 8)
      partialSums[hook(6, t)] += partialSums[hook(6, t + 8)];
    barrier(0x01);
    if (id < 4)
      partialSums[hook(6, t)] += partialSums[hook(6, t + 4)];
    barrier(0x01);
    if (id < 2)
      partialSums[hook(6, t)] += partialSums[hook(6, t + 2)];
    barrier(0x01);
    if (id < 1)
      partialSums[hook(6, t)] += partialSums[hook(6, t + 1)];
    barrier(0x01);

    if (id == 0) {
      out[hook(5, myRow)] = partialSums[hook(6, t)];
    }
  }
}