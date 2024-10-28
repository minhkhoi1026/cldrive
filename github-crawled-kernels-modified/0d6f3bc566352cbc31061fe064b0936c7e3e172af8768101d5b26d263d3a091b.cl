//{"in":0,"mask":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant float mask[] = {0.0625, 0.125, 0.0625, 0.125, 0.25, 0.125, 0.0625, 0.125, 0.0625};

kernel void gauss(read_only image2d_t in, global float* out) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  float sum = 0.0f;
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      sum += mask[hook(2, (y + 1) * 3 + x + 1)] * read_imagef(in, sampler, pos + (int2)(x, y)).x;
    }
  }

  out[hook(1, pos.x + pos.y * get_global_size(0))] = sum * 255;
}