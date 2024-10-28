//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_group_size(global unsigned int* dst) {
  unsigned int idx = (unsigned int)get_global_id(0);
  unsigned int idy = (unsigned int)get_global_id(1);
  unsigned int idz = (unsigned int)get_global_id(2);
  unsigned int size_x = (unsigned int)get_global_size(0);
  unsigned int size_y = (unsigned int)get_global_size(1);

  dst[hook(0, idz * size_x * size_y + idy * size_x + idx)] = idz * size_x * size_y + idy * size_x + idx;
}