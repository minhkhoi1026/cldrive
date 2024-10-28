//{"clen":3,"cmatrix":2,"dst_buf":1,"src_buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fir_hor_blur(const global float4* src_buf, global float4* dst_buf, const global float* cmatrix, const int clen) {
  const int gidx = get_global_id(0);
  const int gidy = get_global_id(1);
  const int src_rowstride = get_global_size(0) + clen - 1;
  const int dst_rowstride = get_global_size(0);

  const int half_clen = clen / 2;

  const int src_offset = gidx + gidy * src_rowstride + half_clen;
  const int dst_offset = gidx + gidy * dst_rowstride;

  const int src_start_ind = src_offset - half_clen;

  float4 v = 0.0f;

  for (int i = 0; i < clen; i++) {
    v += src_buf[hook(0, src_start_ind + i)] * cmatrix[hook(2, i)];
  }

  dst_buf[hook(1, dst_offset)] = v;
}