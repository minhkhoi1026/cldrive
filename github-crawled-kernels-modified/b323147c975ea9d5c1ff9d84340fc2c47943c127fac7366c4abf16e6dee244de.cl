//{"activationtype":3,"biases":1,"inputOutput":0,"numberOfPartitions":5,"outputSize":4,"useBias":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixVectorMultSecond(global float* inputOutput, global float* biases, const int useBias, const int activationtype, const int outputSize, const int numberOfPartitions) {
  float sum = 0.0;
  int currentRow = get_global_id(0);
  for (int i = 0; i < numberOfPartitions; i++) {
    sum += inputOutput[hook(0, mad24(outputSize, i, currentRow))];
  }
  if (useBias == 1)
    sum += biases[hook(1, currentRow)];
  if (activationtype == 1)
    inputOutput[hook(0, currentRow)] = clamp(sum, 0.0f, 0x1.fffffep127f);
  else
    inputOutput[hook(0, currentRow)] = clamp(sum, -0x1.fffffep127f, 0x1.fffffep127f);
}