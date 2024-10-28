//{"depthThreshold":2,"normals":1,"positions":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float3 computeRoots2(float b, float c) {
  float3 roots = (float3)(0.f, 0.f, 0.f);
  float d = b * b - 4.f * c;
  if (d < 0.f)
    d = 0.f;

  float sd = sqrt(d);

  roots.z = 0.5f * (b + sd);
  roots.y = 0.5f * (b - sd);
  return roots;
}

float3 computeRoots3(float c0, float c1, float c2) {
  float3 roots = (float3)(0.f, 0.f, 0.f);

  if (fabs(c0) > 1.192092896e-07f) {
    const float s_inv3 = 0.3333333f;
    const float s_sqrt3 = sqrt(3.f);

    float c2_over_3 = c2 * s_inv3;
    float a_over_3 = (c1 - c2 * c2_over_3) * s_inv3;
    if (a_over_3 > 0.f)
      a_over_3 = 0.f;

    float half_b = 0.5f * (c0 + c2_over_3 * (2.f * c2_over_3 * c2_over_3 - c1));

    float q = half_b * half_b + a_over_3 * a_over_3 * a_over_3;
    if (q > 0.f)
      q = 0.f;

    float rho = sqrt(-a_over_3);
    float theta = atan2(sqrt(-q), half_b) * s_inv3;
    float cos_theta;
    float sin_theta = sincos(theta, &cos_theta);

    roots.x = c2_over_3 + 2.f * rho * cos_theta;
    roots.y = c2_over_3 - rho * (cos_theta + s_sqrt3 * sin_theta);
    roots.z = c2_over_3 - rho * (cos_theta - s_sqrt3 * sin_theta);

    uint2 mask = (uint2)(1, 0);

    if (roots.x > roots.y) {
      roots.xy = shuffle(roots.xy, mask);
    }

    if (roots.y > roots.z) {
      roots.yz = shuffle(roots.yz, mask);

      if (roots.x > roots.y) {
        roots.xy = shuffle(roots.xy, mask);
      }
    }
    if (roots.x < 0)
      roots = computeRoots2(c2, c1);
  } else {
    roots = computeRoots2(c2, c1);
  }
  return roots;
}

float3 unitOrthogonal(float3 src) {
  float3 perp;

  const float prec_sqr = 1.192092896e-07f;
  if ((fabs(src.x) > prec_sqr * fabs(src.z)) || (fabs(src.y) > prec_sqr * fabs(src.z))) {
    float invnm = rsqrt(src.x * src.x + src.y * src.y);
    perp.x = -src.y * invnm;
    perp.y = src.x * invnm;
    perp.z = 0.0f;
  }

  else {
    float invnm = rsqrt(src.z * src.z + src.y * src.y);
    perp.x = 0.0f;
    perp.y = -src.z * invnm;
    perp.z = src.y * invnm;
  }
  return perp;
}

kernel void estimate_normals_kernel(global float* positions, global float* normals, float depthThreshold) {
  unsigned int gidx = get_global_id(0);
  unsigned int gidy = get_global_id(1);
  unsigned int gsizex = get_global_size(0);
  unsigned int gsizey = get_global_size(1);

  const unsigned int centerIndex = mul24(gidy, gsizex) + gidx;
  float3 center = vload3(centerIndex, positions);
  if (center.z > 0.0f) {
    float3 left = center;
    if (gidx > 0) {
      left = vload3(centerIndex - 1, positions);
      if (left.z < 0.0f || fabs(center.z - left.z) > depthThreshold)
        left = center;
    }
    float3 right = center;
    if (gidx < gsizex - 1) {
      right = vload3(centerIndex + 1, positions);
      if (right.z < 0.0f || fabs(center.z - right.z) > depthThreshold)
        right = center;
    }
    float3 up = center;
    if (gidy > 0) {
      up = vload3(centerIndex - gsizex, positions);
      if (up.z < 0.0f || fabs(center.z - up.z) > depthThreshold)
        up = center;
    }
    float3 down = center;
    if (gidy < gsizey - 1) {
      down = vload3(centerIndex + gsizex, positions);
      if (down.z < 0.0f || fabs(center.z - down.z) > depthThreshold)
        down = center;
    }
    float3 leftUp = center;
    if (gidx > 0 && gidy > 0) {
      leftUp = vload3(centerIndex - gsizex - 1, positions);
      if (leftUp.z < 0.0f || fabs(center.z - leftUp.z) > depthThreshold)
        leftUp = center;
    }
    float3 leftDown = center;
    if (gidx > 0 && gidy < gsizey - 1) {
      leftDown = vload3(centerIndex + gsizex - 1, positions);
      if (leftDown.z < 0.0f || fabs(center.z - leftDown.z) > depthThreshold)
        leftDown = center;
    }
    float3 rightUp = center;
    if (gidx < gsizex - 1 && gidy > 0) {
      rightUp = vload3(centerIndex - gsizex + 1, positions);
      if (rightUp.z < 0.0f || fabs(center.z - rightUp.z) > depthThreshold)
        rightUp = center;
    }
    float3 rightDown = center;
    if (gidx < gsizex - 1 && gidy < gsizey - 1) {
      rightDown = vload3(centerIndex + gsizex + 1, positions);
      if (rightDown.z < 0.0f || fabs(center.z - rightDown.z) > depthThreshold)
        rightDown = center;
    }

    float3 norm = fast_normalize(cross((right - left) + (rightDown - leftDown) + (rightUp - leftUp), (down - up) + (rightDown - rightUp) + (leftDown - leftUp)));
    vstore3(norm, centerIndex, normals);
  } else {
    float3 norm = (float3)(0.0f, 0.0f, 0.0f);
    vstore3(norm, centerIndex, normals);
  }
}