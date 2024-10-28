//{"count":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void TestLoopBarrier(global float* input, global float* output, const unsigned int count) {
  int i = get_global_id(0);
  output[hook(1, i)] = input[hook(0, i)] * input[hook(0, i)];

  for (unsigned j = 0; j < 10; ++j) {
    barrier(0x01);
    output[hook(1, i)] -= count;
    barrier(0x01);
  }
}