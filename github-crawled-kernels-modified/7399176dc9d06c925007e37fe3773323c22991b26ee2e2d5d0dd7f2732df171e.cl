//{"descriptors":1,"grad":2,"grad_height":8,"grad_width":7,"keypoints":0,"keypoints_end":6,"keypoints_start":5,"octsize":4,"orim":3,"tmp_descriptors":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float4 float4;
kernel void descriptor(global float4* keypoints, global unsigned char* descriptors, global float* grad, global float* orim, int octsize, int keypoints_start, global int* keypoints_end, int grad_width, int grad_height) {
  int gid0 = get_global_id(0);
  float4 k = keypoints[hook(0, gid0)];
  if (!(keypoints_start <= gid0 && gid0 < *keypoints_end && k.s1 >= 0.0f))
    return;

  int i, j, u, v, old;

  local volatile float tmp_descriptors[128];
  for (i = 0; i < 128; i++)
    tmp_descriptors[hook(9, i)] = 0.0f;

  float rx, cx;
  float row = k.s1 / octsize, col = k.s0 / octsize, angle = k.s3;
  int irow = (int)(row + 0.5f), icol = (int)(col + 0.5f);
  float sine = sin((float)angle), cosine = cos((float)angle);
  float spacing = k.s2 / octsize * 3.0f;
  int iradius = (int)((1.414f * spacing * 2.5f) + 0.5f);

  for (i = -iradius; i <= iradius; i++) {
    for (j = -iradius; j <= iradius; j++) {
      rx = ((cosine * i - sine * j) - (row - irow)) / spacing + 1.5f;
      cx = ((sine * i + cosine * j) - (col - icol)) / spacing + 1.5f;
      if ((rx > -1.0f && rx < 4.0f && cx > -1.0f && cx < 4.0f && (irow + i) >= 0 && (irow + i) < grad_height && (icol + j) >= 0 && (icol + j) < grad_width)) {
        float mag = grad[hook(2, (int)(icol + j) + (int)(irow + i) * grad_width)] * exp(-0.125f * ((rx - 1.5f) * (rx - 1.5f) + (cx - 1.5f) * (cx - 1.5f)));
        float ori = orim[hook(3, (int)(icol + j) + (int)(irow + i) * grad_width)] - angle;
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
              float rweight = (float)(mag * (float)((r == 0) ? 1.0f - rfrac : rfrac));

              for (int c = 0; c < 2; c++) {
                cindex = ci + c;
                if ((cindex >= 0 && cindex < 4)) {
                  cweight = rweight * ((c == 0) ? 1.0f - cfrac : cfrac);
                  for (orr = 0; orr < 2; orr++) {
                    oindex = oi + orr;
                    if (oindex >= 8) {
                      oindex = 0;
                    }
                    tmp_descriptors[hook(9, (rindex * 4 + cindex) * 8 + oindex)] += cweight * ((orr == 0) ? 1.0f - ofrac : ofrac);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  float norm = 0;
  for (i = 0; i < 128; i++)
    norm += tmp_descriptors[hook(9, i)] * tmp_descriptors[hook(9, i)];
  norm = rsqrt(norm);
  for (i = 0; i < 128; i++) {
    tmp_descriptors[hook(9, i)] *= norm;
  }

  bool changed = false;
  norm = 0;
  for (i = 0; i < 128; i++) {
    if (tmp_descriptors[hook(9, i)] > 0.2f) {
      tmp_descriptors[hook(9, i)] = 0.2f;
      changed = true;
    }
    norm += tmp_descriptors[hook(9, i)] * tmp_descriptors[hook(9, i)];
  }

  if (changed == true) {
    norm = rsqrt(norm);
    for (i = 0; i < 128; i++)
      tmp_descriptors[hook(9, i)] *= norm;
  }

  int intval;
  for (i = 0; i < 128; i++) {
    intval = (int)(512.0 * tmp_descriptors[hook(9, i)]);
    descriptors[hook(1, 128 * gid0 + i)] = (unsigned char)((255) < (intval) ? (255) : (intval));
  }
}