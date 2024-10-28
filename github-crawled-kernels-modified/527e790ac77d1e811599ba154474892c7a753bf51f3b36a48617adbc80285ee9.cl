//{"changed":1,"height":3,"width":2,"work":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void min_neighbour(global int* work, global int* changed, int width, int height) {
  int2 pos = (int2)(get_global_id(0) + 1, get_global_id(1) + 1);
  if (pos.x > width || pos.y > height)
    return;

  int adr = pos.x + pos.y * (width + 2);
  int idx = work[hook(0, adr)];
  if (idx != 0) {
    int min_idx = 2147483647;

    int idx_w = work[hook(0, adr - 1)];
    if (idx_w > 0)
      min_idx = idx_w;

    int idx_e = work[hook(0, adr + 1)];
    if (idx_e > 0 && idx_e < min_idx)
      min_idx = idx_e;

    int idx_n = work[hook(0, adr - width - 2)];
    if (idx_n > 0 && idx_n < min_idx)
      min_idx = idx_n;

    int idx_s = work[hook(0, adr + width + 2)];
    if (idx_s > 0 && idx_s < min_idx)
      min_idx = idx_s;

    if (min_idx < idx) {
      int idx_lst = work[hook(0, idx)];
      work[hook(0, idx)] = min(idx_lst, min_idx);
      changed[hook(1, 0)] = 1;
    }
  }
}