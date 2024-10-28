//{"col_id":1,"data":2,"lslice_ptr":7,"lslice_ptr[warpid]":6,"result":4,"slice_num":5,"slice_ptr":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_sell_warp(global int* slice_ptr, global int* col_id, global float* data, global float* vec, global float* result, int slice_num) {
  int row = get_global_id(0);
  local int lslice_ptr[128 / 32][2];
  int sliceid = row / 32;
  if (sliceid >= slice_num)
    return;
  int localid = get_local_id(0);
  int warpid = localid / 32;
  int laneid = localid % 32;
  if (laneid < 2) {
    lslice_ptr[hook(7, warpid)][hook(6, laneid)] = slice_ptr[hook(0, sliceid + laneid)];
  }

  int start = lslice_ptr[hook(7, warpid)][hook(6, 0)] + laneid;
  int end = lslice_ptr[hook(7, warpid)][hook(6, 1)];
  float accumulant = result[hook(4, row)];

  for (int i = start; i < end; i += 32) {
    int vecid = col_id[hook(1, i)];
    float matrixelem = data[hook(2, i)];
    float vecelem = vec[hook(3, vecid)];
    accumulant = mad(matrixelem, vecelem, accumulant);
  }

  result[hook(4, row)] = accumulant;
}