//{"bitcount_table":0,"bitstrings":1,"bs":4,"bs_len":2,"counter":6,"partial_dist":8,"radius":5,"row":9,"sample":3,"selected":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void single_scan1(constant const uchar* bitcount_table, global const ulong* bitstrings, const unsigned int bs_len, const unsigned int sample, constant const ulong* bs, const unsigned int radius, global unsigned int* counter, global unsigned int* selected, local unsigned int* partial_dist) {
  unsigned int id;
  ulong a;
  unsigned int dist;
  const global ulong* row;

  for (id = get_global_id(0); id < sample; id += get_global_size(0)) {
    row = bitstrings + id * bs_len;

    dist = 0;
    for (unsigned int j = 0; j < bs_len; j++) {
      a = row[hook(9, j)] ^ bs[hook(4, j)];
      dist += popcount(a);
    }
    if (dist <= radius) {
      selected[hook(7, atomic_inc(counter))] = id;
    }
  }
}