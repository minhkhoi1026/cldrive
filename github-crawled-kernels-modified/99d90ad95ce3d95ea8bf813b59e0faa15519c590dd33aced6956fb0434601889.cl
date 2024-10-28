//{"buffer":0,"local_input":1,"vec_size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global unsigned* restrict buffer, local unsigned* restrict local_input, const unsigned vec_size) {
  unsigned i, j;
  size_t gid = get_global_id(0);
  size_t lid = get_local_id(0);
  size_t lsize = get_local_size(0);
  event_t event_read, event_write;

  event_read = async_work_group_copy(local_input, &buffer[hook(0, gid * vec_size * lsize)], vec_size * lsize, 0);
  for (i = 0; i < vec_size; i++) {
    if (i == 0)
      wait_group_events(1, &event_read);
    local_input[hook(1, i * lsize + lid)]++;
  }
  event_write = async_work_group_copy(&buffer[hook(0, gid * vec_size * lsize)], local_input, vec_size * lsize, event_write);
  wait_group_events(1, &event_write);
}