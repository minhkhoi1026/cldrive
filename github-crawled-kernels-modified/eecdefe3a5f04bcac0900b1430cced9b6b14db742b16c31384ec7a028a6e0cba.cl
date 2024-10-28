//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rgbNorm(global float* in, global float* out) {
  unsigned int gX = get_global_id(0);

  float3 pixel = vload3(gX, in);
  float sum_ = dot(pixel, 1.f);
  float factor = select(native_recip(sum_), 0.f, isequal(sum_, 0.f));

  pixel *= factor;
  vstore3(pixel, gX, out);
}