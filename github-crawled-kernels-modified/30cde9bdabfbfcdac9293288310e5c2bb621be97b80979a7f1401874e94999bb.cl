//{"aligned_length":2,"data":1,"dia_num":3,"l_offset":7,"offset":0,"result":5,"vec":4,"vecoffset":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_dia_v4_tx(global int* offset, global float4* data, int aligned_length, int dia_num, read_only image2d_t vec, global float4* result, int vecoffset) {
  int row = get_global_id(0);
  const sampler_t smp = 0 | 2 | 0x10;
  local int l_offset[128];
  int local_id = get_local_id(0);
  if (local_id < dia_num) {
    l_offset[hook(7, local_id)] = offset[hook(0, local_id)];
  }
  barrier(0x01);

  float4 accumulant = result[hook(5, row)];
  int matoffset = row;
  for (int i = 0; i < dia_num; i++) {
    int diaoffset = l_offset[hook(7, i)];
    int vecid = row * 4 + diaoffset;
    float4 matrixelem = data[hook(1, matoffset)];
    int alignment = vecid % 4;
    if (alignment < 0)
      alignment += 4;
    vecid = vecid >> 2;
    float4 vecelem;
    if (alignment == 0) {
      int2 coord;
      coord.x = vecid & 1023;
      coord.y = vecid >> 10;
      vecelem = read_imagef(vec, smp, coord);
    } else if (alignment == 1) {
      int2 coord;
      coord.x = vecid & 1023;
      coord.y = vecid >> 10;
      vecid++;
      int2 coord1;
      coord1.x = vecid & 1023;
      coord1.y = vecid >> 10;
      float4 tmp1 = read_imagef(vec, smp, coord);
      float4 tmp2 = read_imagef(vec, smp, coord1);
      vecelem.xyz = tmp1.yzw;
      vecelem.w = tmp2.x;
    } else if (alignment == 2) {
      int2 coord;
      coord.x = vecid & 1023;
      coord.y = vecid >> 10;
      vecid++;
      int2 coord1;
      coord1.x = vecid & 1023;
      coord1.y = vecid >> 10;
      float4 tmp1 = read_imagef(vec, smp, coord);
      float4 tmp2 = read_imagef(vec, smp, coord1);
      vecelem.xy = tmp1.zw;
      vecelem.zw = tmp2.xy;
    } else if (alignment == 3) {
      int2 coord;
      coord.x = vecid & 1023;
      coord.y = vecid >> 10;
      vecid++;
      int2 coord1;
      coord1.x = vecid & 1023;
      coord1.y = vecid >> 10;
      float4 tmp1 = read_imagef(vec, smp, coord);
      float4 tmp2 = read_imagef(vec, smp, coord1);
      vecelem.x = tmp1.w;
      vecelem.yzw = tmp2.xyz;
    }
    accumulant = mad(matrixelem, vecelem, accumulant);
    matoffset += aligned_length;
  }
  result[hook(5, row)] = accumulant;
}