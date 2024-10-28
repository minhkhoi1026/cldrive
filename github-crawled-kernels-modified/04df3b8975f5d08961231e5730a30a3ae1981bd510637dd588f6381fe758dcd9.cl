//{"cols":2,"nVals":0,"res":5,"rows":1,"vals":3,"vec":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sparseMatVec(int nVals, global int* rows, global int* cols, global float* vals, global float* vec, global float* res) {
  int id = get_global_id(0);

  int startIdx = -1;
  int endIdx = -1;

  for (int i = id; i < nVals; ++i) {
    if (rows[hook(1, i)] == id && startIdx == -1)
      startIdx = i;
    if (rows[hook(1, i)] == id + 1 && startIdx != -1 && endIdx == -1) {
      endIdx = i - 1;
      break;
    }
    if (i == nVals - 1 && startIdx != -1 && endIdx == -1)
      endIdx = i;
  }
  float sum = 0.0f;
  for (int i = startIdx; i <= endIdx; ++i)
    sum += vals[hook(3, i)] * vec[hook(4, cols[ihook(2, i))];

  res[hook(5, id)] = sum;
}