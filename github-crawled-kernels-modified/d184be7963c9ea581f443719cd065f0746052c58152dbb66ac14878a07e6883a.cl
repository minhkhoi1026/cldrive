//{"height":3,"sizes":1,"width":2,"work":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void update_indices(global int* work, global int* sizes, int width, int height) {
  int2 pos = (int2)(get_global_id(0) + 1, get_global_id(1) + 1);
  if (pos.x > width || pos.y > height)
    return;

  int adr = pos.x + pos.y * (width + 2);
  int idx = work[hook(0, adr)];
  if (idx != 0) {
    int idx_tmp = work[hook(0, idx)];
    while (idx != idx_tmp) {
      idx = work[hook(0, idx_tmp)];
      idx_tmp = work[hook(0, idx)];
    }
    work[hook(0, adr)] = idx;

    unsigned int size = sizes[hook(1, adr)];
    if (size && idx != adr) {
      atom_add(sizes + idx, size);
      sizes[hook(1, adr)] = 0;
    }
  }
}