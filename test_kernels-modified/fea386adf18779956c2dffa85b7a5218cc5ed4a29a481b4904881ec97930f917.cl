//{"addresses":0,"labels_current":1,"labels_last":2,"max_num_pairs":5,"num_pairs":4,"pairs":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void gather_label_pairs(global int* addresses, global int* labels_current, global int* labels_last, global int* pairs, int num_pairs, int max_num_pairs) {
  int tidx = get_global_id(0);
  if (tidx < max_num_pairs && tidx < num_pairs) {
    int adr = addresses[hook(0, tidx + 1)];
    int2 pair = (int2)(-1 * labels_current[hook(1, adr)], -1 * labels_last[hook(2, adr)]);

    vstore2(pair, tidx, pairs);
  }
}