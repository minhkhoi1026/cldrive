//{"input":0,"mac":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct MAC {
  float mult;
  float add;
};

kernel void macfloat(global float* input, global float* output, const struct MAC mac) {
  int i = get_global_id(0);
  output[hook(1, i)] = input[hook(0, i)] * mac.mult + mac.add;
}