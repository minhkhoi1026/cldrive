//{"cache":2,"nels":3,"s":0,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecsmooth_lmem(global int* restrict s, global const int* restrict v, local volatile int* cache, int nels) {
  const int gi = get_global_id(0);
  const int li = get_local_id(0);
  if (gi >= nels)
    return;

  int v1 = 0, v2 = v[hook(1, gi)], v3 = 0;
  int c = 1;

  cache[hook(2, li + 1)] = v2;
  if (li == 0 && gi > 0)
    cache[hook(2, 0)] = v[hook(1, gi - 1)];
  if ((li == get_local_size(0) - 1) && (gi + 1 < nels))
    cache[hook(2, li + 2)] = v[hook(1, gi + 1)];

  barrier(0x01);

  if (gi > 0) {
    v1 = cache[hook(2, li)];
    ++c;
  }
  if (gi + 1 < nels) {
    v3 = cache[hook(2, li + 2)];
    ++c;
  }
  s[hook(0, gi)] = (v1 + v2 + v3) / c;
}