//{"aligned_length":2,"col_id":0,"data":1,"ell_num":3,"result":5,"row_num":6,"vec":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_ell_tx(global int* col_id, global float* data, int aligned_length, int ell_num, read_only image2d_t vec, global float* result, int row_num) {
  int row = get_global_id(0);
  const sampler_t smp = 0 | 2 | 0x10;
  float accumulant = result[hook(5, row)];
  int matoffset = row;
  for (int i = 0; i < ell_num; i++) {
    int vecid = col_id[hook(0, matoffset)];
    int2 coord;
    coord.x = vecid & 1023;
    coord.y = vecid >> 10;
    float matrixelem = data[hook(1, matoffset)];
    float4 vecelem = read_imagef(vec, smp, coord);
    accumulant = mad(matrixelem, vecelem.x, accumulant);
    matoffset += aligned_length;
  }
  result[hook(5, row)] = accumulant;
}