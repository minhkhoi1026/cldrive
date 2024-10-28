//{"index1":6,"index2":7,"input":2,"input_ncol":1,"input_nrow":0,"output":3,"sum":5,"sum[0]":8,"sum[1]":9,"sum[i]":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void crossprod_f_dot4sum4x2(private int input_nrow, private int input_ncol, global float4* input, global float* output) {
  int output_col = 2 * get_global_id(0);
  int output_row = 4 * get_global_id(1);

  if (output_col >= output_row) {
    float sum[2][4];
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 4; j++) {
        sum[hook(5, i)][hook(4, j)] = 0.0f;
      }
    }

    int index1[2];
    int index2[4];
    for (int k = 0; k < 2; k++) {
      index1[hook(6, k)] = input_nrow * (output_col + k) / 4;
    }
    for (int k = 0; k < 4; k++) {
      index2[hook(7, k)] = input_nrow * (output_row + k) / 4;
    }

    for (int k = 0; k < input_nrow / 4; k += 2) {
      sum[hook(5, 0)][hook(8, 0)] += dot(input[hook(2, index1[0hook(6, 0) + k)], input[hook(2, index2[0hook(7, 0) + k)]) + dot(input[hook(2, index1[0hook(6, 0) + k + 1)], input[hook(2, index2[0hook(7, 0) + k + 1)]);

      sum[hook(5, 1)][hook(9, 0)] += dot(input[hook(2, index1[1hook(6, 1) + k)], input[hook(2, index2[0hook(7, 0) + k)]) + dot(input[hook(2, index1[1hook(6, 1) + k + 1)], input[hook(2, index2[0hook(7, 0) + k + 1)]);

      sum[hook(5, 0)][hook(8, 1)] += dot(input[hook(2, index1[0hook(6, 0) + k)], input[hook(2, index2[1hook(7, 1) + k)]) + dot(input[hook(2, index1[0hook(6, 0) + k + 1)], input[hook(2, index2[1hook(7, 1) + k + 1)]);

      sum[hook(5, 1)][hook(9, 1)] += dot(input[hook(2, index1[1hook(6, 1) + k)], input[hook(2, index2[1hook(7, 1) + k)]) + dot(input[hook(2, index1[1hook(6, 1) + k + 1)], input[hook(2, index2[1hook(7, 1) + k + 1)]);

      sum[hook(5, 0)][hook(8, 2)] += dot(input[hook(2, index1[0hook(6, 0) + k)], input[hook(2, index2[2hook(7, 2) + k)]) + dot(input[hook(2, index1[0hook(6, 0) + k + 1)], input[hook(2, index2[2hook(7, 2) + k + 1)]);

      sum[hook(5, 1)][hook(9, 2)] += dot(input[hook(2, index1[1hook(6, 1) + k)], input[hook(2, index2[2hook(7, 2) + k)]) + dot(input[hook(2, index1[1hook(6, 1) + k + 1)], input[hook(2, index2[2hook(7, 2) + k + 1)]);

      sum[hook(5, 0)][hook(8, 3)] += dot(input[hook(2, index1[0hook(6, 0) + k)], input[hook(2, index2[3hook(7, 3) + k)]) + dot(input[hook(2, index1[0hook(6, 0) + k + 1)], input[hook(2, index2[3hook(7, 3) + k + 1)]);

      sum[hook(5, 1)][hook(9, 3)] += dot(input[hook(2, index1[1hook(6, 1) + k)], input[hook(2, index2[3hook(7, 3) + k)]) + dot(input[hook(2, index1[1hook(6, 1) + k + 1)], input[hook(2, index2[3hook(7, 3) + k + 1)]);
    }

    output[hook(3, (output_row + 0) * input_ncol + (output_col + 0))] = sum[hook(5, 0)][hook(8, 0)];
    output[hook(3, (output_col + 0) * input_ncol + (output_row + 0))] = sum[hook(5, 0)][hook(8, 0)];

    output[hook(3, (output_row + 0) * input_ncol + (output_col + 1))] = sum[hook(5, 1)][hook(9, 0)];
    output[hook(3, (output_col + 1) * input_ncol + (output_row + 0))] = sum[hook(5, 1)][hook(9, 0)];

    output[hook(3, (output_row + 1) * input_ncol + (output_col + 0))] = sum[hook(5, 0)][hook(8, 1)];
    output[hook(3, (output_col + 0) * input_ncol + (output_row + 1))] = sum[hook(5, 0)][hook(8, 1)];

    output[hook(3, (output_row + 1) * input_ncol + (output_col + 1))] = sum[hook(5, 1)][hook(9, 1)];
    output[hook(3, (output_col + 1) * input_ncol + (output_row + 1))] = sum[hook(5, 1)][hook(9, 1)];

    output[hook(3, (output_row + 2) * input_ncol + (output_col + 0))] = sum[hook(5, 0)][hook(8, 2)];
    output[hook(3, (output_col + 0) * input_ncol + (output_row + 2))] = sum[hook(5, 0)][hook(8, 2)];

    output[hook(3, (output_row + 2) * input_ncol + (output_col + 1))] = sum[hook(5, 1)][hook(9, 2)];
    output[hook(3, (output_col + 1) * input_ncol + (output_row + 2))] = sum[hook(5, 1)][hook(9, 2)];

    output[hook(3, (output_row + 3) * input_ncol + (output_col + 0))] = sum[hook(5, 0)][hook(8, 3)];
    output[hook(3, (output_col + 0) * input_ncol + (output_row + 3))] = sum[hook(5, 0)][hook(8, 3)];

    output[hook(3, (output_row + 3) * input_ncol + (output_col + 1))] = sum[hook(5, 1)][hook(9, 3)];
    output[hook(3, (output_col + 1) * input_ncol + (output_row + 3))] = sum[hook(5, 1)][hook(9, 3)];
  }
}