//{"counter":2,"end_keypoint":4,"keypoints":0,"output":1,"start_keypoint":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float4 float4;
kernel void compact(global float4* keypoints, global float4* output, global int* counter, int start_keypoint, int end_keypoint) {
  int gid0 = (int)get_global_id(0);
  if (gid0 < start_keypoint) {
    output[hook(1, gid0)] = keypoints[hook(0, gid0)];
  } else if (gid0 < end_keypoint) {
    float4 k = keypoints[hook(0, gid0)];

    if (k.s1 != -1) {
      int old = atomic_inc(counter);
      if (old < end_keypoint)
        output[hook(1, old)] = k;
    }
  }
}