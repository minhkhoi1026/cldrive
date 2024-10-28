//{"a":0,"alpha":3,"b":1,"beta":4,"col":5,"com":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dots(global double* a, global double* b, unsigned char com, double alpha, double beta, unsigned long col) {
  unsigned long current = get_global_id(0) * col + get_global_id(1);
  double aa, bb;
  if (com) {
    aa = a[hook(0, current)];
    bb = b[hook(1, current)];
    a[hook(0, current)] = alpha * aa - beta * bb;
    b[hook(1, current)] = alpha * bb + beta * aa;
  } else {
    a[hook(0, current)] *= alpha;
  }
}