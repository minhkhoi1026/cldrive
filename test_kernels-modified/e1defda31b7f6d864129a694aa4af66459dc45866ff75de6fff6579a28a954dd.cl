//{"d1":0,"d2":1,"n":2,"result":3,"type":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void createSpace(double d1, double d2, double n, global double* result, int type) {
  int i = get_global_id(0);
  double n1 = floor(n) - 1;

  double value = d1 + i * (d2 - d1) / n1;

  if (type == 1)
    result[hook(3, i)] = value;
  else
    result[hook(3, i)] = pown(value, 10);

  if (i == n1) {
    result[hook(3, 0)] = d1;
    result[hook(3, i)] = d2;
  }

  return;
}