//{"colid":1,"data":2,"result":4,"row_num":5,"rowptr":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_csr_sc_pm_u4_tx(global int* rowptr, global int* colid, global float* data, read_only image2d_t vec, global float* result, int row_num) {
  const sampler_t smp = 0 | 2 | 0x10;
  int row = get_global_id(0);

  {
    float sum = result[hook(4, row)];
    int start = rowptr[hook(0, row)];
    int end = rowptr[hook(0, row + 1)];
    int end4 = end - (end - start) % 4;
    int i = start;
    for (; i < end4;) {
      int col = colid[hook(1, i)];
      int2 coord;
      coord.x = col & 1023;
      coord.y = col >> 10;
      float4 ans = read_imagef(vec, smp, coord);
      sum = mad(data[hook(2, i)], ans.x, sum);
      i++;
      col = colid[hook(1, i)];
      coord.x = col & 1023;
      coord.y = col >> 10;
      ans = read_imagef(vec, smp, coord);
      sum = mad(data[hook(2, i)], ans.x, sum);
      i++;
      col = colid[hook(1, i)];
      coord.x = col & 1023;
      coord.y = col >> 10;
      ans = read_imagef(vec, smp, coord);
      sum = mad(data[hook(2, i)], ans.x, sum);
      i++;
      col = colid[hook(1, i)];
      coord.x = col & 1023;
      coord.y = col >> 10;
      ans = read_imagef(vec, smp, coord);
      sum = mad(data[hook(2, i)], ans.x, sum);
      i++;
    }
    for (; i < end; i++) {
      int col = colid[hook(1, i)];
      int2 coord;
      coord.x = col & 1023;
      coord.y = col >> 10;
      float4 ans = read_imagef(vec, smp, coord);
      sum = mad(data[hook(2, i)], ans.x, sum);
    }
    result[hook(4, row)] = sum;
  }
}