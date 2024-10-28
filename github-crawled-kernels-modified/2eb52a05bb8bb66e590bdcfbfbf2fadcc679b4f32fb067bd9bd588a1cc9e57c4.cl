//{"M":0,"V":1,"W":4,"height":3,"p":7,"partialDotProduct":5,"row":6,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatVecMulCoalesced3(const global float* M, const global float* V, unsigned int width, unsigned int height, global float* W, local float* partialDotProduct) {
  for (unsigned int y = get_group_id(0); y < height; y += get_num_groups(0)) {
    const global float* row = M + y * width;

    float sum = 0;
    for (unsigned int x = get_local_id(0); x < width; x += get_local_size(0))
      sum += row[hook(6, x)] * V[hook(1, x)];

    partialDotProduct[hook(5, get_local_id(0))] = sum;

    barrier(0x01);

    unsigned int id = get_local_id(0) & (32 - 1);

    float warpResult = 0.0f;
    if (get_local_id(0) < get_local_size(0) / 2) {
      volatile local float* p = partialDotProduct + 2 * get_local_id(0) - id;
      p[hook(7, 0)] += p[hook(7, 32)];
      p[hook(7, 0)] += p[hook(7, 16)];
      p[hook(7, 0)] += p[hook(7, 8)];
      p[hook(7, 0)] += p[hook(7, 4)];
      p[hook(7, 0)] += p[hook(7, 2)];
      p[hook(7, 0)] += p[hook(7, 1)];
      warpResult = p[hook(7, 0)];
    }

    barrier(0x01);

    if (id == 0)
      partialDotProduct[hook(5, get_local_id(0) / 32)] = warpResult;

    barrier(0x01);

    unsigned int size = get_local_size(0) / (2 * 32);

    if (get_local_id(0) < size / 2) {
      local float* p = partialDotProduct + get_local_id(0);
      if (size >= 8)
        p[hook(7, 0)] += p[hook(7, 4)];
      if (size >= 4)
        p[hook(7, 0)] += p[hook(7, 2)];
      if (size >= 2)
        p[hook(7, 0)] += p[hook(7, 1)];
    }

    if (get_local_id(0) == 0)
      W[hook(4, y)] = partialDotProduct[hook(5, 0)];

    barrier(0x01);
  }
}