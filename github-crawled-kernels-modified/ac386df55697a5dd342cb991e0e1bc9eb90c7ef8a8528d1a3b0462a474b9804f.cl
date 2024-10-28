//{"OriSigma":5,"counter":3,"grad":1,"grad_height":10,"grad_width":9,"hist":13,"hist2":12,"keypoints":0,"keypoints_end":8,"keypoints_start":7,"nb_keypoints":6,"octsize":4,"ori":2,"pos":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float4 float4;
kernel void orientation_assignment(global float4* keypoints, global float* grad, global float* ori, global int* counter, int octsize, float OriSigma, int nb_keypoints, int keypoints_start, int keypoints_end, int grad_width, int grad_height) {
  int lid0 = get_local_id(0);
  int groupid = get_group_id(0);

  if ((groupid < keypoints_start) || (groupid >= keypoints_end))
    return;
  float4 k = keypoints[hook(0, groupid)];
  if (k.s1 < 0.0f)
    return;

  int bin, prev = 0, next = 0;
  int old;
  float distsq, gval, angle, interp = 0.0;
  float hist_prev, hist_curr, hist_next;
  local volatile float hist[36];
  local volatile float hist2[256];
  local volatile int pos[256];
  float prev2, temp2;
  float ONE_3 = 1.0f / 3.0f;
  float ONE_18 = 1.0f / 18.0f;

  pos[hook(11, lid0)] = -1;
  hist2[hook(12, lid0)] = 0.0f;
  if (lid0 < 36)
    hist[hook(13, lid0)] = 0.0f;

  int row = (int)(k.s1 + 0.5), col = (int)(k.s2 + 0.5);

  float sigma = OriSigma * k.s3;
  int radius = (int)(sigma * 3.0);
  int rmin = ((0) < (row - radius) ? (row - radius) : (0));
  int cmin = ((0) < (col - radius) ? (col - radius) : (0));
  int rmax = ((row + radius) < (grad_height - 2) ? (row + radius) : (grad_height - 2));
  int cmax = ((col + radius) < (grad_width - 2) ? (col + radius) : (grad_width - 2));
  int i, j, r, c;
  for (r = rmin; r <= rmax; r++) {
    pos[hook(11, lid0)] = -1;
    hist2[hook(12, lid0)] = 0.0f;

    c = cmin + lid0;
    pos[hook(11, lid0)] = -1;
    hist2[hook(12, lid0)] = 0.0f;
    if (c <= cmax) {
      gval = grad[hook(1, r * grad_width + c)];
      distsq = (r - k.s1) * (r - k.s1) + (c - k.s2) * (c - k.s2);
      if (gval > 0.0f && distsq < ((radius * radius) + 0.5f)) {
        angle = ori[hook(2, r * grad_width + c)];
        bin = (int)(18.0f * (angle + 3.14159265358979323846264338327950288f) * 0.318309886183790671537767526745028724f);
        if (bin < 0)
          bin += 36;
        if (bin > 35)
          bin -= 36;
        hist2[hook(12, lid0)] = exp(-distsq / (2.0f * sigma * sigma)) * gval;
        pos[hook(11, lid0)] = bin;
      }
    }
    barrier(0x01);

    if (lid0 == 0) {
      for (i = 0; i < 256; i++)
        if (pos[hook(11, i)] != -1)
          hist[hook(13, pos[ihook(11, i))] += hist2[hook(12, i)];
    }
    barrier(0x01);
  }

  for (j = 0; j < 6; j++) {
    if (lid0 == 0) {
      hist2[hook(12, 0)] = hist[hook(13, 0)];
      hist[hook(13, 0)] = (hist[hook(13, 35)] + hist[hook(13, 0)] + hist[hook(13, 1)]) * ONE_3;
    }
    barrier(0x01);
    if (0 < lid0 && lid0 < 35) {
      hist2[hook(12, lid0)] = hist[hook(13, lid0)];
      hist[hook(13, lid0)] = (hist2[hook(12, lid0 - 1)] + hist[hook(13, lid0)] + hist[hook(13, lid0 + 1)]) * ONE_3;
    }
    barrier(0x01);
    if (lid0 == 35) {
      hist[hook(13, 35)] = (hist2[hook(12, 34)] + hist[hook(13, 35)] + hist[hook(13, 0)]) * ONE_3;
    }
    barrier(0x01);
  }

  hist2[hook(12, lid0)] = 0.0f;

  float maxval = 0.0f;
  int argmax = 0;

  pos[hook(11, lid0)] = -1;
  hist2[hook(12, lid0)] = 0.0f;

  if (lid0 < 32) {
    if (lid0 + 32 < 36) {
      if (hist[hook(13, lid0)] > hist[hook(13, lid0 + 32)]) {
        hist2[hook(12, lid0)] = hist[hook(13, lid0)];
        pos[hook(11, lid0)] = lid0;
      } else {
        hist2[hook(12, lid0)] = hist[hook(13, lid0 + 32)];
        pos[hook(11, lid0)] = lid0 + 32;
      }
    } else {
      hist2[hook(12, lid0)] = hist[hook(13, lid0)];
      pos[hook(11, lid0)] = lid0;
    }
  }
  barrier(0x01);
  if (lid0 < 16) {
    if (hist2[hook(12, lid0 + 16)] > hist2[hook(12, lid0)]) {
      hist2[hook(12, lid0)] = hist2[hook(12, lid0 + 16)];
      pos[hook(11, lid0)] = pos[hook(11, lid0 + 16)];
    }
  }
  barrier(0x01);
  if (lid0 < 8) {
    if (hist2[hook(12, lid0 + 8)] > hist2[hook(12, lid0)]) {
      hist2[hook(12, lid0)] = hist2[hook(12, lid0 + 8)];
      pos[hook(11, lid0)] = pos[hook(11, lid0 + 8)];
    }
  }
  barrier(0x01);
  if (lid0 < 04) {
    if (hist2[hook(12, lid0 + 4)] > hist2[hook(12, lid0)]) {
      hist2[hook(12, lid0)] = hist2[hook(12, lid0 + 4)];
      pos[hook(11, lid0)] = pos[hook(11, lid0 + 4)];
    }
  }
  barrier(0x01);
  if (lid0 < 02) {
    if (hist2[hook(12, lid0 + 2)] > hist2[hook(12, lid0)]) {
      hist2[hook(12, lid0)] = hist2[hook(12, lid0 + 2)];
      pos[hook(11, lid0)] = pos[hook(11, lid0 + 2)];
    }
  }
  barrier(0x01);
  if (lid0 == 0) {
    if (hist2[hook(12, 1)] > hist2[hook(12, 0)]) {
      hist2[hook(12, 0)] = hist2[hook(12, 1)];
      pos[hook(11, 0)] = pos[hook(11, 1)];
    }
    argmax = pos[hook(11, 0)];
    maxval = hist2[hook(12, 0)];

    prev = (argmax == 0 ? 35 : argmax - 1);
    next = (argmax == 35 ? 0 : argmax + 1);
    hist_prev = hist[hook(13, prev)];
    hist_next = hist[hook(13, next)];
    interp = 0.5f * (hist_prev - hist_next) / (hist_prev - 2.0f * maxval + hist_next);
    angle = (argmax + 0.5f + interp) * ONE_18;
    if (angle < 0.0f)
      angle += 2.0f;
    else if (angle > 2.0f)
      angle -= 2.0f;

    k.s0 = k.s2 * octsize;
    k.s1 = k.s1 * octsize;
    k.s2 = k.s3 * octsize;
    k.s3 = (angle - 1.0f) * 3.14159265358979323846264338327950288f;
    keypoints[hook(0, groupid)] = k;

    pos[hook(11, 0)] = argmax;
    hist2[hook(12, 0)] = maxval;
    hist2[hook(12, 1)] = k.s0;
    hist2[hook(12, 2)] = k.s1;
    hist2[hook(12, 3)] = k.s2;
    hist2[hook(12, 4)] = k.s3;
  }
  barrier(0x01);

  k = (float4)(hist2[hook(12, 1)], hist2[hook(12, 2)], hist2[hook(12, 3)], hist2[hook(12, 4)]);
  argmax = pos[hook(11, 0)];
  maxval = hist2[hook(12, 0)];

  if (lid0 < 36 && lid0 != argmax) {
    i = lid0;
    prev = (i == 0 ? 35 : i - 1);
    next = (i == 35 ? 0 : i + 1);
    hist_prev = hist[hook(13, prev)];
    hist_curr = hist[hook(13, i)];
    hist_next = hist[hook(13, next)];

    if (hist_curr > hist_prev && hist_curr > hist_next && hist_curr >= 0.8f * maxval) {
      interp = 0.5f * (hist_prev - hist_next) / (hist_prev - 2.0f * hist_curr + hist_next);
      angle = (i + 0.5f + interp) * ONE_18;
      if (angle < 0.0f)
        angle += 2.0f;
      else if (angle > 2.0f)
        angle -= 2.0f;
      k.s3 = (angle - 1.0f) * 3.14159265358979323846264338327950288f;
      old = atomic_inc(counter);
      if (old < nb_keypoints)
        keypoints[hook(0, old)] = k;
    }
  }
}