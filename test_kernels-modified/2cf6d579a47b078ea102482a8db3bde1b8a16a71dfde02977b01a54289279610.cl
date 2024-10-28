//{"d_VectA":0,"d_VectB":1,"length":3,"outScalar":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void VectVectMulKernel(global double* d_VectA, global double* d_VectB, global double* outScalar, global int* length) {
  unsigned int gid = get_global_id(0);
  int currCell;
  if (gid < *length)
    d_VectA[hook(0, gid)] *= d_VectB[hook(1, gid)];

  barrier(0x01);
  if (gid == 0) {
    *outScalar = 0.0;
    for (currCell = 0; currCell < *length; currCell++)
      *outScalar = (*outScalar) + d_VectA[hook(0, currCell)];
  }
}