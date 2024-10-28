//{"count":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void TestBarrier(global float* input, global float* output, const unsigned int count) {
  int i = get_global_id(0);

  float x = input[hook(0, i)];
  float f = x * x - count;

  barrier(0x01);

  output[hook(1, i)] = f;
}