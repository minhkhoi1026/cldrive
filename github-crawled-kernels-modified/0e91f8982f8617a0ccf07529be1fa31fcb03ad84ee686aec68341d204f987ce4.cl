//{"size":1,"time":2,"vertex":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sineWave(global float4* vertex, int size, float time) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);

  float u = x / (float)size;
  float v = y / (float)size;

  u = u * 2.0f - 1.0f;
  v = v * 2.0f - 1.0f;

  float freq = 4.0f;
  float w = sin(u * freq + time) * cos(v * freq + time) * 0.5f;

  vertex[hook(0, y * size + x)] = (float4)(u * 10.0f, w * 10.0f, v * 10.0f, 1.0f);
}