//{"DOGS":0,"InitSigma":5,"end_keypoints":3,"height":7,"keypoints":1,"peak_thresh":4,"start_keypoints":2,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float4 float4;
kernel void interp_keypoint(global float* DOGS, global float4* keypoints, int start_keypoints, int end_keypoints, float peak_thresh, float InitSigma, int width, int height) {
  int gid0 = (int)get_global_id(0);

  if ((gid0 >= start_keypoints) && (gid0 < end_keypoints)) {
    float4 k = keypoints[hook(1, gid0)];
    int r = (int)k.s1;
    int c = (int)k.s2;
    int scale = (int)k.s3;
    if (r != -1) {
      int index_dog_prev = (scale - 1) * (width * height);
      int index_dog = scale * (width * height);
      int index_dog_next = (scale + 1) * (width * height);

      float g0, g1, g2, H00, H11, H22, H01, H02, H12, H10, H20, H21, K00, K11, K22, K01, K02, K12, K10, K20, K21, solution0, solution1, solution2, det, peakval;
      int pos = r * width + c;
      int loop = 1, movesRemain = 5;
      int newr = r, newc = c;

      while (loop == 1) {
        r = newr, c = newc;
        pos = newr * width + newc;

        g0 = (DOGS[hook(0, index_dog_next + pos)] - DOGS[hook(0, index_dog_prev + pos)]) / 2.0f;
        g1 = (DOGS[hook(0, index_dog + (newr + 1) * width + newc)] - DOGS[hook(0, index_dog + (newr - 1) * width + newc)]) / 2.0f;
        g2 = (DOGS[hook(0, index_dog + pos + 1)] - DOGS[hook(0, index_dog + pos - 1)]) / 2.0f;

        H00 = DOGS[hook(0, index_dog_prev + pos)] - 2.0f * DOGS[hook(0, index_dog + pos)] + DOGS[hook(0, index_dog_next + pos)];
        H11 = DOGS[hook(0, index_dog + (newr - 1) * width + newc)] - 2.0f * DOGS[hook(0, index_dog + pos)] + DOGS[hook(0, index_dog + (newr + 1) * width + newc)];
        H22 = DOGS[hook(0, index_dog + pos - 1)] - 2.0f * DOGS[hook(0, index_dog + pos)] + DOGS[hook(0, index_dog + pos + 1)];

        H01 = ((DOGS[hook(0, index_dog_next + (newr + 1) * width + newc)] - DOGS[hook(0, index_dog_next + (newr - 1) * width + newc)]) - (DOGS[hook(0, index_dog_prev + (newr + 1) * width + newc)] - DOGS[hook(0, index_dog_prev + (newr - 1) * width + newc)])) / 4.0f;

        H02 = ((DOGS[hook(0, index_dog_next + pos + 1)] - DOGS[hook(0, index_dog_next + pos - 1)]) - (DOGS[hook(0, index_dog_prev + pos + 1)] - DOGS[hook(0, index_dog_prev + pos - 1)])) / 4.0f;

        H12 = ((DOGS[hook(0, index_dog + (newr + 1) * width + newc + 1)] - DOGS[hook(0, index_dog + (newr + 1) * width + newc - 1)]) - (DOGS[hook(0, index_dog + (newr - 1) * width + newc + 1)] - DOGS[hook(0, index_dog + (newr - 1) * width + newc - 1)])) / 4.0f;

        H10 = H01;
        H20 = H02;
        H21 = H12;

        det = -(H02 * H11 * H20) + H01 * H12 * H20 + H02 * H10 * H21 - H00 * H12 * H21 - H01 * H10 * H22 + H00 * H11 * H22;

        K00 = H11 * H22 - H12 * H21;
        K01 = H02 * H21 - H01 * H22;
        K02 = H01 * H12 - H02 * H11;
        K10 = H12 * H20 - H10 * H22;
        K11 = H00 * H22 - H02 * H20;
        K12 = H02 * H10 - H00 * H12;
        K20 = H10 * H21 - H11 * H20;
        K21 = H01 * H20 - H00 * H21;
        K22 = H00 * H11 - H01 * H10;

        solution0 = -(g0 * K00 + g1 * K01 + g2 * K02) / det;
        solution1 = -(g0 * K10 + g1 * K11 + g2 * K12) / det;
        solution2 = -(g0 * K20 + g1 * K21 + g2 * K22) / det;

        peakval = DOGS[hook(0, index_dog + pos)] + 0.5f * (solution0 * g0 + solution1 * g1 + solution2 * g2);

        if (solution1 > 0.6f && newr < height - 3)
          newr++;
        else if (solution1 < -0.6f && newr > 3)
          newr--;
        if (solution2 > 0.6f && newc < width - 3)
          newc++;
        else if (solution2 < -0.6f && newc > 3)
          newc--;

        if (movesRemain > 0 && (newr != r || newc != c))
          movesRemain--;
        else
          loop = 0;
      }

      float4 ki = 0.0f;
      if (fabs(solution0) <= 1.5f && fabs(solution1) <= 1.5f && fabs(solution2) <= 1.5f && fabs(peakval) >= peak_thresh) {
        ki.s0 = peakval;
        ki.s1 = r + solution1;
        ki.s2 = c + solution2;
        ki.s3 = InitSigma * pow(2.0f, (((float)scale) + solution0) / 3.0f);
      } else {
        ki.s0 = -1.0f;
        ki.s1 = -1.0f;
        ki.s2 = -1.0f;
        ki.s3 = -1.0f;
      }

      keypoints[hook(1, gid0)] = ki;
    }
  }
}