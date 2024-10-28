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
  float a = (float)h / 4.0f;
  float b = w / 2.0f;

  linepts.x = gid;
  linepts.y = b + a * sin(3.14 * 2.0 * ((float)gid / (float)w * f + (float)seq / (float)w));
  linepts.z = gid + 1.0f;
  linepts.w = b + a * sin(3.14 * 2.0 * ((float)(gid + 1.0f) / (float)w * f + (float)seq / (float)w));

  vbo[hook(0, gid)] = linepts;
}