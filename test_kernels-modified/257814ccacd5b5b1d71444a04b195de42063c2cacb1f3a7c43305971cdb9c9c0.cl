//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void squareArray(global const float* restrict const in, global float* restrict const out) {
  const int offset = get_global_id(0);
  out[hook(1, offset)] = in[hook(0, offset)] * in[hook(0, offset)];
}