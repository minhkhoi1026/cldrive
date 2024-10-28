//{"nx":2,"offset":1,"val":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_mult_opencl(global unsigned* val, unsigned offset, unsigned nx) {
  const int i = get_global_id(0);
  val = (global void*)val + offset;
  if (i < nx) {
    val[hook(0, i)] *= 2;
  }
}