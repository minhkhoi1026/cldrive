//{"cosAngles":3,"img":5,"phase":2,"pixels":0,"scale":1,"sinAngles":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float wrap(float);
kernel void quasiCrystal(int pixels, float scale, float phase, global float* cosAngles, global float* sinAngles, global uchar* img) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  float denom = (float)pixels - 1;
  float u = scale * ((2 * (float)x / denom) - 1);
  float v = scale * ((2 * (float)y / denom) - 1);

  float8 cosines = vload8(0, cosAngles);
  float8 sines = vload8(0, sinAngles);

  float8 waves = (cos(cosines * u + sines * v + phase) + 1.0f) / 2.0f;
  float sum = waves.s0 + waves.s1 + waves.s2 + waves.s3 + waves.s4 + waves.s5 + waves.s6;
  uchar r = (uchar)(255.0f * clamp(wrap(sum), 0.0f, 1.0f));
  vstore4((uchar4)(255, r, 128, r), y * pixels + x, img);
}