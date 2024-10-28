//{"C":3,"H":4,"N":2,"W":5,"inputs":0,"outputs":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void NCHW2CHWN(global float* inputs, global float* outputs, int N, int C, int H, int W) {
  int gid0 = get_global_id(0);
  int n = gid0 / (C * H * W);
  if (n < N) {
    int chw = gid0 - n * (C * H * W);
    outputs[hook(1, chw * N + n)] = inputs[hook(0, gid0)];
  }
}