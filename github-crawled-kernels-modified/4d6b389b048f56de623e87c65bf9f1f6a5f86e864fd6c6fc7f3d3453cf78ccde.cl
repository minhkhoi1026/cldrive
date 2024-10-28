//{"M":2,"blkNnz":7,"lColIdx":4,"lRowIdx":3,"nnzc":0,"oRowIdx":1,"rColIdx":6,"rRowIdx":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void csr_calc_out_nnz(global unsigned* nnzc, global int* oRowIdx, unsigned int M, global const int* lRowIdx, global const int* lColIdx, global const int* rRowIdx, global const int* rColIdx, local unsigned int* blkNnz) {
  const unsigned int row = get_global_id(0);
  const unsigned int tid = get_local_id(0);

  const bool valid = row < M;

  const unsigned int lEnd = (valid ? lRowIdx[hook(3, row + 1)] : 0);
  const unsigned int rEnd = (valid ? rRowIdx[hook(5, row + 1)] : 0);

  blkNnz[hook(7, tid)] = 0;
  barrier(0x01);

  unsigned int l = (valid ? lRowIdx[hook(3, row)] : 0);
  unsigned int r = (valid ? rRowIdx[hook(5, row)] : 0);
  unsigned int nnz = 0;
  while (l < lEnd && r < rEnd) {
    unsigned int lci = lColIdx[hook(4, l)];
    unsigned int rci = rColIdx[hook(6, r)];
    l += (lci <= rci);
    r += (lci >= rci);
    nnz++;
  }
  nnz += (lEnd - l);
  nnz += (rEnd - r);

  blkNnz[hook(7, tid)] = nnz;
  barrier(0x01);

  if (valid)
    oRowIdx[hook(1, row + 1)] = nnz;

  for (unsigned int s = get_local_size(0) / 2; s > 0; s >>= 1) {
    if (tid < s) {
      blkNnz[hook(7, tid)] += blkNnz[hook(7, tid + s)];
    }
    barrier(0x01);
  }

  if (tid == 0) {
    nnz = blkNnz[hook(7, 0)];
    atomic_add(nnzc, nnz);
  }
}