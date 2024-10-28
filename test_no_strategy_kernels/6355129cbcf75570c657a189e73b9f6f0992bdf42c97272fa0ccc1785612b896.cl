//{"gmin":1,"nitems":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int GlobalIndex(unsigned int x, unsigned int y, unsigned int z, unsigned int w, unsigned int h, unsigned int d) {
  return (z * (w * h)) + (y * w) + x;
}

kernel void MinGPU(global uint4* src, global unsigned int* gmin, unsigned int nitems) {
  unsigned int count = (nitems / 4) / get_global_size(0);
  unsigned int idx = get_global_id(0);
  unsigned int stride = get_global_size(0);
  unsigned int pmin = (unsigned int)-1;
  local unsigned int lmin;

  for (unsigned int n = 0; n < count; n++, idx += stride) {
    pmin = min(pmin, src[hook(0, idx)].x);
    pmin = min(pmin, src[hook(0, idx)].y);
    pmin = min(pmin, src[hook(0, idx)].z);
    pmin = min(pmin, src[hook(0, idx)].w);
  }

  if (get_local_id(0) == 0) {
    lmin = (unsigned int)-1;
  }

  barrier(0x01);

  (void)atomic_min(&lmin, pmin);

  barrier(0x01);

  if (get_local_id(0) == 0) {
    gmin[hook(1, get_group_id(0))] = lmin;
  }
}