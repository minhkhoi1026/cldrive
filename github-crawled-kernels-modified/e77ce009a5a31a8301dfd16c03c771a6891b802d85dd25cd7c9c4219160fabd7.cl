//{"d_out":1,"img":0,"n":2,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t smplr = 0 | 0 | 0x10;
kernel void readImg2D(read_only image2d_t img, global float* d_out, int n, int width) {
  int idx_x = get_global_id(0);
  int idx_y = get_global_id(1);
  int localsizex = get_local_size(0);
  int localsizey = get_local_size(1);
  int out_idx = idx_y * (localsizex * localsizey) + idx_x;
  float sum = 0.0f;

  float4 v;
  int2 coord;
  coord.y = idx_y;
  coord.x = idx_x;

  for (int i = 0; i < n; i++) {
    v = read_imagef(img, smplr, coord);
    sum += v.x;
  }
  d_out[hook(1, out_idx)] = sum;
}