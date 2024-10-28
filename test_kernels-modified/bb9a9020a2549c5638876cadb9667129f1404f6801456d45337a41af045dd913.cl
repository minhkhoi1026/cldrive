//{"output":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void private_array_initializer_list(global float* output) {
  float scratch[4] = {7.f, 42.f, -1.f, 0.f};

  for (int i = 0; i < 4; i++) {
    output[hook(0, i)] = scratch[hook(1, i)];
  }
}