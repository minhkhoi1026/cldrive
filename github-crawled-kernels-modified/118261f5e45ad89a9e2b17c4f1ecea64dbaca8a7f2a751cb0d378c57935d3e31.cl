//{"exclude":7,"g_distances":2,"g_uquery":0,"g_vpointset":1,"kdistances":8,"kth":6,"pointdim":3,"signallength":5,"triallength":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float insertPointKlist(int kth, float distance, int indexv, local float* kdistances) {
  int k = 0;
  while ((distance > *(kdistances + k)) && (k < kth - 1)) {
    k++;
  }

  for (int k2 = kth - 1; k2 > k; k2--) {
    *(kdistances + k2) = *(kdistances + k2 - 1);
  }

  *(kdistances + k) = distance;

  return *(kdistances + kth - 1);
}

float maxMetricPoints(global const float* g_uquery, global const float* g_vpoint, int pointdim, int signallength) {
  float r_u1;
  float r_v1;
  float r_d1, r_dim = 0;

  r_dim = 0;
  for (int d = 0; d < pointdim; d++) {
    r_u1 = *(g_uquery + d * signallength);
    r_v1 = *(g_vpoint + d * signallength);
    r_d1 = r_v1 - r_u1;
    r_d1 = r_d1 < 0 ? -r_d1 : r_d1;
    r_dim = r_dim < r_d1 ? r_d1 : r_dim;
  }
  return r_dim;
}

kernel void kernelKNNshared(global const float* g_uquery, global const float* g_vpointset, global float* g_distances, const int pointdim, const int triallength, const int signallength, const int kth, const int exclude, local float* kdistances) {
  const unsigned int tid = get_global_id(0) + get_global_id(1) * get_global_size(0);
  const unsigned int itrial = tid / triallength;

  if (tid < signallength) {
    for (int k = 0; k < kth; k++) {
      kdistances[hook(8, get_local_id(0) * kth + k)] = (__builtin_inff());
    }

    barrier(0x01);

    float r_kdist = (__builtin_inff());
    unsigned int indexi = tid - triallength * itrial;

    for (int t = 0; t < triallength; t++) {
      int indexu = tid;
      int indexv = (t + itrial * triallength);
      int condition1 = indexi - exclude;
      int condition2 = indexi + exclude;

      if ((t < condition1) || (t > condition2)) {
        float temp_dist = maxMetricPoints(g_uquery + indexu, g_vpointset + indexv, pointdim, signallength);
        if (temp_dist <= r_kdist) {
          r_kdist = insertPointKlist(kth, temp_dist, t, kdistances + get_local_id(0) * kth);
        }
      }
    }

    barrier(0x01);

    for (int k = 0; k < kth; k++) {
      g_distances[hook(2, tid + k * signallength)] = kdistances[hook(8, get_local_id(0) * kth + k)];
    }
  }
}