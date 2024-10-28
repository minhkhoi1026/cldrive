//{"a":2,"b":4,"blockDimX":8,"blockDimY":9,"h":6,"lda":3,"ldb":5,"ldout":1,"out":0,"w":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sub(global float* out, int ldout, global const float* a, int lda, global const float* b, int ldb, int h, int w, int blockDimX, int blockDimY) {
  int blockIdx = get_group_id(0);
  int blockIdy = get_group_id(1);

  int threadIdx = get_local_id(0);
  int threadIdy = get_local_id(1);

  int row = blockIdx * blockDimX + threadIdx;
  int col = blockIdy * blockDimY + threadIdy;

  if (row >= h || col >= w)
    return;

  out[hook(0, row + col * ldout)] = a[hook(2, row + col * lda)] - b[hook(4, row + col * ldb)];
}