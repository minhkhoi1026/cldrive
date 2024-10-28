//{"chids":5,"config":0,"index":2,"input":1,"lits":6,"offsets":3,"rids":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void sort_rids_by_value(global unsigned int* input, global unsigned int* rids, size_t li, size_t work_size);
void produce_chunk_id_literals(global unsigned int* rids, global unsigned int* chids, global unsigned int* lits, size_t li, size_t work_size);
size_t merged_lit_by_val_chids(global unsigned int* input, global unsigned int* chids, global unsigned int* lits, size_t li, size_t work_size);
void produce_fills(global unsigned int* input, global unsigned int* chids, size_t li, size_t work_size);
size_t fuse_fill_literals(global unsigned int* chids, global unsigned int* lits, global unsigned int* index, size_t li, size_t work_size);
size_t compute_colum_length(global unsigned int* input, global unsigned int* chids, global unsigned int* offsets, size_t li, size_t work_size);
void parallel_selection_sort(global unsigned int* key, global unsigned int* data, size_t li, size_t work_size);
size_t reduce_by_key_OR(global unsigned int* keys_high, global unsigned int* keys_low, global unsigned int* data, size_t li, size_t work_size);
size_t reduce_by_key_SUM(global unsigned int* keys, local unsigned int* data, size_t li, size_t work_size);
kernel void kernel_wah_index(global unsigned int* config, global unsigned int* input, global unsigned int* index, global unsigned int* offsets, global unsigned int* rids, global unsigned int* chids, global unsigned int* lits) {
  unsigned int num_local = get_local_size(0);

  unsigned int li = get_local_id(0);
  unsigned int wg = get_group_id(0);
  unsigned int cfg_pos = (wg * 2) + 2;
  unsigned int num_wg = config[hook(0, 1)];
  unsigned int work_size = config[hook(0, cfg_pos)];
  unsigned int offset = wg * num_local;

  global unsigned int* work_input = input + offset;
  global unsigned int* work_index = index + (offset * 2);
  global unsigned int* work_offsets = offsets + offset;
  global unsigned int* work_rids = rids + offset;
  global unsigned int* work_chids = chids + offset;
  global unsigned int* work_lits = lits + offset;

  if (li < work_size && wg < num_wg) {
    sort_rids_by_value(work_input, work_rids, li, work_size);
    barrier(0x01);
    produce_chunk_id_literals(work_rids, work_chids, work_lits, li, work_size);
    barrier(0x01);
    size_t k = merged_lit_by_val_chids(work_input, work_chids, work_lits, li, work_size);
    barrier(0x01);
    produce_fills(work_input, work_chids, li, k);
    barrier(0x01);
    unsigned int length = fuse_fill_literals(work_chids, work_lits, work_index, li, k);
    barrier(0x01);
    unsigned int keycnt = compute_colum_length(work_input, work_chids, work_offsets, li, k);
    barrier(0x01);
    config[hook(0, cfg_pos)] = keycnt;
    config[hook(0, cfg_pos + 1)] = length;
  }
}