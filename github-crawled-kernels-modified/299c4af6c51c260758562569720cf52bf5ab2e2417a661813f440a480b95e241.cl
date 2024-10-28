//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global float a[], global float b[]) {
  int id = get_global_id(0);
  float8 v1 = vload8(id, a);
  float8 v2 = vload8(id, b);
  v1 += v2;
  vstore8(v1, id, a);
}