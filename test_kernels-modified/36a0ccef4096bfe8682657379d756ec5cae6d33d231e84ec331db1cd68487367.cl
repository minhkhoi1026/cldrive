//{"colid":1,"data":2,"localrowptr":7,"localrowptr[warpid]":6,"result":4,"row_num":5,"rowptr":0,"s_ptr":8,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_csr_ve_slm_pm_fs_tx(global int* rowptr, global int* colid, global float* data, read_only image2d_t vec, global float* result, int row_num) {
  const sampler_t smp = 0 | 2 | 0x10;
  local float localsum[64 + 32 / 2];
  local int localrowptr[64 / 32][2];
  int row = get_global_id(0) / 32;
  int localid = get_local_id(0);
  int warpid = localid / 32;
  int laneid = localid % 32;

  int warpnum = get_global_size(0) / 32;

  for (; row < row_num; row += warpnum) {
    if (laneid < 2) {
      localrowptr[hook(7, warpid)][hook(6, laneid)] = rowptr[hook(0, row + laneid)];
    }

    int start = localrowptr[hook(7, warpid)][hook(6, 0)];
    int end = localrowptr[hook(7, warpid)][hook(6, 1)];
    float sum = 0.0f;
    for (int i = start + laneid; i < end; i += 32) {
      int col = colid[hook(1, i)];
      int2 coord;
      coord.x = col & 1023;
      coord.y = col >> 10;
      float4 ans = read_imagef(vec, smp, coord);
      sum = mad(data[hook(2, i)], ans.x, sum);
    }
    volatile local float* s_ptr = localsum;
    s_ptr[hook(8, localid)] = sum;
    s_ptr[hook(8, localid)] = sum = sum + s_ptr[hook(8, localid + 16)];
    s_ptr[hook(8, localid)] = sum = sum + s_ptr[hook(8, localid + 8)];
    s_ptr[hook(8, localid)] = sum = sum + s_ptr[hook(8, localid + 4)];
    s_ptr[hook(8, localid)] = sum = sum + s_ptr[hook(8, localid + 2)];
    sum = sum + s_ptr[hook(8, localid + 1)];

    if (laneid == 0)
      result[hook(4, row)] += sum;
  }
}