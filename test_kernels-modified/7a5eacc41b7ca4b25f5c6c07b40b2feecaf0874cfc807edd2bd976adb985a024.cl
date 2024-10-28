//{"V":5,"list":6,"median_radius":4,"proj_corr":2,"proj_raw":0,"proj_sca":1,"size":3,"unsorted_vector":7}
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
    if (V[hook(5, i)].y <= P.y) {
      if (V[hook(5, i + 1)].y > P.y)
        if (isLeft(V[hook(5, i)], V[hook(5, i + 1)], P) > 0)
          ++wn;
    } else {
      if (V[hook(5, i + 1)].y <= P.y)
        if (isLeft(V[hook(5, i)], V[hook(5, i + 1)], P) < 0)
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
      if (list[hook(6, i - 1)] > list[hook(6, i)]) {
        float t = list[hook(6, i)];
        list[hook(6, i)] = list[hook(6, i - 1)];
        list[hook(6, i - 1)] = t;
        new_n = i;
      }
    }
    n_i = new_n;
  }
  return list[hook(6, n / 2)];
}

kernel void log_i_to_i_subtract_median_i_to_log_i(global const float* proj_raw, global const float* proj_sca, global float* proj_corr, const ulong2 size, const int median_radius) {
  const ulong id = get_global_id(0);

  if (id >= size.x * size.y) {
    return;
  }
  const long j = id / size.x;
  const long i = id - j * size.x;

  float unsorted_vector[64];
  unsigned int i_uv = 0;

  for (int y = -median_radius; y <= median_radius; ++y) {
    const int jy = j + y;
    if (jy < 0 || jy > size.y) {
      continue;
    }
    const ulong id_jy = jy * size.x;
    for (int x = -median_radius; x <= median_radius; ++x) {
      const int ix = i + x;
      if (ix < 0 || ix > size.x) {
        continue;
      }
      const ulong r_id = ix + id_jy;
      const float raw_val = proj_raw[hook(0, r_id)];

      const float raw_i = exp(-raw_val);

      const float sca_i = proj_sca[hook(1, r_id)];

      unsorted_vector[hook(7, i_uv++)] = raw_i - sca_i;
    }
  }
  barrier(0x01);

  const float median = median_by_bubble_sort(unsorted_vector, i_uv);

  if (median > 0.0) {
    proj_corr[hook(2, id)] = -log(median);
  } else {
    proj_corr[hook(2, id)] = 6.3;
  }
}