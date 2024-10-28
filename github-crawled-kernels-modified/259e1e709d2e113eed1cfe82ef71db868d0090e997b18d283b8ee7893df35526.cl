//{"changed":11,"descriptors":1,"grad":2,"grad_height":8,"grad_width":7,"hist2":10,"histogram":9,"keypoints":0,"keypoints_end":6,"keypoints_start":5,"octsize":4,"orim":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float4 float4;
kernel void descriptor(global float4* keypoints, global unsigned char* descriptors, global float* grad, global float* orim, int octsize, int keypoints_start, global int* keypoints_end, int grad_width, int grad_height) {
  int lid0 = get_local_id(0);
  int lid1 = get_local_id(1);
  int lid2 = get_local_id(2);
  int lid = (lid0 * 4 + lid1) * 4 + lid2;
  int groupid = get_group_id(0);
  float4 k = keypoints[hook(0, groupid)];
  if (!(keypoints_start <= groupid && groupid < *keypoints_end && k.s1 >= 0.0f))
    return;

  int i, j, j2;

  local volatile float histogram[128];
  local volatile float hist2[128 * 8];

  float rx, cx;
  float row = k.s1 / octsize, col = k.s0 / octsize, angle = k.s3;
  int irow = (int)(row + 0.5f), icol = (int)(col + 0.5f);
  float sine = sin((float)angle), cosine = cos((float)angle);
  float spacing = k.s2 / octsize * 3.0f;
  int radius = (int)((1.414f * spacing * 2.5f) + 0.5f);

  int imin = -64 + 32 * lid1, jmin = -64 + 32 * lid2;
  int imax = imin + 32, jmax = jmin + 32;

  histogram[hook(9, lid)] = 0.0f;
  for (i = 0; i < 8; i++)
    hist2[hook(10, lid * 8 + i)] = 0.0f;

  for (i = imin; i < imax; i++) {
    for (j2 = jmin / 8; j2 < jmax / 8; j2++) {
      j = j2 * 8 + lid0;

      rx = ((cosine * i - sine * j) - (row - irow)) / spacing + 1.5f;
      cx = ((sine * i + cosine * j) - (col - icol)) / spacing + 1.5f;
      if ((rx > -1.0f && rx < 4.0f && cx > -1.0f && cx < 4.0f && (irow + i) >= 0 && (irow + i) < grad_height && (icol + j) >= 0 && (icol + j) < grad_width)) {
        float mag = grad[hook(2, icol + j + (irow + i) * grad_width)] * exp(-0.125f * ((rx - 1.5f) * (rx - 1.5f) + (cx - 1.5f) * (cx - 1.5f)));
        float ori = orim[hook(3, icol + j + (irow + i) * grad_width)] - angle;

        while (ori > 2.0f * 3.14159265358979323846264338327950288f)
          ori -= 2.0f * 3.14159265358979323846264338327950288f;
        while (ori < 0.0f)
          ori += 2.0f * 3.14159265358979323846264338327950288f;
        int orr, rindex, cindex, oindex;
        float rweight, cweight;
        float oval = 4.0f * ori * 0.318309886183790671537767526745028724f;

        int ri = (int)((rx >= 0.0f) ? rx : rx - 1.0f), ci = (int)((cx >= 0.0f) ? cx : cx - 1.0f), oi = (int)((oval >= 0.0f) ? oval : oval - 1.0f);

        float rfrac = rx - ri, cfrac = cx - ci, ofrac = oval - oi;
        if ((ri >= -1 && ri < 4 && oi >= 0 && oi <= 8 && rfrac >= 0.0f && rfrac <= 1.0f)) {
          for (int r = 0; r < 2; r++) {
            rindex = ri + r;
            if ((rindex >= 0 && rindex < 4)) {
              rweight = mag * ((r == 0) ? 1.0f - rfrac : rfrac);

              for (int c = 0; c < 2; c++) {
                cindex = ci + c;
                if ((cindex >= 0 && cindex < 4)) {
                  cweight = rweight * ((c == 0) ? 1.0f - cfrac : cfrac);
                  for (orr = 0; orr < 2; orr++) {
                    oindex = oi + orr;
                    if (oindex >= 8) {
                      oindex = 0;
                    }
                    int bin = (rindex * 4 + cindex) * 8 + oindex;
                    hist2[hook(10, lid0 + 8 * bin)] += cweight * ((orr == 0) ? 1.0f - ofrac : ofrac);
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  barrier(0x01);
  histogram[hook(9, lid)] += hist2[hook(10, lid * 8)] + hist2[hook(10, lid * 8 + 1)] + hist2[hook(10, lid * 8 + 2)] + hist2[hook(10, lid * 8 + 3)] + hist2[hook(10, lid * 8 + 4)] + hist2[hook(10, lid * 8 + 5)] + hist2[hook(10, lid * 8 + 6)] + hist2[hook(10, lid * 8 + 7)];

  barrier(0x01);

  hist2[hook(10, lid)] = histogram[hook(9, lid)] * histogram[hook(9, lid)];

  if (lid < 64) {
    hist2[hook(10, lid)] += hist2[hook(10, lid + 64)];
  }
  barrier(0x01);
  if (lid < 32) {
    hist2[hook(10, lid)] += hist2[hook(10, lid + 32)];
  }
  barrier(0x01);
  if (lid < 16) {
    hist2[hook(10, lid)] += hist2[hook(10, lid + 16)];
  }
  barrier(0x01);
  if (lid < 8) {
    hist2[hook(10, lid)] += hist2[hook(10, lid + 8)];
  }
  barrier(0x01);
  if (lid < 4) {
    hist2[hook(10, lid)] += hist2[hook(10, lid + 4)];
  }
  barrier(0x01);
  if (lid < 2) {
    hist2[hook(10, lid)] += hist2[hook(10, lid + 2)];
  }
  barrier(0x01);
  if (lid == 0)
    hist2[hook(10, 0)] = rsqrt(hist2[hook(10, 1)] + hist2[hook(10, 0)]);
  barrier(0x01);

  histogram[hook(9, lid)] *= hist2[hook(10, 0)];

  local int changed[1];
  if (lid == 0)
    changed[hook(11, 0)] = 0;
  if (histogram[hook(9, lid)] > 0.2f) {
    histogram[hook(9, lid)] = 0.2f;
    atomic_inc(changed);
  }
  barrier(0x01);

  if (changed[hook(11, 0)]) {
    hist2[hook(10, lid)] = histogram[hook(9, lid)] * histogram[hook(9, lid)];
    if (lid < 64) {
      hist2[hook(10, lid)] += hist2[hook(10, lid + 64)];
    }
    barrier(0x01);
    if (lid < 32) {
      hist2[hook(10, lid)] += hist2[hook(10, lid + 32)];
    }
    barrier(0x01);
    if (lid < 16) {
      hist2[hook(10, lid)] += hist2[hook(10, lid + 16)];
    }
    barrier(0x01);
    if (lid < 8) {
      hist2[hook(10, lid)] += hist2[hook(10, lid + 8)];
    }
    barrier(0x01);
    if (lid < 4) {
      hist2[hook(10, lid)] += hist2[hook(10, lid + 4)];
    }
    barrier(0x01);
    if (lid < 2) {
      hist2[hook(10, lid)] += hist2[hook(10, lid + 2)];
    }
    barrier(0x01);
    if (lid == 0)
      hist2[hook(10, 0)] = rsqrt(hist2[hook(10, 0)] + hist2[hook(10, 1)]);
    barrier(0x01);
    histogram[hook(9, lid)] *= hist2[hook(10, 0)];
  }

  barrier(0x01);

  descriptors[hook(1, 128 * groupid + lid)] = (unsigned char)((255) < ((unsigned char)(512.0f * histogram[hook(9, lid)])) ? (255) : ((unsigned char)(512.0f * histogram[hook(9, lid)])));
}