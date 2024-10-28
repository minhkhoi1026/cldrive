//{"a_gpu":0,"b_gpu":1,"res_gpu":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_multi(global const float* a_gpu, global const float* b_gpu, global float* res_gpu) {
  int tx = get_global_id(0);
  int ty = get_global_id(1);
  int ssize = 32;

  int k = 0;
  for (k = 0; k < ssize; k++) {
    int a_element = a_gpu[hook(0, tx + ty * ssize + k)];
    int b_element = b_gpu[hook(1, tx + ty * ssize + k)];
    res_gpu[hook(2, tx + ty * ssize + k)] = a_element + b_element;
  }
}