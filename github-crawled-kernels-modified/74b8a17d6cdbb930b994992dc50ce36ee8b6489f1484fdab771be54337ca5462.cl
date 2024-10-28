//{"I0":0,"I0_col":2,"I0_row":3,"I0_step":1,"I1_step":17,"I1w":10,"I1w_step":15,"I1wx":11,"I1wy":12,"I1x_step":18,"grad":13,"image":19,"rho":14,"tex_I1":4,"tex_I1x":5,"tex_I1y":6,"u1":7,"u1_step":8,"u2":9,"u2_step":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float bicubicCoeff(float x_) {
  float x = fabs(x_);
  if (x <= 1.0f)
    return x * x * (1.5f * x - 2.5f) + 1.0f;
  else if (x < 2.0f)
    return x * (x * (-0.5f * x + 2.5f) - 4.0f) + 2.0f;
  else
    return 0.0f;
}

inline float readImage(global const float* image, int x, int y, int rows, int cols, int elemCntPerRow) {
  int i0 = clamp(x, 0, cols - 1);
  int j0 = clamp(y, 0, rows - 1);

  return image[hook(19, j0 * elemCntPerRow + i0)];
}

kernel void warpBackwardKernelNoImage2d(global const float* I0, int I0_step, int I0_col, int I0_row, global const float* tex_I1, global const float* tex_I1x, global const float* tex_I1y, global const float* u1, int u1_step, global const float* u2, global float* I1w, global float* I1wx, global float* I1wy, global float* grad, global float* rho, int I1w_step, int u2_step, int I1_step, int I1x_step) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < I0_col && y < I0_row) {
    float u1Val = u1[hook(7, y * u1_step + x)];

    float u2Val = u2[hook(9, y * u2_step + x)];

    float wx = x + u1Val;
    float wy = y + u2Val;

    int xmin = ceil(wx - 2.0f);
    int xmax = floor(wx + 2.0f);

    int ymin = ceil(wy - 2.0f);
    int ymax = floor(wy + 2.0f);

    float sum = 0.0f;
    float sumx = 0.0f;
    float sumy = 0.0f;
    float wsum = 0.0f;

    for (int cy = ymin; cy <= ymax; ++cy) {
      for (int cx = xmin; cx <= xmax; ++cx) {
        float w = bicubicCoeff(wx - cx) * bicubicCoeff(wy - cy);

        int2 cood = (int2)(cx, cy);
        sum += w * readImage(tex_I1, cood.x, cood.y, I0_col, I0_row, I1_step);
        sumx += w * readImage(tex_I1x, cood.x, cood.y, I0_col, I0_row, I1x_step);
        sumy += w * readImage(tex_I1y, cood.x, cood.y, I0_col, I0_row, I1x_step);
        wsum += w;
      }
    }

    float coeff = 1.0f / wsum;

    float I1wVal = sum * coeff;
    float I1wxVal = sumx * coeff;
    float I1wyVal = sumy * coeff;

    I1w[hook(10, y * I1w_step + x)] = I1wVal;
    I1wx[hook(11, y * I1w_step + x)] = I1wxVal;
    I1wy[hook(12, y * I1w_step + x)] = I1wyVal;

    float Ix2 = I1wxVal * I1wxVal;
    float Iy2 = I1wyVal * I1wyVal;

    grad[hook(13, y * I1w_step + x)] = Ix2 + Iy2;

    float I0Val = I0[hook(0, y * I0_step + x)];
    rho[hook(14, y * I1w_step + x)] = I1wVal - I1wxVal * u1Val - I1wyVal * u2Val - I0Val;
  }
}