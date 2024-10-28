//{"QUANT_BIT":9,"QUANT_BIT2_f32":11,"QUANT_BIT_f32":10,"_dst_offset":2,"dst":0,"dst_step":1,"sclx":7,"scly":8,"src":3,"src_cols":4,"src_rows":5,"src_step":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BilinearInterpolation_cl(global float* dst, int dst_step, int _dst_offset, global float* src, int src_cols, int src_rows, int src_step, unsigned int sclx, unsigned int scly, unsigned int QUANT_BIT, float QUANT_BIT_f32, float QUANT_BIT2_f32) {
  const unsigned int ix = get_global_id(0);
  const unsigned int iy = get_global_id(1);

  const unsigned int x = ix * sclx;
  unsigned int px = (x >> QUANT_BIT);
  if (px + 1 >= src_cols)
    px--;

  const unsigned int y = iy * scly;
  unsigned int py = (y >> QUANT_BIT);
  if (py + 1 >= src_rows)
    py--;

  if (px + 1 >= src_cols || py + 1 >= src_rows)
    return;

  const unsigned int src_offset = py * src_step + px;
  const unsigned int dst_offset = _dst_offset + iy * dst_step + ix;

  const float fx = (float)(x - (px << QUANT_BIT));
  const float cx = QUANT_BIT_f32 - fx;

  const float fy = (float)(y - (py << QUANT_BIT));
  const float cy = QUANT_BIT_f32 - fy;

  src += src_offset;
  const float p0 = *(src + 0);
  const float p1 = *(src + 1);

  src += src_step;
  const float p2 = *(src + 0);
  const float p3 = *(src + 1);

  const float outv = (p0 * cx + p1 * fx) * cy + (p2 * cx + p3 * fx) * fy;
  *(dst + dst_offset) = outv * QUANT_BIT2_f32;
}