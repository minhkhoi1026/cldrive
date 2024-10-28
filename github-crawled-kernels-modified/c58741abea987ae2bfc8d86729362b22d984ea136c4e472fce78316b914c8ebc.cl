//{"a":0,"b":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void find_unit_circles(global float16* a, global float16* b, global float16* result) {
  unsigned int id = get_global_id(0);
  float16 x = a[hook(0, id)];
  float16 y = b[hook(1, id)];
  float16 tresult = sin(x) * sin(x) + cos(y) * cos(y);
  result[hook(2, id)] = tresult;
}