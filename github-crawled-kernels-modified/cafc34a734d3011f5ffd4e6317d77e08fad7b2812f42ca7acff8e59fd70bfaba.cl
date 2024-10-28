//{"data_in":0,"data_out":3,"length":4,"mem_global_id":1,"mem_local_id":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_vec(global int* data_in, global int* mem_global_id, global int* mem_local_id, global int* data_out, int length) {
  int i, j;
  int global_id;
  int local_id;

  global_id = get_global_id(0);
  local_id = get_local_id(0);

  mem_global_id[hook(1, global_id)] = global_id;
  mem_local_id[hook(2, global_id)] = local_id;

  for (i = 0; i < length; i++) {
    data_out[hook(3, i)] = data_in[hook(0, i)] * 2;
  }
}