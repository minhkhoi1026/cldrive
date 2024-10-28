//{"input":0,"output":1,"shared":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void TestBarrier2(global float* input, global float* output, local float* shared) {
  int i = get_global_id(0);
  int l = get_local_id(0);

  shared[hook(2, l)] = input[hook(0, i)];

  barrier(0x01);

  output[hook(1, i)] = (l >= get_local_size(0) - 4) ? 0.f : shared[hook(2, l + 4)];
}