//{"aligned_length":2,"col_id":0,"data":1,"ell_num":3,"result":5,"row_num":6,"vec":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_ell_v4_tx(global int4* col_id, global float4* data, int aligned_length, int ell_num, read_only image2d_t vec, global float4* result, int row_num) {
  int row = get_global_id(0);
  const sampler_t smp = 0 | 2 | 0x10;
  float4 accumulant = result[hook(5, row)];
  int matoffset = row;
  for (int i = 0; i < ell_num; i++) {
    float4 matrixelem = data[hook(1, matoffset)];
    int4 vecid = col_id[hook(0, matoffset)];
    int2 coord;
    coord.x = vecid.x & 1023;
    coord.y = vecid.x >> 10;
    float4 tmp = read_imagef(vec, smp, coord);
    int2 coord1;
    coord1.x = vecid.y & 1023;
    coord1.y = vecid.y >> 10;
    float4 tmp1 = read_imagef(vec, smp, coord1);
    int2 coord2;
    coord2.x = vecid.z & 1023;
    coord2.y = vecid.z >> 10;
    float4 tmp2 = read_imagef(vec, smp, coord2);
    int2 coord3;
    coord3.x = vecid.w & 1023;
    coord3.y = vecid.w >> 10;
    float4 tmp3 = read_imagef(vec, smp, coord3);
    float4 vecelem;
    vecelem.x = tmp.x;
    vecelem.y = tmp1.x;
    vecelem.z = tmp2.x;
    vecelem.w = tmp3.x;
    accumulant = mad(matrixelem, vecelem, accumulant);
    matoffset += aligned_length;
  }
  result[hook(5, row)] = accumulant;
}