//{"V":2,"list":3,"proj":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int isLeft(const float2 P0, const float2 P1, const float2 P2) {
  return ((P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y));
}

inline int wn_PnPoly(const float2 P, constant float2* V, const ulong n) {
  int wn = 0;

  for (ulong i = 0; i < n; i++) {
    if (V[hook(2, i)].y <= P.y) {
      if (V[hook(2, i + 1)].y > P.y)
        if (isLeft(V[hook(2, i)], V[hook(2, i + 1)], P) > 0)
          ++wn;
    } else {
      if (V[hook(2, i + 1)].y <= P.y)
        if (isLeft(V[hook(2, i)], V[hook(2, i + 1)], P) < 0)
          --wn;
    }
  }
  return wn;
}

inline float median_by_bubble_sort(float list[], const unsigned int n) {
  unsigned int n_i = n;
  while (n_i >= n / 2) {
    unsigned int new_n = 0;
    for (unsigned int i = 1; i < n_i; ++i) {
      if (list[hook(3, i - 1)] > list[hook(3, i)]) {
        float t = list[hook(3, i)];
        list[hook(3, i)] = list[hook(3, i - 1)];
        list[hook(3, i - 1)] = t;
        new_n = i;
      }
    }
    n_i = new_n;
  }
  return list[hook(3, n / 2)];
}

kernel void i_to_log_i_kernel(global float* proj, const ulong2 size) {
  const ulong id = get_global_id(0);
  if (id >= size.x * size.y) {
    return;
  }

  const float i_val = proj[hook(0, id)];
  if (i_val > 0.0) {
    proj[hook(0, id)] = -log(i_val);
  } else {
    proj[hook(0, id)] = 6.3;
  }
}