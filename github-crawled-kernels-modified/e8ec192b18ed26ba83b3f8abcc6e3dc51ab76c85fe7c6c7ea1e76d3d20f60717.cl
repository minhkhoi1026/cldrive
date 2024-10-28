//{"d_I":1,"d_Ne":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void extract_kernel(long d_Ne, global float* d_I) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);
  int ei = (bx * 32) + tx;

  if (ei < d_Ne) {
    d_I[hook(1, ei)] = exp(d_I[hook(1, ei)] / 255);
  }
}