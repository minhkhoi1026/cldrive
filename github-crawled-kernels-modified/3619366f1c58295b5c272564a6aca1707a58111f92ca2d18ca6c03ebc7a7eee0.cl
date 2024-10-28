//{"alpha":4,"beta":5,"index1":11,"index2":12,"inputAT":6,"inputA_ncol":1,"inputA_nrow":0,"inputB":7,"inputB_ncol":3,"inputB_nrow":2,"output":8,"sum":10,"sum[0]":13,"sum[1]":14,"sum[i]":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm_d_dot4sum4x2(private int inputA_nrow, private int inputA_ncol, private int inputB_nrow, private int inputB_ncol, private double alpha, private double beta, global double4* inputAT, global double4* inputB, global double* output) {
  int output_col = 2 * get_global_id(0);
  int output_row = 4 * get_global_id(1);

  double sum[2][4];

  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 4; j++) {
      sum[hook(10, i)][hook(9, j)] = 0.0f;
    }
  }

  int index1[4];
  int index2[2];

  for (int k = 0; k < 4; k++) {
    index1[hook(11, k)] = inputA_ncol * (output_row + k) / 4;
  }
  for (int k = 0; k < 2; k++) {
    index2[hook(12, k)] = inputB_nrow * (output_col + k) / 4;
  }

  for (int k = 0; k < inputB_nrow / 4; k += 2) {
    sum[hook(10, 0)][hook(13, 0)] += dot(inputAT[hook(6, index1[0hook(11, 0) + k)], inputB[hook(7, index2[0hook(12, 0) + k)]) + dot(inputAT[hook(6, index1[0hook(11, 0) + k + 1)], inputB[hook(7, index2[0hook(12, 0) + k + 1)]);

    sum[hook(10, 0)][hook(13, 1)] += dot(inputAT[hook(6, index1[1hook(11, 1) + k)], inputB[hook(7, index2[0hook(12, 0) + k)]) + dot(inputAT[hook(6, index1[1hook(11, 1) + k + 1)], inputB[hook(7, index2[0hook(12, 0) + k + 1)]);

    sum[hook(10, 0)][hook(13, 2)] += dot(inputAT[hook(6, index1[2hook(11, 2) + k)], inputB[hook(7, index2[0hook(12, 0) + k)]) + dot(inputAT[hook(6, index1[2hook(11, 2) + k + 1)], inputB[hook(7, index2[0hook(12, 0) + k + 1)]);

    sum[hook(10, 0)][hook(13, 3)] += dot(inputAT[hook(6, index1[3hook(11, 3) + k)], inputB[hook(7, index2[0hook(12, 0) + k)]) + dot(inputAT[hook(6, index1[3hook(11, 3) + k + 1)], inputB[hook(7, index2[0hook(12, 0) + k + 1)]);

    sum[hook(10, 1)][hook(14, 0)] += dot(inputAT[hook(6, index1[0hook(11, 0) + k)], inputB[hook(7, index2[1hook(12, 1) + k)]) + dot(inputAT[hook(6, index1[0hook(11, 0) + k + 1)], inputB[hook(7, index2[1hook(12, 1) + k + 1)]);

    sum[hook(10, 1)][hook(14, 1)] += dot(inputAT[hook(6, index1[1hook(11, 1) + k)], inputB[hook(7, index2[1hook(12, 1) + k)]) + dot(inputAT[hook(6, index1[1hook(11, 1) + k + 1)], inputB[hook(7, index2[1hook(12, 1) + k + 1)]);

    sum[hook(10, 1)][hook(14, 2)] += dot(inputAT[hook(6, index1[2hook(11, 2) + k)], inputB[hook(7, index2[1hook(12, 1) + k)]) + dot(inputAT[hook(6, index1[2hook(11, 2) + k + 1)], inputB[hook(7, index2[1hook(12, 1) + k + 1)]);

    sum[hook(10, 1)][hook(14, 3)] += dot(inputAT[hook(6, index1[3hook(11, 3) + k)], inputB[hook(7, index2[1hook(12, 1) + k)]) + dot(inputAT[hook(6, index1[3hook(11, 3) + k + 1)], inputB[hook(7, index2[1hook(12, 1) + k + 1)]);
  }

  int index;

  index = (output_col + 0) * inputA_nrow + (output_row + 0);
  output[hook(8, index)] *= beta;
  output[hook(8, index)] += alpha * sum[hook(10, 0)][hook(13, 0)];

  index = (output_col + 0) * inputA_nrow + (output_row + 1);
  output[hook(8, index)] *= beta;
  output[hook(8, index)] += alpha * sum[hook(10, 0)][hook(13, 1)];

  index = (output_col + 0) * inputA_nrow + (output_row + 2);
  output[hook(8, index)] *= beta;
  output[hook(8, index)] += alpha * sum[hook(10, 0)][hook(13, 2)];

  index = (output_col + 0) * inputA_nrow + (output_row + 3);
  output[hook(8, index)] *= beta;
  output[hook(8, index)] += alpha * sum[hook(10, 0)][hook(13, 3)];

  index = (output_col + 1) * inputA_nrow + (output_row + 0);
  output[hook(8, index)] *= beta;
  output[hook(8, index)] += alpha * sum[hook(10, 1)][hook(14, 0)];

  index = (output_col + 1) * inputA_nrow + (output_row + 1);
  output[hook(8, index)] *= beta;
  output[hook(8, index)] += alpha * sum[hook(10, 1)][hook(14, 1)];

  index = (output_col + 1) * inputA_nrow + (output_row + 2);
  output[hook(8, index)] *= beta;
  output[hook(8, index)] += alpha * sum[hook(10, 1)][hook(14, 2)];

  index = (output_col + 1) * inputA_nrow + (output_row + 3);
  output[hook(8, index)] *= beta;
  output[hook(8, index)] += alpha * sum[hook(10, 1)][hook(14, 3)];
}