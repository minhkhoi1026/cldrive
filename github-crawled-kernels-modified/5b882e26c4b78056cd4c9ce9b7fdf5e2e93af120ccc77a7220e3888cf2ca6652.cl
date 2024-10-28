//{"indices":0,"input":1,"output":2,"scratch":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void uninitialized_private_array(global unsigned int* indices, global float* input, global float* output) {
  float scratch[4];

  for (int i = 0; i < 4; i++) {
    scratch[hook(3, indices[ihook(0, i))] = i;
  }

  for (int i = 0; i < 4; i++) {
    output[hook(2, i)] = scratch[hook(3, i)];
  }
}