//{"colid":1,"data":2,"data_align":5,"localrowptr":7,"localsum":6,"result":4,"rowptr":0,"s_ptr":8,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_bcsr_red_14_tx(global int* rowptr, global int* colid, global float4* data, read_only image2d_t vec, global float* result, int data_align) {
  const sampler_t smp = 0 | 2 | 0x10;
  local int localrowptr[2];
  local float localsum[128 + 64 / 2];
  int row = get_group_id(0);
  int localid = get_local_id(0);

  localsum[hook(6, localid)] = 0.0f;
  if (localid < 2) {
    localrowptr[hook(7, localid)] = rowptr[hook(0, row + localid)];
  }
  barrier(0x01);

  {
    int start = localrowptr[hook(7, 0)];
    int end = localrowptr[hook(7, 1)];
    float4 sum = {0.0f, 0.0f, 0.0f, 0.0f};
    for (int i = start + localid; i < end; i += 128) {
      int col = colid[hook(1, i)];
      int2 coord;
      coord.x = col & 1023;
      coord.y = col >> 10;
      float4 matelem = data[hook(2, i)];
      float4 vecelem = read_imagef(vec, smp, coord);
      sum = mad(matelem, vecelem, sum);
    }
    volatile local float* s_ptr = localsum;
    s_ptr[hook(8, localid)] = sum.x = sum.x + sum.y + sum.z + sum.w;
    barrier(0x01);
    if (localid < 64)
      s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 64)];
    barrier(0x01);
    s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 32)];
    s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 16)];
    s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 8)];
    s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 4)];
    s_ptr[hook(8, localid)] = sum.x = sum.x + s_ptr[hook(8, localid + 2)];
    sum.x = sum.x + s_ptr[hook(8, localid + 1)];

    if (localid == 0)
      result[hook(4, row)] += sum.x;
  }
}