//{"alpha":4,"beta":5,"imgSize":2,"inputTempPtr":0,"localSize":3,"outputTempPtr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lrn_buffer(global float* inputTempPtr, global float* outputTempPtr, private const int4 imgSize, private const int localSize, private const float alpha, private const float beta) {
  int3 pos = (int3)(get_global_id(0), get_global_id(1), get_global_id(2));
  int3 imgInfo = imgSize.xyz;
  int hw = imgInfo.x * imgInfo.y;

  if (pos.x < imgInfo.x && pos.y < imgInfo.y) {
    float sum = 0.0f;
    int halfSize = localSize / 2;
    for (int c = pos.z - halfSize; c < pos.z + halfSize; c++) {
      if (c < 0 || c >= imgInfo.z)
        continue;
      int index = pos.x + pos.y * imgInfo.x + c * hw;
      sum += inputTempPtr[hook(0, index)] * inputTempPtr[hook(0, index)];
    }

    int dataIndex = pos.x + pos.y * imgInfo.x + pos.z * hw;
    outputTempPtr[hook(1, dataIndex)] = inputTempPtr[hook(0, dataIndex)] * pow(1.0f + alpha * sum, -beta);
  }
}