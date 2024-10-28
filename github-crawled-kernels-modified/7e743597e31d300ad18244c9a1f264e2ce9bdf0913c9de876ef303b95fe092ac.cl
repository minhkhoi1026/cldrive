//{"input_m1":0,"input_m2":1,"output":2,"width_m1":3,"width_m2":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_multiplication(global float* input_m1, global float* input_m2, global float* output, int width_m1, int width_m2) {
  int row = get_global_id(0);
  int col = get_global_id(1);
  float value = 0;

  for (int i = 0; i < width_m1; ++i) {
    value = value + ((float)input_m1[hook(0, row * width_m1 + i)] * (float)input_m2[hook(1, width_m2 * i + col)]);
  }

  output[hook(2, row * width_m2 + col)] = value;
}