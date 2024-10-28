//{"bitcount_table":0,"bitstrings":1,"bs":4,"bs_len":2,"counter":6,"partial_dist":8,"radius":5,"row":9,"sample":3,"selected":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void single_scan3(constant const uchar* bitcount_table, global const ulong* bitstrings, const unsigned int bs_len, const unsigned int sample, constant const ulong* bs, const unsigned int radius, global unsigned int* counter, global unsigned int* selected, local unsigned int* partial_dist) {
  unsigned int dist;
  ulong a;
  unsigned int j;

  for (unsigned int id = get_group_id(0); id < sample; id += get_num_groups(0)) {
    const global ulong* row = bitstrings + id * bs_len;

    dist = 0;
    j = get_local_id(0);
    if (j < bs_len) {
      a = row[hook(9, j)] ^ bs[hook(4, j)];
      dist = popcount(a);
    }
    partial_dist[hook(8, get_local_id(0))] = dist;

    for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride /= 2) {
      barrier(0x01);
      if (get_local_id(0) < stride) {
        partial_dist[hook(8, get_local_id(0))] += partial_dist[hook(8, get_local_id(0) + stride)];
      }
    }

    if (get_local_id(0) == 0) {
      if (partial_dist[hook(8, 0)] <= radius) {
        selected[hook(7, atomic_inc(counter))] = id;
      }
    }

    barrier(0x01);
  }
}