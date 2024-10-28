//{"DOGS":0,"EdgeThresh":6,"EdgeThresh0":5,"border_dist":2,"counter":7,"height":11,"nb_keypoints":8,"octsize":4,"output":1,"peak_thresh":3,"scale":9,"width":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float4 float4;
kernel void local_maxmin(global float* DOGS, global float4* output, int border_dist, float peak_thresh, int octsize, float EdgeThresh0, float EdgeThresh, global int* counter, int nb_keypoints, int scale, int width, int height) {
  int gid1 = (int)get_global_id(1);
  int gid0 = (int)get_global_id(0);

  if ((gid1 < height - border_dist) && (gid0 < width - border_dist) && (gid1 >= border_dist) && (gid0 >= border_dist)) {
    int index_dog_prev = (scale - 1) * (width * height);
    int index_dog = scale * (width * height);
    int index_dog_next = (scale + 1) * (width * height);

    float res = 0.0f;
    float val = DOGS[hook(0, index_dog + gid0 + width * gid1)];

    if (fabs(val) > (0.8 * peak_thresh)) {
      int c, r, pos;
      int ismax = 0, ismin = 0;
      if (val > 0.0)
        ismax = 1;
      else
        ismin = 1;
      for (r = gid1 - 1; r <= gid1 + 1; r++) {
        for (c = gid0 - 1; c <= gid0 + 1; c++) {
          pos = r * width + c;
          if (ismax == 1)
            if (DOGS[hook(0, index_dog_prev + pos)] > val || DOGS[hook(0, index_dog + pos)] > val || DOGS[hook(0, index_dog_next + pos)] > val)
              ismax = 0;
          if (ismin == 1)
            if (DOGS[hook(0, index_dog_prev + pos)] < val || DOGS[hook(0, index_dog + pos)] < val || DOGS[hook(0, index_dog_next + pos)] < val)
              ismin = 0;
        }
      }

      if (ismax == 1 || ismin == 1)
        res = val;
      pos = gid1 * width + gid0;

      float H00 = DOGS[hook(0, index_dog + (gid1 - 1) * width + gid0)] - 2.0 * DOGS[hook(0, index_dog + pos)] + DOGS[hook(0, index_dog + (gid1 + 1) * width + gid0)], H11 = DOGS[hook(0, index_dog + pos - 1)] - 2.0 * DOGS[hook(0, index_dog + pos)] + DOGS[hook(0, index_dog + pos + 1)], H01 = ((DOGS[hook(0, index_dog + (gid1 + 1) * width + gid0 + 1)] - DOGS[hook(0, index_dog + (gid1 + 1) * width + gid0 - 1)]) - (DOGS[hook(0, index_dog + (gid1 - 1) * width + gid0 + 1)] - DOGS[hook(0, index_dog + (gid1 - 1) * width + gid0 - 1)])) / 4.0;

      float det = H00 * H11 - H01 * H01, trace = H00 + H11;

      float edthresh = (octsize <= 1 ? EdgeThresh0 : EdgeThresh);

      if (det < edthresh * trace * trace)
        res = 0.0f;

      if (res != 0.0f) {
        int old = atomic_inc(counter);
        float4 k = 0.0;
        k.s0 = val;
        k.s1 = (float)gid1;
        k.s2 = (float)gid0;
        k.s3 = (float)scale;
        if (old < nb_keypoints)
          output[hook(1, old)] = k;
      }
    }
  }
}