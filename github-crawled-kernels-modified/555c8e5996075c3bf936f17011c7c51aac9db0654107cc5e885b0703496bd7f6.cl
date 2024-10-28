//{"bell_num":4,"col_align":3,"col_id":0,"data":1,"data_align":2,"result":6,"row_num":7,"vec":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_bell84_mad(global int* col_id, global float4* data, int data_align, int col_align, int bell_num, global float4* vec, global float* result, int row_num) {
  int row = get_global_id(0) * 8;
  float4 accumulant1 = {0.0f, 0.0f, 0.0f, 0.0f};
  accumulant1.x = result[hook(6, row)];
  float4 accumulant2 = {0.0f, 0.0f, 0.0f, 0.0f};
  accumulant2.x = result[hook(6, row + 1)];
  float4 accumulant3 = {0.0f, 0.0f, 0.0f, 0.0f};
  accumulant3.x = result[hook(6, row + 2)];
  float4 accumulant4 = {0.0f, 0.0f, 0.0f, 0.0f};
  accumulant4.x = result[hook(6, row + 3)];
  float4 accumulant5 = {0.0f, 0.0f, 0.0f, 0.0f};
  accumulant5.x = result[hook(6, row + 4)];
  float4 accumulant6 = {0.0f, 0.0f, 0.0f, 0.0f};
  accumulant6.x = result[hook(6, row + 5)];
  float4 accumulant7 = {0.0f, 0.0f, 0.0f, 0.0f};
  accumulant7.x = result[hook(6, row + 6)];
  float4 accumulant8 = {0.0f, 0.0f, 0.0f, 0.0f};
  accumulant8.x = result[hook(6, row + 7)];
  int vecoffset = get_global_id(0);
  int matoffset = get_global_id(0);
  for (int i = 0; i < bell_num; i++) {
    int vecid = col_id[hook(0, vecoffset)];
    float4 matrixelem = data[hook(1, matoffset)];
    float4 vecelem = vec[hook(5, vecid)];
    accumulant1 = mad(matrixelem, vecelem, accumulant1);
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    accumulant2 = mad(matrixelem, vecelem, accumulant2);
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    accumulant3 = mad(matrixelem, vecelem, accumulant3);
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    accumulant4 = mad(matrixelem, vecelem, accumulant4);
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    accumulant5 = mad(matrixelem, vecelem, accumulant5);
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    accumulant6 = mad(matrixelem, vecelem, accumulant6);
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    accumulant7 = mad(matrixelem, vecelem, accumulant7);
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    accumulant8 = mad(matrixelem, vecelem, accumulant8);
    matoffset += data_align;
    vecoffset += col_align;
  }

  result[hook(6, row)] = accumulant1.x + accumulant1.y + accumulant1.z + accumulant1.w;
  result[hook(6, row + 1)] = accumulant2.x + accumulant2.y + accumulant2.z + accumulant2.w;
  result[hook(6, row + 2)] = accumulant3.x + accumulant3.y + accumulant3.z + accumulant3.w;
  result[hook(6, row + 3)] = accumulant4.x + accumulant4.y + accumulant4.z + accumulant4.w;
  result[hook(6, row + 4)] = accumulant5.x + accumulant5.y + accumulant5.z + accumulant5.w;
  result[hook(6, row + 5)] = accumulant6.x + accumulant6.y + accumulant6.z + accumulant6.w;
  result[hook(6, row + 6)] = accumulant7.x + accumulant7.y + accumulant7.z + accumulant7.w;
  result[hook(6, row + 7)] = accumulant8.x + accumulant8.y + accumulant8.z + accumulant8.w;
}