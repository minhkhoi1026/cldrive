//{"a":0,"j":2,"k":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sort(global int* a, int k, int j) {
  int i = get_global_id(0);
  int ixj = i ^ j;

  if (ixj > i) {
    int iValue = a[hook(0, i)], ixjValue = a[hook(0, ixj)];

    if ((i & k) == 0 && iValue > ixjValue) {
      a[hook(0, i)] = ixjValue;
      a[hook(0, ixj)] = iValue;
    }
    if ((i & k) != 0 && iValue < ixjValue) {
      a[hook(0, i)] = ixjValue;
      a[hook(0, ixj)] = iValue;
    }
  }
}