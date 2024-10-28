//{"result":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_vector_creation4(global char* src, global char4* result) {
  result[hook(1, 0)] = (char4)(src[hook(0, 0)], src[hook(0, 1)], src[hook(0, 2)], src[hook(0, 3)]);
  result[hook(1, 1)] = (char4)(src[hook(0, 0)], src[hook(0, 1)], vload2(0, src + 2));
  result[hook(1, 2)] = (char4)(src[hook(0, 0)], vload2(0, src + 1), src[hook(0, 3)]);
  result[hook(1, 3)] = (char4)(src[hook(0, 0)], vload3(0, src + 1));
  result[hook(1, 4)] = (char4)(vload2(0, src + 0), src[hook(0, 2)], src[hook(0, 3)]);
  result[hook(1, 5)] = (char4)(vload2(0, src + 0), vload2(0, src + 2));
  result[hook(1, 6)] = (char4)(vload3(0, src + 0), src[hook(0, 3)]);
  result[hook(1, 7)] = (char4)(vload4(0, src + 0));
}