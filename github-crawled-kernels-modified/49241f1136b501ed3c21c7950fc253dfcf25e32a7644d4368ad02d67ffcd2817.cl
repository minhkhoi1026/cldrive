//{"colid":1,"data":2,"result":4,"row_num":5,"rowptr":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_csr_sc_pm_float4_noif(global int* rowptr, global int* colid, global float* data, global float* vec, global float* result, int row_num) {
  int row = get_global_id(0);

  {
    float sum = result[hook(4, row)];
    int start = rowptr[hook(0, row)];
    int end = rowptr[hook(0, row + 1)];
    for (int i = start; i < end; i += 4) {
      float4 data4 = vload4(0, data + i);
      int4 col4 = vload4(0, colid + i);
      sum = mad(data4.x, vec[hook(3, col4.x)], sum);
      sum = mad(data4.y, vec[hook(3, col4.y)], sum);
      sum = mad(data4.z, vec[hook(3, col4.z)], sum);
      sum = mad(data4.w, vec[hook(3, col4.w)], sum);
    }
    result[hook(4, row)] = sum;
  }
}