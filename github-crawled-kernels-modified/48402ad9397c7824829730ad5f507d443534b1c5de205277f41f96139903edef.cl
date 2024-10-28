//{"output":1,"vecSz":2,"vs":0,"xs":3,"ys":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gramF_slow(global const float* restrict const vs, global float* restrict const output, const int vecSz) {
  const int idy = get_global_id(1);
  const int idx = get_global_id(0);
  const int n = get_global_size(0);

  global const float* const xs = &vs[hook(0, idx * vecSz)];
  global const float* const ys = &vs[hook(0, idy * vecSz)];

  float res = 0.0f;
  for (int i = 0; i < vecSz; ++i)
    res += xs[hook(3, i)] * ys[hook(4, i)];
  output[hook(1, idy * n + idx)] = res;
}