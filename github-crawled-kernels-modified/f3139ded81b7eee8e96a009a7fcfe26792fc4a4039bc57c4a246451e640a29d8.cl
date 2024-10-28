//{"I1wx":0,"I1wx_col":1,"I1wx_row":2,"I1wx_step":3,"I1wy":4,"calc_error":22,"error":14,"grad":5,"image":23,"l_t":15,"p11":7,"p12":8,"p21":9,"p22":10,"rho_c":6,"theta":16,"u1":11,"u1_offset_x":18,"u1_offset_y":19,"u1_step":12,"u2":13,"u2_offset_x":20,"u2_offset_y":21,"u2_step":17,"v1":24,"v2":25}
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

inline float readImage(global float* image, int x, int y, int rows, int cols, int elemCntPerRow) {
  int i0 = clamp(x, 0, cols - 1);
  int j0 = clamp(y, 0, rows - 1);

  return image[hook(23, j0 * elemCntPerRow + i0)];
}

inline float divergence(global const float* v1, global const float* v2, int y, int x, int v1_step, int v2_step) {
  if (x > 0 && y > 0) {
    float v1x = v1[hook(24, y * v1_step + x)] - v1[hook(24, y * v1_step + x - 1)];
    float v2y = v2[hook(25, y * v2_step + x)] - v2[hook(25, (y - 1) * v2_step + x)];
    return v1x + v2y;
  } else {
    if (y > 0)
      return v1[hook(24, y * v1_step + 0)] + v2[hook(25, y * v2_step + 0)] - v2[hook(25, (y - 1) * v2_step + 0)];
    else {
      if (x > 0)
        return v1[hook(24, 0 * v1_step + x)] - v1[hook(24, 0 * v1_step + x - 1)] + v2[hook(25, 0 * v2_step + x)];
      else
        return v1[hook(24, 0 * v1_step + 0)] + v2[hook(25, 0 * v2_step + 0)];
    }
  }
}

kernel void estimateUKernel(global const float* I1wx, int I1wx_col, int I1wx_row, int I1wx_step, global const float* I1wy, global const float* grad, global const float* rho_c, global const float* p11, global const float* p12, global const float* p21, global const float* p22, global float* u1, int u1_step, global float* u2, global float* error, float l_t, float theta, int u2_step, int u1_offset_x, int u1_offset_y, int u2_offset_x, int u2_offset_y, char calc_error) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < I1wx_col && y < I1wx_row) {
    float I1wxVal = I1wx[hook(0, y * I1wx_step + x)];
    float I1wyVal = I1wy[hook(4, y * I1wx_step + x)];
    float gradVal = grad[hook(5, y * I1wx_step + x)];
    float u1OldVal = u1[hook(11, (y + u1_offset_y) * u1_step + x + u1_offset_x)];
    float u2OldVal = u2[hook(13, (y + u2_offset_y) * u2_step + x + u2_offset_x)];

    float rho = rho_c[hook(6, y * I1wx_step + x)] + (I1wxVal * u1OldVal + I1wyVal * u2OldVal);

    float d1 = 0.0f;
    float d2 = 0.0f;

    if (rho < -l_t * gradVal) {
      d1 = l_t * I1wxVal;
      d2 = l_t * I1wyVal;
    } else if (rho > l_t * gradVal) {
      d1 = -l_t * I1wxVal;
      d2 = -l_t * I1wyVal;
    } else if (gradVal > 1.192092896e-07f) {
      float fi = -rho / gradVal;
      d1 = fi * I1wxVal;
      d2 = fi * I1wyVal;
    }

    float v1 = u1OldVal + d1;
    float v2 = u2OldVal + d2;

    float div_p1 = divergence(p11, p12, y, x, I1wx_step, I1wx_step);
    float div_p2 = divergence(p21, p22, y, x, I1wx_step, I1wx_step);

    float u1NewVal = v1 + theta * div_p1;
    float u2NewVal = v2 + theta * div_p2;

    u1[hook(11, (y + u1_offset_y) * u1_step + x + u1_offset_x)] = u1NewVal;
    u2[hook(13, (y + u2_offset_y) * u2_step + x + u2_offset_x)] = u2NewVal;

    if (calc_error) {
      float n1 = (u1OldVal - u1NewVal) * (u1OldVal - u1NewVal);
      float n2 = (u2OldVal - u2NewVal) * (u2OldVal - u2NewVal);
      error[hook(14, y * I1wx_step + x)] = n1 + n2;
    }
  }
}