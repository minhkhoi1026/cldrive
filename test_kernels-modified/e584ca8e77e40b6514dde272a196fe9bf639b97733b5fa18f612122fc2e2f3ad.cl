//{"M":0,"V":1,"W":4,"height":3,"partialDotProduct":5,"row":6,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatVecMulCoalesced0(const global float* M, const global float* V, unsigned int width, unsigned int height, global float* W, local float* partialDotProduct) {
  for (unsigned int y = get_group_id(0); y < height; y += get_num_groups(0)) {
    const global float* row = M + y * width;

    float sum = 0;
    for (unsigned int x = get_local_id(0); x < width; x += get_local_size(0))
      sum += row[hook(6, x)] * V[hook(1, x)];

    partialDotProduct[hook(5, get_local_id(0))] = sum;

    barrier(0x01);

    if (get_local_id(0) == 0) {
      float dotProduct = 0;
      for (unsigned int t = 0; t < get_local_size(0); ++t)
        dotProduct += partialDotProduct[hook(5, t)];
      W[hook(4, y)] = dotProduct;
    }

    barrier(0x01);
  }
}