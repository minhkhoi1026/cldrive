//{"alpha":0,"incx":2,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sscal_naive(float alpha, global float* x, unsigned int incx) {
  const unsigned int gid = get_global_id(0);
  x[hook(1, gid * incx)] *= alpha;
}