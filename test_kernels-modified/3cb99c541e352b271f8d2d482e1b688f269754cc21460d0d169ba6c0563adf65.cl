//{"data":0,"histogram":2,"local_histogram":3,"num_data":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram(global int* data, int num_data, global int* histogram) {
  local int local_histogram[256];
  int lid = get_local_id(0);
  int gid = get_global_id(0);

  int sz_loc = get_local_size(0);
  int sz_gbl = get_global_size(0);

  for (int i = lid; i < 256; i += sz_loc) {
    local_histogram[hook(3, i)] = 0;
  }

  barrier(0x01);

  for (int i = gid; i < num_data; i += sz_gbl) {
    atomic_add(&local_histogram[hook(3, data[ihook(0, i))], 1);
  }

  barrier(0x01);

  for (int i = lid; i < 256; i += sz_loc) {
    atomic_add(&histogram[hook(2, i)], local_histogram[hook(3, i)]);
  }
}