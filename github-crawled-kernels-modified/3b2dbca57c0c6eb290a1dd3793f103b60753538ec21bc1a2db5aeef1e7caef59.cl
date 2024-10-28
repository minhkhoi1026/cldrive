//{"input":2,"input_ncol":1,"input_nrow":0,"output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void crossprod_f_naive8(private int input_nrow, private int input_ncol, global float8* input, global float* output) {
  int output_col = get_global_id(0);
  int output_row = get_global_id(1);

  if (output_col >= output_row) {
    float sum = 0.0f;
    int index1 = input_nrow * output_col / 8;
    int index2 = input_nrow * output_row / 8;
    for (int k = 0; k < input_nrow / 8; k++) {
      sum += dot(input[hook(2, index1 + k)].hi, input[hook(2, index2 + k)].hi) + dot(input[hook(2, index1 + k)].lo, input[hook(2, index2 + k)].lo);
    }

    output[hook(3, output_row * input_ncol + output_col)] = sum;
    output[hook(3, output_col * input_ncol + output_row)] = sum;
  }
}