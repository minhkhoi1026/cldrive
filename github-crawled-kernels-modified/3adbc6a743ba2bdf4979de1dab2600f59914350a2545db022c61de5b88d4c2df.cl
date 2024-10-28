//{"A1":1,"A2":2,"B1":3,"B2":4,"res":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void largeArray(global int* res) {
  uchar4 A1[(1u << 28)];
  uchar4 A2[(1u << 28)];

  uchar8 B1[(1u << 28)];
  uchar8 B2[(1u << 28)];

  int i = get_global_id(0);
  res[hook(0, 0)] = A1[hook(1, i)].s0;
  res[hook(0, 1)] = A2[hook(2, i)].s0;
  res[hook(0, 2)] = B1[hook(3, i)].s0;
  res[hook(0, 3)] = B2[hook(4, i)].s0;
}