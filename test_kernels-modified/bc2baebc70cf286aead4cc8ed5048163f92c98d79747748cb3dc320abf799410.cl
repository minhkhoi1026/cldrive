//{"result":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_vector_creation3(global char* src, global char* result) {
  vstore3((char3)(src[hook(0, 0)], src[hook(0, 1)], src[hook(0, 2)]), 0, result);
  vstore3((char3)(src[hook(0, 0)], vload2(0, src + 1)), 1, result);
  vstore3((char3)(vload2(0, src + 0), src[hook(0, 2)]), 2, result);
  vstore3((char3)(vload3(0, src + 0)), 3, result);
}