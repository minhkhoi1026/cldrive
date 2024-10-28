//{"OriSigma":5,"counter":3,"grad":1,"grad_height":10,"grad_width":9,"hist":11,"keypoints":0,"keypoints_end":8,"keypoints_start":7,"nb_keypoints":6,"octsize":4,"ori":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float4 float4;
kernel void orientation_assignment(global float4* keypoints, global float* grad, global float* ori, global int* counter, int octsize, float OriSigma, int nb_keypoints, int keypoints_start, int keypoints_end, int grad_width, int grad_height) {
  int gid0 = get_global_id(0);
  float4 k = keypoints[hook(0, gid0)];
  if (!(keypoints_start <= gid0 && gid0 < keypoints_end && k.s1 >= 0.0f))
    return;
  int bin, prev = 0, next = 0;
  int i, j, r, c;
  int old;
  float distsq, gval, angle, interp = 0.0;
  float hist_prev, hist_curr, hist_next;
  float hist[36];

  for (i = 0; i < 36; i++)
    hist[hook(11, i)] = 0.0f;

  int row = (int)(k.s1 + 0.5), col = (int)(k.s2 + 0.5);

  float sigma = OriSigma * k.s3;
  int radius = (int)(sigma * 3.0);
  int rmin = ((0) < (row - radius) ? (row - radius) : (0));
  int cmin = ((0) < (col - radius) ? (col - radius) : (0));
  int rmax = ((row + radius) < (grad_height - 2) ? (row + radius) : (grad_height - 2));
  int cmax = ((col + radius) < (grad_width - 2) ? (col + radius) : (grad_width - 2));

  for (r = rmin; r <= rmax; r++) {
    for (c = cmin; c <= cmax; c++) {
      gval = grad[hook(1, r * grad_width + c)];

      float dif = (r - k.s1);
      distsq = dif * dif;
      dif = (c - k.s2);
      distsq += dif * dif;

      if (gval > 0.0f && distsq < ((float)(radius * radius)) + 0.5f) {
        angle = ori[hook(2, r * grad_width + c)];
        bin = (int)(36.0f * (angle + 3.14159265358979323846264338327950288f + 0.001f) / (2.0f * 3.14159265358979323846264338327950288f));
        if (bin >= 0 && bin <= 36) {
          bin = ((bin) < (35) ? (bin) : (35));
          hist[hook(11, bin)] += exp(-distsq / (2.0f * sigma * sigma)) * gval;
        }
      }
    }
  }

  for (j = 0; j < 6; j++) {
    float prev, temp;
    prev = hist[hook(11, 35)];
    for (i = 0; i < 36; i++) {
      temp = hist[hook(11, i)];
      hist[hook(11, i)] = (prev + hist[hook(11, i)] + hist[hook(11, (i + 1 == 36) ? 0 : i + 1)]) / 3.0;
      prev = temp;
    }
  }

  float maxval = 0.0f;
  int argmax = 0;
  for (i = 0; i < 36; i++) {
    if (maxval < hist[hook(11, i)]) {
      maxval = hist[hook(11, i)];
      argmax = i;
    }
  }

  prev = (argmax == 0 ? 35 : argmax - 1);
  next = (argmax == 35 ? 0 : argmax + 1);
  hist_prev = hist[hook(11, prev)];
  hist_next = hist[hook(11, next)];
  if (maxval < 0.0f) {
    hist_prev = -hist_prev;
    maxval = -maxval;
    hist_next = -hist_next;
  }
  interp = 0.5f * (hist_prev - hist_next) / (hist_prev - 2.0f * maxval + hist_next);
  angle = 2.0f * 3.14159265358979323846264338327950288f * (argmax + 0.5f + interp) / 36.0f - 3.14159265358979323846264338327950288f;

  k.s0 = k.s2 * octsize;
  k.s1 = k.s1 * octsize;
  k.s2 = k.s3 * octsize;
  k.s3 = angle;
  keypoints[hook(0, gid0)] = k;

  for (i = 0; i < 36; i++) {
    int prev = (i == 0 ? 35 : i - 1);
    int next = (i == 35 ? 0 : i + 1);
    float hist_prev = hist[hook(11, prev)];
    float hist_curr = hist[hook(11, i)];
    float hist_next = hist[hook(11, next)];
    if (hist_curr > hist_prev && hist_curr > hist_next && hist_curr >= 0.8f * maxval && i != argmax) {
      if (hist_curr < 0.0f) {
        hist_prev = -hist_prev;
        hist_curr = -hist_curr;
        hist_next = -hist_next;
      }
      float interp = 0.5f * (hist_prev - hist_next) / (hist_prev - 2.0f * hist_curr + hist_next);
      float angle = 2.0f * 3.14159265358979323846264338327950288f * (i + 0.5f + interp) / 36.0 - 3.14159265358979323846264338327950288f;
      if (angle >= -3.14159265358979323846264338327950288f && angle <= 3.14159265358979323846264338327950288f) {
        k.s3 = angle;
        old = atomic_inc(counter);
        if (old < nb_keypoints)
          keypoints[hook(0, old)] = k;
      }
    }
  }
}