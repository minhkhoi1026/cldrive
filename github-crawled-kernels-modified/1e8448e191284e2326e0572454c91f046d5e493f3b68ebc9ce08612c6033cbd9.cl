//{"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 square(float2 a) {
  float2 at;
  at.x = (a.x * a.x) - (a.y * a.y);
  at.y = 2 * a.x * a.y;
  return at;
}
kernel void squareKernel(global const float2* a, global float2* b) {
  int id = get_global_id(0);
  b[hook(1, id)] = square(a[hook(0, id)]);
}