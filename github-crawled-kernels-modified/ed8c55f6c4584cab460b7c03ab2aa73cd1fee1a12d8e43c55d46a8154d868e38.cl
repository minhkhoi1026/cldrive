//{"QUANT_BIT":9,"_dst_offset":2,"dst":0,"dst_step":1,"sclx":7,"scly":8,"src":3,"src_cols":4,"src_rows":5,"src_step":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void NearestNeighborInterpolation_cl(global float* dst, int dst_step, int _dst_offset, global float* src, int src_cols, int src_rows, int src_step, unsigned int sclx, unsigned int scly, unsigned int QUANT_BIT) {
  const unsigned int ix = get_global_id(0);
  const unsigned int iy = get_global_id(1);

  const unsigned int x = ix * sclx;
  const unsigned int px = (x >> QUANT_BIT);

  const unsigned int y = iy * scly;
  const unsigned int py = (y >> QUANT_BIT);

  if (px >= src_cols || py >= src_rows)
    return;

  const unsigned int src_offset = py * src_step + px;
  const unsigned int dst_offset = _dst_offset + iy * dst_step + ix;

  *(dst + dst_offset) = *(src + src_offset);
}