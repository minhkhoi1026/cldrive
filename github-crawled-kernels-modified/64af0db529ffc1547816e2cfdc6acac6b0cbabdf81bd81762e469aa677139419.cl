//{"a":0,"aoffset":1,"c":3,"factor":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scaleAdd_scalar(global double* a, const int aoffset, const double factor, const double c) {
  int i = get_global_id(0) + aoffset;
  a[hook(0, i)] = a[hook(0, i)] * factor + c;
}