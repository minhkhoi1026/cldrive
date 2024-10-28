//{"c":3,"input":1,"ldin":5,"ldout":4,"output":0,"r":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(global float* output, global float* input, int r, int c, int ldout, int ldin) {
  int idx = get_global_id(0);
  int row = idx % ldin;
  int col = idx / ldin;

  if (row >= r || col >= c)
    return;

  output[hook(0, col + row * ldout)] = input[hook(1, idx)];
}