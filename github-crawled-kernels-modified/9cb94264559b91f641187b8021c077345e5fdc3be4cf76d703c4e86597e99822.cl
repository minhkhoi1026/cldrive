//{"height":5,"ids":1,"max_boxes":8,"max_size":7,"min_size":6,"sizes":2,"sizes_out":3,"width":4,"work":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void make_blob_ids(global int* work, global int* ids, global int* sizes, global int* sizes_out, int width, int height, int min_size, int max_size, int max_boxes) {
  int2 pos = (int2)(get_global_id(0) + 1, get_global_id(1) + 1);
  if (pos.x > width || pos.y > height)
    return;

  int adr = pos.x + pos.y * (width + 2);
  int idx = work[hook(0, adr)];
  if (idx == adr) {
    int size = sizes[hook(2, adr)];
    if (min_size < size && size < max_size) {
      int num = atom_inc(ids) + 1;
      if (num < max_boxes) {
        ids[hook(1, num)] = adr;
        work[hook(0, adr)] = -1 * num;
        sizes_out[hook(3, num - 1)] = size;
      }
    }
  }
}