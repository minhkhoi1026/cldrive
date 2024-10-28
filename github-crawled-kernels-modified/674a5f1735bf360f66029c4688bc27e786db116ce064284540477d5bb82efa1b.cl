//{"diff":0,"iout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sam_int = 2 | 0x10;
const sampler_t sam_norm = 1 | 2 | 0x20;
const sampler_t sam_linear = 2 | 0x20;
constant int size = 5;
kernel void harris(read_only image2d_t diff, global float* iout) {
  int2 cds = (int2)(get_global_id(0), get_global_id(1));
  float2 cdsf = convert_float2(cds);

  float xx = 0, yy = 0;

  for (float x = -size; x <= size; x += 1) {
    for (float y = -size; y <= size; y += 1) {
      float2 pt = cdsf + (float2)(x, y);
      float4 s0 = read_imagef(diff, sam_int, pt);
      xx += s0.x * s0.x;
      yy += s0.y * s0.y;
    }
  }
  float r = xx * yy - (xx + yy) * (xx + yy) * 0.05;
  if (r > 2) {
    iout[hook(1, cds.y * get_global_size(0) + cds.x)] = r;
  } else {
    iout[hook(1, cds.y * get_global_size(0) + cds.x)] = 0;
  }
}