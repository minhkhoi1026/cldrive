//{"center":10,"centers":1,"centers_count":7,"centers_offset":9,"centers_step":5,"dists":2,"feature_length":3,"features_count":6,"src":0,"src_offset":8,"src_step":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float distance_(global const float* center, global const float* src, int feature_length) {
  float res = 0;
  float4 v0, v1, v2;
  int i = 0;

  for (; i <= feature_length - 4; i += 4) {
    v0 = vload4(0, center + i);
    v1 = vload4(0, src + i);
    v2 = v1 - v0;

    res += dot(v2, v2);
  }

  for (; i < feature_length; ++i) {
    float t0 = src[hook(0, i)];
    float t1 = center[hook(10, i)];

    float t2 = t0 - t1;
    res += t2 * t2;
  }

  return res;
}

kernel void distanceToCenters(global const float* src, global const float* centers, global float* dists, int feature_length, int src_step, int centers_step, int features_count, int centers_count, int src_offset, int centers_offset) {
  int gid = get_global_id(0);

  if (gid < (features_count * centers_count)) {
    int feature_index = gid / centers_count;
    int center_index = gid % centers_count;

    int center_idx = mad24(center_index, centers_step, centers_offset);
    int src_idx = mad24(feature_index, src_step, src_offset);

    dists[hook(2, gid)] = distance_(centers + center_idx, src + src_idx, feature_length);
  }
}