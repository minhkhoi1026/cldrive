//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void read_linear_uncached(global float* input, global float* output) {
  float val = (float)(0.0f);
  unsigned int gid = get_global_id(0);
  unsigned int index = gid;
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  val = val + input[hook(0, index += 2)];
  output[hook(1, gid)] = val;
}