//{"V":5,"list":6,"localbuffer":8,"median_radius":4,"proj_prim":1,"proj_raw":0,"proj_sca":2,"size":3,"unsorted_vector":7}
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

kernel void log_i_to_i_subtract_median_y_x(global const float* proj_raw, global const float* proj_prim, global float* proj_sca, const ulong2 size, const unsigned int median_radius) {
  const ulong local_id = get_local_id(0);
  const ulong group_id = get_group_id(0);
  const unsigned int actual_local_size = (size.x * size.y) / get_num_groups(0);

  const long first_id_in_group = actual_local_size * group_id - median_radius;
  const long id = first_id_in_group + local_id;

  if (id >= size.x * size.y || id < 0) {
    return;
  }
  const long j = id / size.x;
  const long i = id - j * size.x;

  local float localbuffer[128];
  float unsorted_vector[64];
  unsigned int i_uv = 0;

  for (int y = -median_radius; y <= (int)median_radius; ++y) {
    const int jy = j + y;
    if (jy < 0 || jy >= size.y) {
      continue;
    }
    const ulong r_id = i + jy * size.x;

    const float raw_val = proj_raw[hook(0, r_id)];

    const float raw_i = exp(-raw_val);

    const float prim_val = proj_prim[hook(1, r_id)];
    const float prim_i = exp(-prim_val);

    unsorted_vector[hook(7, i_uv++)] = raw_i - prim_i;
  }

  localbuffer[hook(8, local_id)] = median_by_bubble_sort(unsorted_vector, i_uv);

  barrier(0x01);

  if (local_id < median_radius || local_id >= (median_radius + actual_local_size)) {
    return;
  }

  i_uv = 0;
  for (int x = -median_radius; x <= (int)median_radius; ++x) {
    const int ix = local_id + x;
    if (ix < 0 || ix >= 128) {
      continue;
    }
    unsorted_vector[hook(7, i_uv++)] = localbuffer[hook(8, ix)];
  }

  const float median = median_by_bubble_sort(unsorted_vector, i_uv);

  proj_sca[hook(2, id)] = median;
}