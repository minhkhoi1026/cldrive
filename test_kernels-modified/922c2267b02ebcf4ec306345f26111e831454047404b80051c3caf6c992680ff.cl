//{"a":0,"debug":3,"dir":4,"l":1,"points_per_group":2}
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

kernel void FFT2(global float2* a, local float2* l, global const unsigned int* points_per_group, global float2* debug, global const int* dir) {
  int points_per_item = *points_per_group / get_local_size(0);
  int l_addr = get_local_id(0) * points_per_item;
  int a_addr = get_group_id(0) * *points_per_group + l_addr;
  int start_addr;

  float2 u;
  float2 s;
  float2 v;
  float2 t;

  float2 sumus;
  float2 diffus;
  float2 sumvt;
  float2 diffvt;

  float2 omega;
  float2 cur_omega;
  int angle;

  for (int i = 0; i < points_per_item; i += 4) {
    u = a[hook(0, a_addr)];
    s = a[hook(0, a_addr + 1)];
    v = a[hook(0, a_addr + 2)];
    t = a[hook(0, a_addr + 3)];

    sumus = u + s;
    diffus = u - s;
    sumvt = v + t;
    diffvt = (float2)(v.s1 - t.s1, t.s0 - v.s0) * (*dir);
    l[hook(1, l_addr)] = sumus + sumvt;
    l[hook(1, l_addr + 1)] = diffus + diffvt;
    l[hook(1, l_addr + 2)] = sumus - sumvt;
    l[hook(1, l_addr + 3)] = diffus - diffvt;
    l_addr += 4;
    a_addr += 4;
  }

  l_addr = get_local_id(0) * points_per_item;
  a_addr = get_group_id(0) * *points_per_group + l_addr;
  int m = 4;
  int lgppi = (int)log2((float)points_per_item);
  int lgppg = (int)log2((float)*points_per_group);
  barrier(0x01);

  for (int s = lgppi; s < lgppg; ++s) {
    m <<= 1;
    start_addr = (get_local_id(0) + (get_local_id(0) / (m >> 2)) * (m >> 2)) * (points_per_item / 2);
    angle = start_addr % m;
    for (int j = start_addr; j < start_addr + points_per_item / 2; ++j) {
      omega = exp_complex((float2)(0.0, (*dir) * -3.14159265358979323846264338327950288f * angle / (m >> 1)));
      t = mul_complex(omega, l[hook(1, j + (m >> 1))]);
      u = l[hook(1, j)];
      l[hook(1, j)] = u + t;
      l[hook(1, j + (m >> 1))] = u - t;
      angle++;
    }
    barrier(0x01);
  }

  l_addr = get_local_id(0) * points_per_item;
  a_addr = get_group_id(0) * *points_per_group + l_addr;
  for (int i = 0; i < points_per_item; i++) {
    a[hook(0, a_addr + i)] = l[hook(1, l_addr + i)];
  }
}