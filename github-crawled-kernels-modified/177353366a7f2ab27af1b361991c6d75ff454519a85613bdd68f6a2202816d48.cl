//{"C":5,"H":6,"N":4,"W":7,"bias":2,"in":0,"out":1,"slope":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(256, 1, 1))) kernel void BiasReLuUni2(global float* in, global float* out, global float* bias, float slope, int N, int C, int H, int W) {
  int gid_x = get_global_id(0);

  if (gid_x < N * C * H * W) {
    float intermediate = in[hook(0, gid_x)] + bias[hook(2, (gid_x % (C * H * W)) / (H * W))];
    out[hook(1, gid_x)] = intermediate * (intermediate > 0.0f ? 1.0f : slope);
  }
}