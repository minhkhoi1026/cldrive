//{"M":0,"V":1,"W":4,"height":3,"partialDotProduct":5,"row":6,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatVecMulCoalesced1(const global float* M, const global float* V, unsigned int width, unsigned int height, global float* W, local float* partialDotProduct) {
  for (unsigned int y = get_group_id(0); y < height; y += get_num_groups(0)) {
    const global float* row = M + y * width;

    float sum = 0;
    for (unsigned int x = get_local_id(0); x < width; x += get_local_size(0))
      sum += row[hook(6, x)] * V[hook(1, x)];

    partialDotProduct[hook(5, get_local_id(0))] = sum;

    for (unsigned int stride = 1; stride < get_local_size(0); stride *= 2) {
      barrier(0x01);

      unsigned int index = 2 * stride * get_local_id(0);

      if (index < get_local_size(0)) {
        partialDotProduct[hook(5, index)] += partialDotProduct[hook(5, index + stride)];
      }
    }

    if (get_local_id(0) == 0)
      W[hook(4, y)] = partialDotProduct[hook(5, 0)];

    barrier(0x01);
  }
}