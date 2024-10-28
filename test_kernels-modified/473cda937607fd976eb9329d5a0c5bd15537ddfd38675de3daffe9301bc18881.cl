//{"data":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_private_data_overflow(global int4* output) {
  int4 data[65];
  for (int i = 0; i < 65; ++i) {
    data[hook(1, i)] = (int4)i;
  }
  if (get_global_id(0) == 1)
    *output = data[hook(1, 0)];
}