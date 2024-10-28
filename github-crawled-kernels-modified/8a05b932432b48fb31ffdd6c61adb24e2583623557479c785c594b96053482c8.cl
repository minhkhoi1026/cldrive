//{"DATA_D":4,"DATA_H":3,"DATA_W":2,"Magnitudes":0,"float2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Calculate2DIndex(int x, int y, int DATA_W) {
  return x + y * DATA_W;
}

int Calculate3DIndex(int x, int y, int z, int DATA_W, int DATA_H) {
  return x + y * DATA_W + z * DATA_W * DATA_H;
}

int Calculate4DIndex(int x, int y, int z, int t, int DATA_W, int DATA_H, int DATA_D) {
  return x + y * DATA_W + z * DATA_W * DATA_H + t * DATA_W * DATA_H * DATA_D;
}

float mymax(float a, float b) {
  if (a > b)
    return a;
  else
    return b;
}

float InterpolateCubic(float p0, float p1, float p2, float p3, float delta) {
  float a0, a1, a2, a3, delta2;

  delta2 = delta * delta;
  a0 = p3 - p2 - p0 + p1;
  a1 = p0 - p1 - a0;
  a2 = p2 - p0;
  a3 = p1;

  return (a0 * delta * delta2 + a1 * delta2 + a2 * delta + a3);
}

kernel void CalculateMagnitudes(global float* Magnitudes, global const float2* float2, private int DATA_W, private int DATA_H, private int DATA_D) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (y >= DATA_H || z >= DATA_D)
    return;

  float r = float2[hook(1, Calculate3DIndex(x, y, z, DATA_W, DATA_H))].x;
  float i = float2[hook(1, Calculate3DIndex(x, y, z, DATA_W, DATA_H))].y;
  Magnitudes[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = sqrt(r * r + i * i);
}