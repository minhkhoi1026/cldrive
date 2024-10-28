//{"a":1,"m":0,"num":5,"p":3,"t":4,"v":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int gravity_averaging(global float* m, global float4* p, global float4* a, int num) {
  int i = get_global_id(0);
  float G = 0.00000000006673;
  float4 sum;
  int j = 0;

  sum.x = 0;
  sum.y = 0;
  sum.z = 0;
  sum.w = 0;

  for (j = 0; j < num; j++) {
    if (i == j)
      continue;

    float dx = p[hook(3, i)].x - p[hook(3, j)].x;
    float dy = p[hook(3, i)].y - p[hook(3, j)].y;
    float dz = p[hook(3, i)].z - p[hook(3, j)].z;

    float d = sqrt(dx * dx + dy * dy + dz * dz);

    float g = (G * m[hook(0, i)] * m[hook(0, j)]) / (d * d);

    sum.x += (dx / d) * g;
    sum.y += (dy / d) * g;
    sum.z += (dz / d) * g;
  }

  a[hook(1, i)].x = sum.x;
  a[hook(1, i)].y = sum.y;
  a[hook(1, i)].z = sum.z;

  return 0;
}

kernel void kernel_nbody(global float* m, global float4* a, global float4* v, global float4* p, global float* t, unsigned int num) {
  int i = get_global_id(0);

  gravity_averaging(m, p, a, num);

  p[hook(3, i)].x += v[hook(2, i)].x * t[hook(4, i)] + 0.5 * t[hook(4, i)] * t[hook(4, i)] * a[hook(1, i)].x;
  p[hook(3, i)].y += v[hook(2, i)].y * t[hook(4, i)] + 0.5 * t[hook(4, i)] * t[hook(4, i)] * a[hook(1, i)].y;
  p[hook(3, i)].z += v[hook(2, i)].z * t[hook(4, i)] + 0.5 * t[hook(4, i)] * t[hook(4, i)] * a[hook(1, i)].z;

  v[hook(2, i)].x += a[hook(1, i)].x * t[hook(4, i)];
  v[hook(2, i)].y += a[hook(1, i)].y * t[hook(4, i)];
  v[hook(2, i)].z += a[hook(1, i)].z * t[hook(4, i)];
}