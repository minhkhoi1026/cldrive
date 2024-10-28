//{"val":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void _opencl_unsigned_inc(global unsigned* val) {
  val[hook(0, 0)]++;
}