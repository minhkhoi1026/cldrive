//{"inputs":3,"n2":5,"summands":4,"sums":2,"w":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bpnn_layerforward(global float* x, global float* w, global float* sums, local float* inputs, local float* summands, int n2) {
  int gcl = get_group_id(1);
  int row = get_local_id(0);
  int col = get_local_id(1);
  if (row == 0)
    inputs[hook(3, col)] = x[hook(0, n2 * gcl + col + 1)];
  barrier(0x01);
  int kk = row * n2 + col;
  int index = (n2 + 1) * n2 * gcl + (n2 + 1) * row + col + n2 + 2;
  summands[hook(4, kk)] = w[hook(1, index)] * inputs[hook(3, row)];
  barrier(0x01);
  for (int i = 1; i < n2; i = i * 2) {
    if (row % (2 * i) == 0)
      summands[hook(4, kk)] += summands[hook(4, (row + i) * n2 + col)];
    barrier(0x01);
  }
  if (row == 0)
    sums[hook(2, gcl * n2 + col)] = summands[hook(4, kk)];
}