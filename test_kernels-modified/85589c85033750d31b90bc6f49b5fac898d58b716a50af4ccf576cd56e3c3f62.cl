//{"tick":1,"vertices":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sphere(global float4* vertices, float tick) {
  int longitude = get_global_id(0) / 16;
  int latitude = get_global_id(0) % 16;

  float sign = -2.0f * (longitude % 2) + 1.0f;
  float phi = 2.0f * 3.14159265358979323846264338327950288f * longitude / 16 + tick;
  float theta = 3.14159265358979323846264338327950288f * latitude / 16;

  vertices[hook(0, get_global_id(0))].x = 8 * sin(theta) * cos(phi);
  vertices[hook(0, get_global_id(0))].y = 8 * sign * cos(theta);
  vertices[hook(0, get_global_id(0))].z = 8 * sin(theta) * sin(phi);
  vertices[hook(0, get_global_id(0))].w = 1.0f;
}