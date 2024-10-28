//{"aligned_length":2,"data":1,"dia_num":3,"l_offset":7,"offset":0,"result":5,"vec":4,"vecoffset":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_dia_v4(global int* offset, global float4* data, int aligned_length, int dia_num, global float* vec, global float4* result, int vecoffset) {
  int row = get_global_id(0);
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
    int vecid = row * 4 + vecoffset + diaoffset;
    float4 matrixelem = data[hook(1, matoffset)];
    float4 vecelem = vload4(0, vec + vecid);
    accumulant = mad(matrixelem, vecelem, accumulant);
    matoffset += aligned_length;
  }
  result[hook(5, row)] = accumulant;
}