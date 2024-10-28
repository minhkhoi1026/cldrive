//{"a":0,"nelem":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foobar(global int* a, const int nelem) {
  int id = get_global_id(0);
  if (id < nelem)
    a[hook(0, id)] = nelem;
}