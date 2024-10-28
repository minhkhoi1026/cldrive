//{"col_id":1,"data":2,"lslice_ptr":7,"lslice_ptr[warpid]":6,"result":4,"slice_num":5,"slice_ptr":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_sbell18_tx(global int* slice_ptr, global int* col_id, global float4* data, read_only image2d_t vec, global float* result, int slice_num) {
  int row = get_global_id(0);
  local int lslice_ptr[128 / 32][2];
  int sliceid = row / 32;
  if (sliceid >= slice_num)
    return;
  const sampler_t smp = 0 | 2 | 0x10;
  int localid = get_local_id(0);
  int warpid = localid / 32;
  int laneid = localid % 32;
  if (laneid < 2) {
    lslice_ptr[hook(7, warpid)][hook(6, laneid)] = slice_ptr[hook(0, sliceid + laneid)];
  }

  int start = lslice_ptr[hook(7, warpid)][hook(6, 0)];
  int end = lslice_ptr[hook(7, warpid)][hook(6, 1)];
  float4 accumulant = {0.0f, 0.0f, 0.0f, 0.0f};
  accumulant.x = result[hook(4, row)];
  int matoffset = start * 2 + laneid;
  for (int i = start + laneid; i < end; i += 32) {
    int vecid = col_id[hook(1, i)];
    int2 coord;
    coord.x = vecid & 1023;
    coord.y = vecid >> 10;
    float4 matrixelem = data[hook(2, matoffset)];
    float4 vecelem = read_imagef(vec, smp, coord);
    accumulant = mad(matrixelem, vecelem, accumulant);

    vecid++;
    coord.x = vecid & 1023;
    coord.y = vecid >> 10;
    vecelem = read_imagef(vec, smp, coord);
    matoffset += 32;
    matrixelem = data[hook(2, matoffset)];
    accumulant = mad(matrixelem, vecelem, accumulant);

    matoffset += 32;
  }
  result[hook(4, row)] = accumulant.x + accumulant.y + accumulant.z + accumulant.w;
}