//{"data_in":0,"data_out":3,"mem_global_id":1,"mem_local_id":2,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pooling(global int* data_in, global int* mem_global_id, global int* mem_local_id, global int* data_out, int width) {
  int i, j;
  int global_id_x, global_id_y;
  int local_id_x, local_id_y;

  global_id_x = get_global_id(0);
  global_id_y = get_global_id(1);
  local_id_x = get_local_id(0);
  local_id_y = get_local_id(1);

  mem_global_id[hook(1, global_id_y * width + global_id_x)] = global_id_x * 10 + global_id_y;
  mem_local_id[hook(2, global_id_y * width + global_id_x)] = local_id_x * 10 + local_id_y;

  if ((global_id_x % 2 == 0) && (global_id_y % 2 == 0)) {
    int index1 = global_id_y * width + global_id_x;
    int index2 = global_id_y * width + global_id_x + width;
    int tmp1 = max(data_in[hook(0, index1)], data_in[hook(0, index1 + 1)]);
    int tmp2 = max(data_in[hook(0, index2)], data_in[hook(0, index2 + 1)]);
    int tmp = max(tmp1, tmp2);
    data_out[hook(3, global_id_y / 2 * width / 2 + global_id_x / 2)] = tmp;
  }
}