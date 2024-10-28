//{"cmatrix":3,"dst_buf":2,"matrix_length":4,"src_buf":0,"src_width":1,"xoff":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fir_hor_blur(const global float4* src_buf, const int src_width, global float4* dst_buf, constant float* cmatrix, const int matrix_length, const int xoff) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int gid = gidx + gidy * get_global_size(0);

  int radius = matrix_length / 2;
  int src_offset = gidy * src_width + (gidx + xoff);

  float4 v = 0.0f;

  for (int i = -radius; i <= radius; i++) {
    v += src_buf[hook(0, src_offset + i)] * cmatrix[hook(3, i + radius)];
  }

  dst_buf[hook(2, gid)] = v;
}