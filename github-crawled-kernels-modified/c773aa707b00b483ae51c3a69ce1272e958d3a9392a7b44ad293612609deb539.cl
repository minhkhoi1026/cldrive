//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_vect_compare(global int4* src, global int4* dst) {
  int4 test = (int4)(0, 0, 0, 0);

  dst[hook(1, get_global_id(0))] = test < src[hook(0, get_global_id(0))];
}