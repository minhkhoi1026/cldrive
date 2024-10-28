//{"aligned_length":2,"col_id":0,"data":1,"ell_num":3,"result":5,"row_num":6,"vec":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_ell_v4(global int4* col_id, global float4* data, int aligned_length, int ell_num, global float* vec, global float4* result, int row_num) {
  int row = get_global_id(0);
  float4 accumulant = result[hook(5, row)];
  int matoffset = row;
  for (int i = 0; i < ell_num; i++) {
    int4 vecid = col_id[hook(0, matoffset)];
    float4 matrixelem = data[hook(1, matoffset)];
    float4 vecelem;
    vecelem.x = vec[hook(4, vecid.x)];
    vecelem.y = vec[hook(4, vecid.y)];
    vecelem.z = vec[hook(4, vecid.z)];
    vecelem.w = vec[hook(4, vecid.w)];
    accumulant = mad(matrixelem, vecelem, accumulant);
    matoffset += aligned_length;
  }

  result[hook(5, row)] = accumulant;
}