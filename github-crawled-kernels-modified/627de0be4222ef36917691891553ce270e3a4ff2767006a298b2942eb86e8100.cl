//{"coord":3,"dst":0,"src":1,"threshold":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dilation_global(write_only image2d_t dst, read_only image2d_t src, float threshold, constant int* coord) {
  const sampler_t sampler = (0 | 2 | 0x10);

  int2 loc = (int2)(get_global_id(0), get_global_id(1));

  float4 px = read_imagef(src, sampler, loc);
  float limit = px.x + threshold;
  if (limit > 1) {
    limit = 1;
  }

  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      if (coord[hook(3, (j + 1) * 3 + (i + 1))] == 1) {
        float4 cur = read_imagef(src, sampler, loc + (int2)(i, j));
        if (cur.x > px.x) {
          px = cur;
        }
      }
    }
  }
  if (limit < px.x) {
    px = (float4)(limit);
  }
  write_imagef(dst, loc, px);
}