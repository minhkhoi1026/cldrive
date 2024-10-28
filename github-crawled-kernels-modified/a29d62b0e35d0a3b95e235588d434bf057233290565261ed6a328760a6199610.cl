//{"col_id":1,"data":2,"lslice_ptr":6,"result":4,"slice_num":5,"slice_ptr":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_sell_group(global int* slice_ptr, global int* col_id, global float* data, global float* vec, global float* result, int slice_num) {
  local int lslice_ptr[2];
  int row = get_global_id(0);
  int size = get_local_size(0);
  int sliceid = row / size;
  int localid = get_local_id(0);
  if (localid < 2) {
    lslice_ptr[hook(6, localid)] = slice_ptr[hook(0, sliceid + localid)];
  }
  barrier(0x01);

  int start = lslice_ptr[hook(6, 0)] + localid;
  int end = lslice_ptr[hook(6, 1)];
  float accumulant = result[hook(4, row)];
  for (int i = start; i < end; i += size) {
    int vecid = col_id[hook(1, i)];
    float matrixelem = data[hook(2, i)];
    float vecelem = vec[hook(3, vecid)];
    accumulant = mad(matrixelem, vecelem, accumulant);
  }

  result[hook(4, row)] = accumulant;
}