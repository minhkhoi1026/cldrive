//{"col_id":1,"data":2,"lslice_ptr":7,"lslice_ptr[warpid]":6,"result":4,"slice_num":5,"slice_ptr":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_sbell48(global int* slice_ptr, global int* col_id, global float4* data, global float4* vec, global float4* result, int slice_num) {
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

  int start = lslice_ptr[hook(7, warpid)][hook(6, 0)];
  int end = lslice_ptr[hook(7, warpid)][hook(6, 1)];
  float4 accumulant = result[hook(4, row)];
  int matoffset = start * 8 + laneid;
  for (int i = start + laneid; i < end; i += 32) {
    int vecid = col_id[hook(1, i)];
    float4 matrixelem = data[hook(2, matoffset)];
    float4 vecelem = vec[hook(3, vecid)];
    float4 tmp = matrixelem * vecelem;
    accumulant.x = accumulant.x + tmp.x + tmp.y + tmp.z + tmp.w;

    matoffset += 32;
    matrixelem = data[hook(2, matoffset)];
    tmp = matrixelem * vecelem;
    accumulant.y = accumulant.y + tmp.x + tmp.y + tmp.z + tmp.w;

    matoffset += 32;
    matrixelem = data[hook(2, matoffset)];
    tmp = matrixelem * vecelem;
    accumulant.z = accumulant.z + tmp.x + tmp.y + tmp.z + tmp.w;

    matoffset += 32;
    matrixelem = data[hook(2, matoffset)];
    tmp = matrixelem * vecelem;
    accumulant.w = accumulant.w + tmp.x + tmp.y + tmp.z + tmp.w;

    vecelem = vec[hook(3, vecid + 1)];
    matoffset += 32;
    matrixelem = data[hook(2, matoffset)];
    tmp = matrixelem * vecelem;
    accumulant.x = accumulant.x + tmp.x + tmp.y + tmp.z + tmp.w;

    matoffset += 32;
    matrixelem = data[hook(2, matoffset)];
    tmp = matrixelem * vecelem;
    accumulant.y = accumulant.y + tmp.x + tmp.y + tmp.z + tmp.w;

    matoffset += 32;
    matrixelem = data[hook(2, matoffset)];
    tmp = matrixelem * vecelem;
    accumulant.z = accumulant.z + tmp.x + tmp.y + tmp.z + tmp.w;

    matoffset += 32;
    matrixelem = data[hook(2, matoffset)];
    tmp = matrixelem * vecelem;
    accumulant.w = accumulant.w + tmp.x + tmp.y + tmp.z + tmp.w;

    matoffset += 32;
  }

  result[hook(4, row)] = accumulant;
}