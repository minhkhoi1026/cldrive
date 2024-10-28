//{"_buf0":2,"count":1,"init":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void serial_accumulate(int init, unsigned int count, global int* _buf0) {
  int result = init;
  for (unsigned int i = 0; i < count; i++)
    result = ((result) + ((0 + i)));
  _buf0[hook(2, 0)] = result;
}