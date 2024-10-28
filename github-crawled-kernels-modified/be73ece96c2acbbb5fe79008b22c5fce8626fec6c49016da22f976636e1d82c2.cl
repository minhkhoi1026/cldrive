//{"alpha":4,"beta":5,"inputAT":6,"inputA_ncol":1,"inputA_nrow":0,"inputB":7,"inputB_ncol":3,"inputB_nrow":2,"output":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm_f_naive8(private int inputA_nrow, private int inputA_ncol, private int inputB_nrow, private int inputB_ncol, private float alpha, private float beta, global float8* inputAT, global float8* inputB, global float* output) {
  int output_col = get_global_id(0);
  int output_row = get_global_id(1);

  float sum = 0.0f;
  int index1 = inputA_ncol * output_row / 8;
  int index2 = inputB_nrow * output_col / 8;
  for (int k = 0; k < inputB_nrow / 8; k++) {
    sum += dot(inputAT[hook(6, index1 + k)].hi, inputB[hook(7, index2 + k)].hi) + dot(inputAT[hook(6, index1 + k)].lo, inputB[hook(7, index2 + k)].lo);
  }

  output[hook(8, output_col * inputA_nrow + output_row)] *= beta;
  output[hook(8, output_col * inputA_nrow + output_row)] += alpha * sum;
}