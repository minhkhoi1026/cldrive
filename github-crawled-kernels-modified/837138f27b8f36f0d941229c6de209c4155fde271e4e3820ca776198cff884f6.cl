//{"bell_num":4,"col_align":3,"col_id":0,"data":1,"data_align":2,"result":6,"row_num":7,"vec":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_bell48_tx(global int* col_id, global float4* data, int data_align, int col_align, int bell_num, read_only image2d_t vec, global float4* result, int row_num) {
  int row = get_global_id(0);
  const sampler_t smp = 0 | 2 | 0x10;
  float4 accumulants = result[hook(6, row)];
  int vecoffset = row;
  int matoffset = row;
  for (int i = 0; i < bell_num; i++) {
    int vecid = col_id[hook(0, vecoffset)];
    int2 coord;
    coord.x = vecid & 1023;
    coord.y = vecid >> 10;
    float4 matrixelem = data[hook(1, matoffset)];
    float4 vecelem = read_imagef(vec, smp, coord);
    float4 tmp = matrixelem * vecelem;
    accumulants.x = accumulants.x + tmp.x + tmp.y + tmp.z + tmp.w;
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    tmp = matrixelem * vecelem;
    accumulants.y = accumulants.y + tmp.x + tmp.y + tmp.z + tmp.w;
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    tmp = matrixelem * vecelem;
    accumulants.z = accumulants.z + tmp.x + tmp.y + tmp.z + tmp.w;
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    tmp = matrixelem * vecelem;
    accumulants.w = accumulants.w + tmp.x + tmp.y + tmp.z + tmp.w;

    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    vecid++;
    coord.x = vecid & 1023;
    coord.y = vecid >> 10;
    vecelem = read_imagef(vec, smp, coord);
    tmp = matrixelem * vecelem;
    accumulants.x = accumulants.x + tmp.x + tmp.y + tmp.z + tmp.w;
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    tmp = matrixelem * vecelem;
    accumulants.y = accumulants.y + tmp.x + tmp.y + tmp.z + tmp.w;
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    tmp = matrixelem * vecelem;
    accumulants.z = accumulants.z + tmp.x + tmp.y + tmp.z + tmp.w;
    matoffset += data_align;
    matrixelem = data[hook(1, matoffset)];
    tmp = matrixelem * vecelem;
    accumulants.w = accumulants.w + tmp.x + tmp.y + tmp.z + tmp.w;
    matoffset += data_align;
    vecoffset += col_align;
  }
  result[hook(6, row)] = accumulants;
}