//{"a":0,"b":1,"row":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float addRows(global float* row) {
  float ret = 0.0f;
  for (int i = 0; i < 20; i++) {
    ret = ret + row[hook(2, i)];
  }
  return ret;
}
kernel void add(global float* a, global float* b) {
  int id = get_global_id(0);
  b[hook(1, id)] = 0.0f;
  b[hook(1, id)] = addRows(&a[hook(0, id * 10)]);
}