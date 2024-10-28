//{"destValues":1,"sourceValues":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_conversion(global char* sourceValues, global char2* destValues) {
  int tid = get_global_id(0);
  char src = sourceValues[hook(0, tid)];

  destValues[hook(1, tid)] = (char2)src;
}