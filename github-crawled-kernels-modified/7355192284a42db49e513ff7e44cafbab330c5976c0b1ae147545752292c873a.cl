//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void read_single(global float* input, global float* output) {
  float val = (float)(0.0f);
  unsigned int gid = get_global_id(0);
  unsigned int index = 0;
  val = val + input[hook(0, index + 0)];
  val = val + input[hook(0, index + 1)];
  val = val + input[hook(0, index + 2)];
  val = val + input[hook(0, index + 3)];
  val = val + input[hook(0, index + 4)];
  val = val + input[hook(0, index + 5)];
  val = val + input[hook(0, index + 6)];
  val = val + input[hook(0, index + 7)];
  val = val + input[hook(0, index + 8)];
  val = val + input[hook(0, index + 9)];
  val = val + input[hook(0, index + 10)];
  val = val + input[hook(0, index + 11)];
  val = val + input[hook(0, index + 12)];
  val = val + input[hook(0, index + 13)];
  val = val + input[hook(0, index + 14)];
  val = val + input[hook(0, index + 15)];
  val = val + input[hook(0, index + 16)];
  val = val + input[hook(0, index + 17)];
  val = val + input[hook(0, index + 18)];
  val = val + input[hook(0, index + 19)];
  val = val + input[hook(0, index + 20)];
  val = val + input[hook(0, index + 21)];
  val = val + input[hook(0, index + 22)];
  val = val + input[hook(0, index + 23)];
  val = val + input[hook(0, index + 24)];
  val = val + input[hook(0, index + 25)];
  val = val + input[hook(0, index + 26)];
  val = val + input[hook(0, index + 27)];
  val = val + input[hook(0, index + 28)];
  val = val + input[hook(0, index + 29)];
  val = val + input[hook(0, index + 30)];
  val = val + input[hook(0, index + 31)];
  output[hook(1, gid)] = val;
}