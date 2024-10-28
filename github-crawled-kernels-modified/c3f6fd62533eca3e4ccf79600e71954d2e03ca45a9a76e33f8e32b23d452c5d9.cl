//{"block_sz":4,"fir":1,"fir_chnl_stride":7,"fir_sz":3,"in":0,"in_chnl_stride":6,"in_index":5,"out":2,"out_chnl_stride":9,"out_index":8,"stage":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void amdFIR(global const float* in, global const float* fir, global float* out, int fir_sz, int block_sz, int in_index, int in_chnl_stride, int fir_chnl_stride, int out_index, int out_chnl_stride) {
  int lcl_id = get_local_id(0);
  int grp_id = get_group_id(0);
  int chnl = get_group_id(1);
  local float stage[64 + 32];
  stage[hook(10, lcl_id)] = 0;
  stage[hook(10, 64 + lcl_id / 2)] = 0;
  barrier(0x01);
  int data_chnl_off = mul24(in_chnl_stride, chnl);
  int fir_chnl_off = mul24(fir_chnl_stride, chnl);
  int fir_index, data_index;
  int fir_off, data_off;

  float sum = 0;
  for (fir_index = lcl_id, data_index = grp_id - lcl_id + mul24(in_index, block_sz); fir_index < fir_sz; fir_index += 64, data_index -= 64) {
    data_index = (data_index < 0) ? in_chnl_stride + data_index : data_index;
    fir_off = fir_chnl_off + fir_index;
    data_off = data_chnl_off + data_index;
    sum += fir[hook(1, fir_off)] * in[hook(0, data_off)];
  }

  stage[hook(10, lcl_id)] = sum;
  barrier(0x01);
  for (int i = 32; i > 0; i >>= 1) {
    sum += stage[hook(10, lcl_id + i)];
    stage[hook(10, lcl_id)] = sum;
    barrier(0x01);
  }

  int out_off = mad24(out_chnl_stride, chnl, out_index);
  if (lcl_id == 0) {
    out[hook(2, out_off + grp_id)] = sum;
  }
}