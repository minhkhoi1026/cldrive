//{"height":2,"pos":0,"time":3,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sine_wave(global float4* pos, unsigned int width, unsigned int height, float time) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);

  float u = x / (float)width;
  float v = y / (float)height;
  u = u * 2.0f - 1.0f;
  v = v * 2.0f - 1.0f;

  float freq = 4.0f;
  float w = sin(u * freq + time) * cos(v * freq + time) * 0.5f;

  pos[hook(0, y * width + x)] = (float4)(u, w, v, 1.0f);
}