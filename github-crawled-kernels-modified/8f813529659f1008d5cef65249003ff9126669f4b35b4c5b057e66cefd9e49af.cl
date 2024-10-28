//{"input":2,"input_ncol":1,"input_nrow":0,"output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void crossprod_d_naive(private int input_nrow, private int input_ncol, global double* input, global double* output) {
  int output_col = get_global_id(0);
  int output_row = get_global_id(1);

  if (output_col >= output_row) {
    double sum = 0.0;
    int index1 = input_nrow * output_col;
    int index2 = input_nrow * output_row;
    for (int k = 0; k < input_nrow; k++) {
      sum += input[hook(2, index1 + k)] * input[hook(2, index2 + k)];
    }

    output[hook(3, output_row * input_ncol + output_col)] = sum;
    output[hook(3, output_col * input_ncol + output_row)] = sum;
  }
}