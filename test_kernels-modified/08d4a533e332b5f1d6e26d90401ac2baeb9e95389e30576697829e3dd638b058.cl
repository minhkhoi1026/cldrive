//{"a":0,"dir":3,"m":1,"points_per_group":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 mul_complex(float2 a, float2 b) {
  return (float2)(a.s0 * b.s0 - a.s1 * b.s1, a.s0 * b.s1 + a.s1 * b.s0);
}

float2 exp_complex(float2 a) {
  return (float2)(exp(a.s0) * cos(a.s1), exp(a.s0) * sin(a.s1));
}

kernel void FFT2_ALL_POINTS(global float2* a, global const unsigned int* m, global const unsigned int* points_per_group, global const int* dir) {
  int points_per_item = *points_per_group / get_local_size(0);
  int start_addr = (get_global_id(0) + (get_global_id(0) / (*m >> 2)) * (*m >> 2)) * (points_per_item / 2);
  int angle = start_addr % *m;
  float2 omega;

  float2 t;
  float2 u;

  for (int j = start_addr; j < start_addr + points_per_item / 2; ++j) {
    omega = exp_complex((float2)(0.0, (*dir) * -3.14159265358979323846264338327950288f * angle / (*m >> 1)));
    t = mul_complex(omega, a[hook(0, j + (*m >> 1))]);
    u = a[hook(0, j)];
    a[hook(0, j)] = u + t;
    a[hook(0, j + (*m >> 1))] = u - t;
    angle++;
  }
}