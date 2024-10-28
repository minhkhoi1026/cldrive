//{"a":0,"aColumns":1,"b":2,"bColumns":3,"c":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mulMatFloat(global const float* a, int aColumns, global const float* b, int bColumns, global float* c) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  float total = 0;
  int iOff = i * aColumns;
  for (int k = 0; k < aColumns; k++) {
    total += a[hook(0, iOff + k)] * b[hook(2, k * bColumns + j)];
  }
  c[hook(4, i * bColumns + j)] = total;
}