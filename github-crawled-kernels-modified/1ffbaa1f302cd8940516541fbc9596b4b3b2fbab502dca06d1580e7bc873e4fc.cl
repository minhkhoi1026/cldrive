//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void loop0(global float* a) {
  int id = get_local_id(0);
  float16 v = vload16(id, a);
  vstore16(v * 2, id, a);
}