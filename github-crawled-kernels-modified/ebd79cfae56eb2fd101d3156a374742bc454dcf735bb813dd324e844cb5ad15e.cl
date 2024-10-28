//{"offset_x":1,"stride_x":2,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void act_tanh(global float* x, unsigned int offset_x, const unsigned int stride_x) {
  const unsigned int ix = offset_x + get_global_id(0) + get_global_id(1) * stride_x;
  x[hook(0, ix)] = tanh(x[hook(0, ix)]);
}