//{"col_id":1,"data":2,"lslice_ptr":6,"result":4,"slice_num":5,"slice_ptr":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_sell_group_tx(global int* slice_ptr, global int* col_id, global float* data, read_only image2d_t vec, global float* result, int slice_num) {
  local int lslice_ptr[2];
  int row = get_global_id(0);
  int size = get_local_size(0);
  int sliceid = row / size;
  const sampler_t smp = 0 | 2 | 0x10;
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
    int2 coord;
    coord.x = vecid & 1023;
    coord.y = vecid >> 10;
    float matrixelem = data[hook(2, i)];
    float4 vecelem = read_imagef(vec, smp, coord);
    accumulant = mad(matrixelem, vecelem.x, accumulant);
  }

  result[hook(4, row)] = accumulant;
}