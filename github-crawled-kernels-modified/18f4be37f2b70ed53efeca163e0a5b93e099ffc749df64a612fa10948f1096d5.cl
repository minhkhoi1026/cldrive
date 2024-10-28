//{"img":0,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t smplr = 0 | 0 | 0x10;
kernel void writeImg2D(write_only image2d_t img, int n) {
  int idx_x = get_global_id(0);
  int idx_y = get_global_id(1);
  int localsizex = get_local_size(0);
  int localsizey = get_local_size(1);
  int out_idx = idx_y * (localsizex * localsizey) + idx_x;
  float sum = 0.0f;

  float4 v = (float4)((float)idx_x, (float)idx_y, (float)out_idx, sum);
  int2 coord;
  coord.y = idx_y;
  coord.x = idx_x;

  for (int i = 0; i < n; i++) {
    write_imagef(img, coord, v);
  }
}