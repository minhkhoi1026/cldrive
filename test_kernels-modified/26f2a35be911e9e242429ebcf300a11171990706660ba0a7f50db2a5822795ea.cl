//{"alpha":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sscal_noinc(float alpha, global float* x) {
  const unsigned int gid = get_global_id(0);
  x[hook(1, gid)] *= alpha;
}