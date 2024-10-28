//{"NUM_BINS":4,"NUM_ITEMS":3,"g_in":0,"g_out":1,"local_buf":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int ccoord2ind(unsigned int dim, unsigned int row, unsigned int col) {
  return dim * col + row;
}

unsigned int rcoord2ind(unsigned int dim, unsigned int row, unsigned int col) {
  return dim * row + col;
}

kernel void histogram_part_private(global unsigned int const* const restrict g_in, global unsigned int* const restrict g_out,

                                   local unsigned int* const restrict local_buf,

                                   const unsigned int NUM_ITEMS, const unsigned int NUM_BINS) {
  unsigned int const group_bins = get_local_size(0) * NUM_BINS;
  unsigned int const group_offset = get_group_id(0) * group_bins;

  for (unsigned int c = 0; c < NUM_BINS; ++c) {
    local_buf[hook(2, ccoord2ind(get_local_size(0), get_local_id(0), c))] = 0;
  }

  unsigned int p;
  for (p = 1 * get_global_id(0); p < NUM_ITEMS - 1 + 1; p += 1 * get_global_size(0))

  {
    unsigned int cluster = g_in[hook(0, p)];

    local_buf[hook(2, ccoord2ind(get_local_size(0), get_local_id(0), cluster))] += 1;
  }

  for (unsigned int c = 0; c < NUM_BINS; ++c) {
    unsigned int cluster = local_buf[hook(2, ccoord2ind(get_local_size(0), get_local_id(0), c))];
    g_out[hook(1, group_offset + rcoord2ind(NUM_BINS, get_local_id(0), c))] = cluster;
  }
}