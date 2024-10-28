//{"angles":4,"img":5,"numAngles":3,"phase":2,"pixels":0,"scale":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float wave(float, float, float, float);
float wrap(float);
kernel void quasiCrystal(int pixels, float scale, float phase, int numAngles, global float* angles, global uchar* img) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  float denom = (float)pixels - 1;
  float u = scale * ((2 * (float)x / denom) - 1);
  float v = scale * ((2 * (float)y / denom) - 1);
  float sum = 0.0f;
  for (int i = 0; i < numAngles; ++i) {
    sum += wave(phase, angles[hook(4, i)], u, v);
  }
  uchar r = (uchar)(255.0f * clamp(wrap(sum), 0.0f, 1.0f));
  vstore4((uchar4)(255, r, 128, r), y * pixels + x, img);
}