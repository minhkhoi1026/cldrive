//{"aligned_length":3,"band_num":4,"bandptr":0,"data":2,"l_bandptr":8,"l_offset":9,"offset":1,"result":6,"vec":5,"vecoffset":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_bdia_v4_nlvec(global int* bandptr, global int* offset, global float4* data, int aligned_length, int band_num, global float* vec, global float4* result, int vecoffset) {
  int row = get_global_id(0);
  local int l_bandptr[31 + 1];
  local int l_offset[31 + 1];
  int local_id = get_local_id(0);
  if (local_id < 31 + 1) {
    l_bandptr[hook(8, local_id)] = bandptr[hook(0, local_id)];
    l_offset[hook(9, local_id)] = offset[hook(1, local_id)];
  }
  barrier(0x01);

  float4 accumulant = result[hook(6, row)];
  for (int i = 0; i < band_num; i++) {
    int start = l_bandptr[hook(8, i)];
    int end = l_bandptr[hook(8, i + 1)];
    int diaoffset = l_offset[hook(9, i)];
    int matoffset = row + start * aligned_length;
    int bandwidth = end - start;
    int vecid = row * 4 + vecoffset + diaoffset;

    for (int j = 0; j < bandwidth; j++) {
      float4 matrixelem = data[hook(2, matoffset)];
      float4 vecelem = vload4(0, vec + vecid + j);
      accumulant = mad(matrixelem, vecelem, accumulant);
      matoffset += aligned_length;
    }
  }

  result[hook(6, row)] = accumulant;
}