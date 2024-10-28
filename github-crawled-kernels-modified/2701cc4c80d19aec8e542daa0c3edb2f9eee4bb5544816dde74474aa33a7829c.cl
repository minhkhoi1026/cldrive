//{"in":0,"op":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0x10 | 2;
kernel void morphOpKernel(read_only image2d_t in, int op, write_only image2d_t out) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float extremePxVal = op == 0 ? 0.0f : 1.0f;

  for (int i = -1; i <= 1; ++i) {
    for (int j = -1; j <= 1; ++j) {
      const float pxVal = read_imagef(in, sampler, (int2)(x + i, y + j)).s0;

      switch (op) {
        case 0:
          extremePxVal = max(extremePxVal, pxVal);
          break;

        case 1:
          extremePxVal = min(extremePxVal, pxVal);
          break;
      }
    }
  }

  write_imagef(out, (int2)(x, y), (float4)(extremePxVal, 0.0f, 0.0f, 0.0f));
}