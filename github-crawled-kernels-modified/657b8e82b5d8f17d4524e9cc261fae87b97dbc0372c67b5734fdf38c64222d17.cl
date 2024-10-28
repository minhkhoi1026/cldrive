//{"in":0,"in_dim":3,"mask":1,"mask_dim":4,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve(const global unsigned int* const in, constant unsigned int* const mask, global unsigned int* const out, const int in_dim, const int mask_dim) {
  const int2 pos = (int2)(get_global_id(0), get_global_id(1));
  unsigned int sum = 0;
  for (int r = 0; r < mask_dim; ++r) {
    const int idx = (pos.y + r) * in_dim + pos.x;
    for (int c = 0; c < mask_dim; ++c) {
      sum += mask[hook(1, r * mask_dim + c)] * in[hook(0, idx + c)];
    }
  }
  out[hook(2, pos.y * get_global_size(0) + pos.x)] = sum;
}