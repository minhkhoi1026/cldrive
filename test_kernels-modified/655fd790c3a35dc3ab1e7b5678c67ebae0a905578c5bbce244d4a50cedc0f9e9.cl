//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel8VFloat(const float8 input, global float8* output) {
  int i = get_global_id(0);
  if (i < 10)
    output[hook(1, i)] = convert_float8(input);
}