//{"bitcount_table":0,"bitstrings":1,"bs":4,"bs_len":2,"counter":6,"radius":5,"sample":3,"selected":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void single_scan(constant const uchar* bitcount_table, global const ulong* bitstrings, const unsigned int bs_len, const unsigned int sample, constant const ulong* bs, const unsigned int radius, global unsigned int* counter, global uchar* selected) {
  unsigned int id = get_global_id(0);

  ulong a;
  unsigned int dist;

  dist = 0;
  for (unsigned int j = 0; j < bs_len; j++) {
    a = bitstrings[hook(1, id * bs_len + j)] ^ bs[hook(4, j)];
    dist += popcount(a);
  }
  selected[hook(7, id)] = (dist <= radius);
}