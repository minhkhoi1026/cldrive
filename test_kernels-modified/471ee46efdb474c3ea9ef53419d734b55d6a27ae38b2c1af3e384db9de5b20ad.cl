//{"input":0,"o":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct orientation {
  float x;
  float y;
  float z;
};

kernel void cubefloat(global float* input, global float* output, const struct orientation o) {
  int i = get_global_id(0);
  output[hook(1, i)] = input[hook(0, i)] * input[hook(0, i)] * input[hook(0, i)] + o.x;
}