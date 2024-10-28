//{"field":0,"fieldLength":3,"filter":1,"filterLength":4,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv3d(global double* field, global double* filter, global double* result, const int fieldLength, const int filterLength) {
  int gid = get_global_id(0);
  int base = -fieldLength * fieldLength - fieldLength - 1;
  int fieldIndex = 0;
  double answer = 0.0;
  for (int i = 0; i < filterLength; ++i) {
    for (int j = 0; j < filterLength; ++j) {
      int boundary = (gid + base + 1) / fieldLength;
      for (int k = 0; k < filterLength; ++k) {
        fieldIndex = gid + base + k;
        if (fieldIndex / fieldLength != boundary)
          continue;
        if (fieldIndex < 0 || fieldIndex >= fieldLength * fieldLength * fieldLength)
          continue;
        double fieldValue = field[hook(0, fieldIndex)];
        answer += filter[hook(1, filterLength * filterLength * i + filterLength * j + k)] * fieldValue;
      }
      base += fieldLength;
    }
    base -= filterLength * fieldLength;
    base += fieldLength * fieldLength;
  }
  result[hook(2, gid)] = answer;
}