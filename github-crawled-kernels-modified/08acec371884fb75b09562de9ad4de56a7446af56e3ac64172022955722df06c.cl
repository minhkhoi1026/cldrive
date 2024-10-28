//{"filter":2,"input":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolution_naive(global float* output, global float* input, global float* filter) {
  int x = get_group_id(0) * get_local_size(0) + get_local_id(0);
  int y = get_group_id(1) * get_local_size(1) + get_local_id(1);
  int i, j;
  float sum = 0.0;

  if (y < 4096 && x < 4096) {
    for (j = 0; j < 17; j++) {
      for (i = 0; i < 17; i++) {
        sum += input[hook(1, (y + j) * (4096 + ((17 / 2) * 2)) + (x + i))] * filter[hook(2, j * 17 + i)];
      }
    }

    output[hook(0, y * 4096 + x)] = sum;
  }
}