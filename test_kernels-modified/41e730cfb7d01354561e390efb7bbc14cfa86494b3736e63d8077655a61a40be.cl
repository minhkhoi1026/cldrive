//{"local_table":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void write_wg_size_to_local_mem(void) {
  local unsigned int local_table[128];
  size_t wg_items = get_local_size(0);
  for (size_t i = 0; i < wg_items; i++) {
    local_table[hook(0, i)] = 0;
  }
}