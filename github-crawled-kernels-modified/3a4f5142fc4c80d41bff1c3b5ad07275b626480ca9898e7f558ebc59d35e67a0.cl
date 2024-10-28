//{"h":2,"seq":3,"vbo":0,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_vbo_kernel(global float4* vbo, int w, int h, int seq) {
  int gid = get_global_id(0);
  float4 linepts;
  float f = 1.0f;
  float a = 0.4f;
  float b = 0.0f;

  linepts.x = gid / (w / 2.0f) - 1.0f;
  linepts.y = b + a * sin(3.14 * 2.0 * ((float)gid / (float)w * f + (float)seq / (float)w));
  linepts.z = 0.5f;
  linepts.w = 0.0f;

  vbo[hook(0, gid)] = linepts;
}