//{"a":0,"b":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void filter_by_selection(global float8* a, global float8* b, global float8* result) {
  uint8 mask = (uint8)(0, -1, 0, -1, 0, -1, 0, -1);

  unsigned int id = get_global_id(0);
  float8 in1 = a[hook(0, id + 1)];
  float8 in2 = b[hook(1, id + 1)];
  result[hook(2, id + 1)] = select(in1, in2, mask);
}