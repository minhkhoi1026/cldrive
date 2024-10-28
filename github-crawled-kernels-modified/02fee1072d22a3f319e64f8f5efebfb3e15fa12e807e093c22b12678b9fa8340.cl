//{"blockDimX":6,"blockDimY":7,"h":4,"in":2,"ldin":3,"ldout":1,"out":0,"w":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sub_in_place(global float* out, int ldout, global const float* in, int ldin, int h, int w, int blockDimX, int blockDimY) {
  int blockIdx = get_group_id(0);
  int blockIdy = get_group_id(1);

  int threadIdx = get_local_id(0);
  int threadIdy = get_local_id(1);

  int row = blockIdx * blockDimX + threadIdx;
  int col = blockIdy * blockDimY + threadIdy;

  if (row >= h || col >= w)
    return;

  out[hook(0, row + col * ldout)] -= in[hook(2, row + col * ldin)];
}