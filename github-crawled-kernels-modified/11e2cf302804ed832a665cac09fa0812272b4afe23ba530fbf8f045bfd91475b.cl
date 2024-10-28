//{"coeff":9,"cols":6,"elements_per_row":8,"opl_off":1,"opl_on":0,"out_off":5,"out_on":4,"prev_in_off":3,"prev_in_on":2,"rows":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void amacrineCellsComputing(global const float* opl_on, global const float* opl_off, global float* prev_in_on, global float* prev_in_off, global float* out_on, global float* out_off, const int cols, const int rows, const int elements_per_row, const float coeff) {
  int gidx = get_global_id(0) * 4, gidy = get_global_id(1);
  if (gidx >= cols || gidy >= rows) {
    return;
  }

  int offset = mad24(gidy, elements_per_row, gidx);
  opl_on += offset;
  opl_off += offset;
  prev_in_on += offset;
  prev_in_off += offset;
  out_on += offset;
  out_off += offset;

  float4 val_opl_on = vload4(0, opl_on);
  float4 val_opl_off = vload4(0, opl_off);

  float4 magnoXonPixelResult = coeff * (vload4(0, out_on) + val_opl_on - vload4(0, prev_in_on));
  vstore4(fmax(magnoXonPixelResult, 0.f), 0, out_on);
  float4 magnoXoffPixelResult = coeff * (vload4(0, out_off) + val_opl_off - vload4(0, prev_in_off));
  vstore4(fmax(magnoXoffPixelResult, 0.f), 0, out_off);

  vstore4(val_opl_on, 0, prev_in_on);
  vstore4(val_opl_off, 0, prev_in_off);
}