//{"dataIn":0,"dataOut":1,"dim1":2,"dim2":3,"dim3":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swapDimensionsBwd(global float* dataIn, global float* dataOut, unsigned int const dim1, unsigned int const dim2, unsigned int const dim3) {
  unsigned int idx = get_global_id(0);

  unsigned int dim1dim2 = mul24(dim1, dim2);
  unsigned int dim3dim2 = mul24(dim3, dim2);

  unsigned int inX = idx % dim1;
  unsigned int inY = (idx % dim1dim2) / dim1;
  unsigned int inZ = idx / dim1dim2;

  unsigned int idxOut = mad24(inX, dim3dim2, mad24(inZ, dim2, inY));

  if (idx >= mul24(dim1dim2, dim3)) {
    return;
  }

  float2 val = vload2(idx, dataIn);
  vstore2(val, idxOut, dataOut);
}