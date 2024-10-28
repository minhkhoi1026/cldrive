//{"dataEndListArg":0,"dataSize":3,"dataTurnoverListArg":1,"parameterCellSize":6,"parameterListArgs":5,"resultCellSize":8,"resultListArgs":7,"samplingSize":4,"successListArg":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float calculation(global float* dataEndListArg, global float* dataTurnoverListArg, global float* successListArg, int dataSize, int samplingSize, global float* parameterListArgs, int parameterCellSize, global float* resultListArgs, int resultCellSize, int i, int x) {
  float result = 0;

  for (int j = samplingSize - 1; j >= 0; j--) {
    result += parameterListArgs[hook(5, parameterCellSize * x + 32)] * (parameterListArgs[hook(5, parameterCellSize * x)] * dataEndListArg[hook(0, i - j)] + parameterListArgs[hook(5, parameterCellSize * x + 1)] * dataTurnoverListArg[hook(1, i - j)] + parameterListArgs[hook(5, parameterCellSize * x + 2)]);
  }
  return result;
}

kernel void test(global float* dataEndListArg, global float* dataTurnoverListArg, global float* successListArg, int dataSize, int samplingSize, global float* parameterListArgs, int parameterCellSize, global float* resultListArgs, int resultCellSize) {
  int x = get_global_id(0);
  float success = 0.0f;
  float successCount = 0.0f;

  for (int i = samplingSize - 1; i < dataSize - samplingSize; i++) {
    float result = calculation(dataEndListArg, dataTurnoverListArg, successListArg, dataSize, samplingSize, parameterListArgs, parameterCellSize, resultListArgs, resultCellSize, i, x);
    if (result > 1) {
      success += 1;
      if (successListArg[hook(2, i)] > 1) {
        successCount += 1;
      }
    }
  }
  resultListArgs[hook(7, x * resultCellSize)] = success;
  resultListArgs[hook(7, x * resultCellSize + 1)] = successCount;
}