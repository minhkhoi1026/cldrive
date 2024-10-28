//{"bell_num":4,"col_align":3,"col_id":0,"data":1,"data_align":2,"result":6,"row_num":7,"vec":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_bell28_mad_tx(global int* col_id, global float4* data, int data_align, int col_align, int bell_num, read_only image2d_t vec, global float* result, int row_num) {
  int row = get_global_id(0) * 2;
  const sampler_t smp = 0 | 2 | 0x10;
  float4 accumulant1 = {0.0f, 0.0f, 0.0f, 0.0f};
  accumulant1.x = result[hook(6, row)];
  float4 accumulant2 = {0.0f, 0.0f, 0.0f, 0.0f};
  accumulant2.x = result[hook(6, row + 1)];
  int vecoffset = get_global_id(0);
  int matoffset = get_global_id(0);
  for (int i = 0; i < bell_num; i++) {
    int vecid = col_id[hook(0, vecoffset)];
    int2 coord;
    coord.x = vecid & 1023;
    coord.y = vecid >> 10;
    float4 matrixelem = data[hook(1, matoffset)];
    float4 vecelem = read_imagef(vec, smp, coord);
    accumulant1 = mad(matrixelem, vecelem, accumulant1);
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    accumulant2 = mad(matrixelem, vecelem, accumulant2);

    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    vecid++;
    coord.x = vecid & 1023;
    coord.y = vecid >> 10;
    vecelem = read_imagef(vec, smp, coord);
    accumulant1 = mad(matrixelem, vecelem, accumulant1);
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    accumulant2 = mad(matrixelem, vecelem, accumulant2);
    matoffset += data_align;
    vecoffset += col_align;
  }
  result[hook(6, row)] = accumulant1.x + accumulant1.y + accumulant1.z + accumulant1.w;
  result[hook(6, row + 1)] = accumulant2.x + accumulant2.y + accumulant2.z + accumulant2.w;
}