//{"colid":1,"data":2,"localrowptr":7,"localsum":6,"result":4,"row_num":5,"rowptr":0,"s_ptr":8,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_csr_ve_reduction_fs_tx(global int* rowptr, global int* colid, global float* data, read_only image2d_t vec, global float* result, int row_num) {
  const sampler_t smp = 0 | 2 | 0x10;
  local float localsum[64 + 64 / 2];
  local int localrowptr[2];
  int row = get_group_id(0);
  int localid = get_local_id(0);
  int groupsize = get_num_groups(0);

  localsum[hook(6, localid)] = 0.0f;

  for (; row < row_num; row += groupsize) {
    if (localid < 2) {
      localrowptr[hook(7, localid)] = rowptr[hook(0, row + localid)];
    }
    barrier(0x01);

    int start = localrowptr[hook(7, 0)];
    int end = localrowptr[hook(7, 1)];
    float sum = 0.0f;
    for (int i = start + localid; i < end; i += 64) {
      int col = colid[hook(1, i)];
      int2 coord;
      coord.x = col & 1023;
      coord.y = col >> 10;
      float4 ans = read_imagef(vec, smp, coord);
      sum = mad(data[hook(2, i)], ans.x, sum);
    }
    volatile local float* s_ptr = localsum;
    s_ptr[hook(8, localid)] = sum;
    s_ptr[hook(8, localid)] = sum = sum + s_ptr[hook(8, localid + 32)];
    s_ptr[hook(8, localid)] = sum = sum + s_ptr[hook(8, localid + 16)];
    s_ptr[hook(8, localid)] = sum = sum + s_ptr[hook(8, localid + 8)];
    s_ptr[hook(8, localid)] = sum = sum + s_ptr[hook(8, localid + 4)];
    s_ptr[hook(8, localid)] = sum = sum + s_ptr[hook(8, localid + 2)];
    sum = sum + s_ptr[hook(8, localid + 1)];

    if (localid == 0)
      result[hook(4, row)] += sum;
  }
}