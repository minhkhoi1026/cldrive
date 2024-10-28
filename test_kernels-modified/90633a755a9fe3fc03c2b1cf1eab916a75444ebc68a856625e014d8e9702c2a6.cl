//{"colid":1,"data":2,"result":4,"row_num":5,"rowptr":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_csr_sc_pm_float4_noif_tx(global int* rowptr, global int* colid, global float* data, read_only image2d_t vec, global float* result, int row_num) {
  const sampler_t smp = 0 | 2 | 0x10;
  int row = get_global_id(0);

  {
    float sum = result[hook(4, row)];
    int start = rowptr[hook(0, row)];
    int end = rowptr[hook(0, row + 1)];
    for (int i = start; i < end; i += 4) {
      float4 data4 = vload4(0, data + i);
      int4 col4 = vload4(0, colid + i);
      int2 coord;
      coord.x = col4.x & 1023;
      coord.y = col4.x >> 10;
      float4 ans = read_imagef(vec, smp, coord);
      sum = mad(data4.x, ans.x, sum);
      coord.x = col4.y & 1023;
      coord.y = col4.y >> 10;
      ans = read_imagef(vec, smp, coord);
      sum = mad(data4.y, ans.x, sum);
      coord.x = col4.z & 1023;
      coord.y = col4.z >> 10;
      ans = read_imagef(vec, smp, coord);
      sum = mad(data4.z, ans.x, sum);
      coord.x = col4.w & 1023;
      coord.y = col4.w >> 10;
      ans = read_imagef(vec, smp, coord);
      sum = mad(data4.w, ans.x, sum);
    }
    result[hook(4, row)] = sum;
  }
}