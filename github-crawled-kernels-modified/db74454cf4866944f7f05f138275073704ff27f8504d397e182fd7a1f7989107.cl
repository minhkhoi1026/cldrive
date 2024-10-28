//{"gmax":1,"nitems":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int GlobalIndex(unsigned int x, unsigned int y, unsigned int z, unsigned int w, unsigned int h, unsigned int d) {
  return (z * (w * h)) + (y * w) + x;
}

kernel void MaxGPU(global uint4* src, global unsigned int* gmax, unsigned int nitems) {
  unsigned int count = (nitems / 4) / get_global_size(0);
  unsigned int idx = get_global_id(0);
  unsigned int stride = get_global_size(0);
  unsigned int pmax = 0;
  local unsigned int lmax;

  for (unsigned int n = 0; n < count; n++, idx += stride) {
    pmax = max(pmax, src[hook(0, idx)].x);
    pmax = max(pmax, src[hook(0, idx)].y);
    pmax = max(pmax, src[hook(0, idx)].z);
    pmax = max(pmax, src[hook(0, idx)].w);
  }

  if (get_local_id(0) == 0) {
    lmax = 0;
  }

  barrier(0x01);

  (void)atomic_max(&lmax, pmax);

  barrier(0x01);

  if (get_local_id(0) == 0) {
    gmax[hook(1, get_group_id(0))] = lmax;
  }
}