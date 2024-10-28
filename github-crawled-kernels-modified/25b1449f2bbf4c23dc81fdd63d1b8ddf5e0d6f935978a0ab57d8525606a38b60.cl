//{"cov":3,"depthThreshold":2,"mmax":4,"normals":1,"positions":0}
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

kernel void estimate_normals_covariance_kernel(global float* positions, global float* normals, float depthThreshold) {
  const unsigned int gidx = get_global_id(0);
  const unsigned int gidy = get_global_id(1);
  const unsigned int gsizex = get_global_size(0);
  const unsigned int gsizey = get_global_size(1);

  const unsigned int centerIndex = mul24(gidy, gsizex) + gidx;
  float3 center = vload3(centerIndex, positions);
  if (center.z > 0.0f) {
    float3 centroid = center;
    unsigned int validCount = 0;

    float3 Left = (float3)(0.0f, 0.0f, -1.f);
    float3 LeftLeft = (float3)(0.0f, 0.0f, -1.f);
    if (gidx > 0) {
      Left = vload3(centerIndex - 1, positions);
      if (Left.z > 0.0f && fabs(center.z - Left.z) < depthThreshold) {
        centroid += Left;
        validCount++;

        if (gidx > 1) {
          LeftLeft = vload3(centerIndex - 2, positions);
          if (LeftLeft.z > 0.0f && fabs(center.z - LeftLeft.z) < depthThreshold) {
            centroid += LeftLeft;
            validCount++;
          }
        }
      }
    }

    float3 Right = (float3)(0.0f, 0.0f, -1.f);
    float3 RightRight = (float3)(0.0f, 0.0f, -1.f);
    if (gidx < gsizex - 1) {
      Right = vload3(centerIndex + 1, positions);
      if (Right.z > 0.0f && fabs(center.z - Right.z) < depthThreshold) {
        centroid += Right;
        validCount++;

        if (gidx < gsizex - 2) {
          RightRight = vload3(centerIndex + 2, positions);
          if (RightRight.z > 0.0f && fabs(center.z - RightRight.z) < depthThreshold) {
            centroid += RightRight;
            validCount++;
          }
        }
      }
    }

    float3 Up = (float3)(0.0f, 0.0f, -1.f);
    float3 UpUp = (float3)(0.0f, 0.0f, -1.f);
    if (gidy > 0) {
      Up = vload3(centerIndex - gsizex, positions);
      if (Up.z > 0.0f && fabs(center.z - Up.z) < depthThreshold) {
        centroid += Up;
        validCount++;

        if (gidy > 1) {
          UpUp = vload3(centerIndex - 2 * gsizex, positions);
          if (UpUp.z > 0.0f && fabs(center.z - UpUp.z) < depthThreshold) {
            centroid += UpUp;
            validCount++;
          }
        }
      }
    }

    float3 Down = (float3)(0.0f, 0.0f, -1.f);
    float3 DownDown = (float3)(0.0f, 0.0f, -1.f);
    if (gidy < gsizey - 1) {
      Down = vload3(centerIndex + gsizex, positions);
      if (Down.z > 0.0f && fabs(center.z - Down.z) < depthThreshold) {
        centroid += Down;
        validCount++;

        if (gidy < gsizey - 2) {
          DownDown = vload3(centerIndex + 2 * gsizex, positions);
          if (DownDown.z > 0.0f && fabs(center.z - DownDown.z) < depthThreshold) {
            centroid += DownDown;
            validCount++;
          }
        }
      }
    }

    float3 LeftUp = (float3)(0.0f, 0.0f, -1.f);
    float3 LeftUpLeft = (float3)(0.0f, 0.0f, -1.f);
    float3 LeftUpUp = (float3)(0.0f, 0.0f, -1.f);
    float3 LeftUpLeftUp = (float3)(0.0f, 0.0f, -1.f);
    if (gidx > 0 && gidy > 0) {
      LeftUp = vload3(centerIndex - gsizex - 1, positions);
      if (LeftUp.z > 0.0f && fabs(center.z - LeftUp.z) < depthThreshold) {
        centroid += LeftUp;
        validCount++;

        if (gidx > 1 && gidy > 0) {
          LeftUp = vload3(centerIndex - gsizex - 2, positions);
          if (LeftUp.z > 0.0f && fabs(center.z - LeftUp.z) < depthThreshold) {
            centroid += LeftUp;
            validCount++;
          }
        }

        if (gidx > 0 && gidy > 1) {
          LeftUpUp = vload3(centerIndex - 2 * gsizex - 1, positions);
          if (LeftUpUp.z > 0.0f && fabs(center.z - LeftUpUp.z) < depthThreshold) {
            centroid += LeftUpUp;
            validCount++;
          }
        }

        if (gidx > 1 && gidy > 1) {
          LeftUpLeftUp = vload3(centerIndex - 2 * gsizex - 2, positions);
          if (LeftUpLeftUp.z > 0.0f && fabs(center.z - LeftUpLeftUp.z) < depthThreshold) {
            centroid += LeftUpLeftUp;
            validCount++;
          }
        }
      }
    }

    float3 LeftDown = (float3)(0.0f, 0.0f, -1.f);
    float3 LeftDownLeft = (float3)(0.0f, 0.0f, -1.f);
    float3 LeftDownDown = (float3)(0.0f, 0.0f, -1.f);
    float3 LeftDownLeftDown = (float3)(0.0f, 0.0f, -1.f);
    if (gidx > 0 && gidy < gsizey - 1) {
      LeftDown = vload3(centerIndex + gsizex - 1, positions);
      if (LeftDown.z > 0.0f && fabs(center.z - LeftDown.z) < depthThreshold) {
        centroid += LeftDown;
        validCount++;

        if (gidx > 1 && gidy < gsizey - 1) {
          LeftDownLeft = vload3(centerIndex + gsizex - 2, positions);
          if (LeftDownLeft.z > 0.0f && fabs(center.z - LeftDownLeft.z) < depthThreshold) {
            centroid += LeftDownLeft;
            validCount++;
          }
        }

        if (gidx > 0 && gidy < gsizey - 2) {
          LeftDownDown = vload3(centerIndex + 2 * gsizex - 1, positions);
          if (LeftDownDown.z > 0.0f && fabs(center.z - LeftDownDown.z) < depthThreshold) {
            centroid += LeftDownDown;
            validCount++;
          }
        }

        if (gidx > 1 && gidy < gsizey - 2) {
          LeftDownLeftDown = vload3(centerIndex + 2 * gsizex - 2, positions);
          if (LeftDownLeftDown.z > 0.0f && fabs(center.z - LeftDownLeftDown.z) < depthThreshold) {
            centroid += LeftDownLeftDown;
            validCount++;
          }
        }
      }
    }

    float3 RightUp = (float3)(0.0f, 0.0f, -1.f);
    float3 RightUpRight = (float3)(0.0f, 0.0f, -1.f);
    float3 RightUpUp = (float3)(0.0f, 0.0f, -1.f);
    float3 RightUpRightUp = (float3)(0.0f, 0.0f, -1.f);
    if (gidx < gsizex - 1 && gidy > 0) {
      RightUp = vload3(centerIndex - gsizex + 1, positions);
      if (RightUp.z > 0.0f && fabs(center.z - RightUp.z) < depthThreshold) {
        centroid += RightUp;
        validCount++;

        if (gidx < gsizex - 2 && gidy > 0) {
          RightUpRight = vload3(centerIndex - gsizex + 2, positions);
          if (RightUpRight.z > 0.0f && fabs(center.z - RightUpRight.z) < depthThreshold) {
            centroid += RightUpRight;
            validCount++;
          }
        }

        if (gidx < gsizex - 1 && gidy > 1) {
          RightUpUp = vload3(centerIndex - 2 * gsizex + 1, positions);
          if (RightUpUp.z > 0.0f && fabs(center.z - RightUpUp.z) < depthThreshold) {
            centroid += RightUpUp;
            validCount++;
          }
        }

        if (gidx < gsizex - 2 && gidy > 1) {
          RightUpRightUp = vload3(centerIndex - 2 * gsizex + 2, positions);
          if (RightUpRightUp.z > 0.0f && fabs(center.z - RightUpRightUp.z) < depthThreshold) {
            centroid += RightUpRightUp;
            validCount++;
          }
        }
      }
    }

    float3 RightDown = (float3)(0.0f, 0.0f, -1.f);
    float3 RightDownRight = (float3)(0.0f, 0.0f, -1.f);
    float3 RightDownDown = (float3)(0.0f, 0.0f, -1.f);
    float3 RightDownRightDown = (float3)(0.0f, 0.0f, -1.f);
    if (gidx < gsizex - 1 && gidy < gsizey - 1) {
      RightDown = vload3(centerIndex + gsizex + 1, positions);
      if (RightDown.z > 0.0f && fabs(center.z - RightDown.z) < depthThreshold) {
        centroid += RightDown;
        validCount++;

        if (gidx < gsizex - 2 && gidy < gsizey - 1) {
          RightDownRight = vload3(centerIndex + gsizex + 2, positions);
          if (RightDownRight.z > 0.0f && fabs(center.z - RightDownRight.z) < depthThreshold) {
            centroid += RightDownRight;
            validCount++;
          }
        }

        if (gidx < gsizex - 1 && gidy < gsizey - 2) {
          RightDownDown = vload3(centerIndex + 2 * gsizex + 1, positions);
          if (RightDownDown.z > 0.0f && fabs(center.z - RightDownDown.z) < depthThreshold) {
            centroid += RightDownDown;
            validCount++;
          }
        }

        if (gidx < gsizex - 2 && gidy < gsizey - 2) {
          RightDownRightDown = vload3(centerIndex + 2 * gsizex + 2, positions);
          if (RightDownRightDown.z > 0.0f && fabs(center.z - RightDownRightDown.z) < depthThreshold) {
            centroid += RightDownRightDown;
            validCount++;
          }
        }
      }
    }

    centroid *= 1.f / (validCount + 1);
    float cov[6];
    {
      float3 d = center - centroid;
      cov[hook(3, 0)] = d.x * d.x;
      cov[hook(3, 1)] = d.x * d.y;
      cov[hook(3, 2)] = d.x * d.z;
      cov[hook(3, 3)] = d.y * d.y;
      cov[hook(3, 4)] = d.y * d.z;
      cov[hook(3, 5)] = d.z * d.z;

      if (Left.z > 0.0f) {
        d = Left - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (LeftLeft.z > 0.0f) {
        d = LeftLeft - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (Right.z > 0.0f) {
        d = Right - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (RightRight.z > 0.0f) {
        d = RightRight - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (Up.z > 0.0f) {
        d = Up - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (UpUp.z > 0.0f) {
        d = UpUp - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (Down.z > 0.0f) {
        d = Down - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (DownDown.z > 0.0f) {
        d = DownDown - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (LeftUp.z > 0.0f) {
        d = LeftUp - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (LeftUpLeft.z > 0.0f) {
        d = LeftUpLeft - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (LeftUpUp.z > 0.0f) {
        d = LeftUpUp - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (LeftUpLeftUp.z > 0.0f) {
        d = LeftUpLeftUp - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (LeftDown.z > 0.0f) {
        d = LeftDown - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (LeftDownLeft.z > 0.0f) {
        d = LeftDownLeft - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (LeftDownDown.z > 0.0f) {
        d = LeftDownDown - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (LeftDownLeftDown.z > 0.0f) {
        d = LeftDownLeftDown - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (RightUp.z > 0.0f) {
        d = RightUp - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (RightUpRight.z > 0.0f) {
        d = RightUpRight - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (RightUpRight.z > 0.0f) {
        d = RightUpRight - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (RightUpRightUp.z > 0.0f) {
        d = RightUpRightUp - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (RightDown.z > 0.0f) {
        d = RightDown - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (RightDownRight.z > 0.0f) {
        d = RightDownRight - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (RightDownDown.z > 0.0f) {
        d = RightDownDown - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }

      if (RightDownRightDown.z > 0.0f) {
        d = RightDownRightDown - centroid;
        cov[hook(3, 0)] += d.x * d.x;
        cov[hook(3, 1)] += d.x * d.y;
        cov[hook(3, 2)] += d.x * d.z;
        cov[hook(3, 3)] += d.y * d.y;
        cov[hook(3, 4)] += d.y * d.z;
        cov[hook(3, 5)] += d.z * d.z;
      }
    }
    float c0 = cov[hook(3, 0)] * cov[hook(3, 3)] * cov[hook(3, 5)] + 2.f * cov[hook(3, 1)] * cov[hook(3, 2)] * cov[hook(3, 4)] - cov[hook(3, 0)] * cov[hook(3, 4)] * cov[hook(3, 4)] - cov[hook(3, 3)] * cov[hook(3, 2)] * cov[hook(3, 2)] - cov[hook(3, 5)] * cov[hook(3, 1)] * cov[hook(3, 1)];
    float c1 = cov[hook(3, 0)] * cov[hook(3, 3)] + cov[hook(3, 0)] * cov[hook(3, 5)] + cov[hook(3, 5)] * cov[hook(3, 3)] - cov[hook(3, 1)] * cov[hook(3, 1)] - cov[hook(3, 2)] * cov[hook(3, 2)] - cov[hook(3, 4)] * cov[hook(3, 4)];
    float c2 = cov[hook(3, 0)] + cov[hook(3, 3)] + cov[hook(3, 5)];
    float3 evals = computeRoots3(c0, c1, c2);

    if (evals.z - evals.x <= 1.192092896e-07f) {
      float3 evecs0 = (float3)(0.f, 0.f, -1.f);
      vstore3(evecs0, centerIndex, normals);
    } else if (evals.y - evals.x <= 1.192092896e-07f) {
      float3 row0 = (float3)(cov[hook(3, 0)], cov[hook(3, 1)], cov[hook(3, 2)]);
      float3 row1 = (float3)(cov[hook(3, 1)], cov[hook(3, 3)], cov[hook(3, 4)]);
      float3 row2 = (float3)(cov[hook(3, 2)], cov[hook(3, 4)], cov[hook(3, 5)]);
      row0.x -= evals.z;
      row1.y -= evals.z;
      row2.z -= evals.z;

      float3 vec_tmp0 = cross(row0, row1);
      float3 vec_tmp1 = cross(row0, row2);
      float3 vec_tmp2 = cross(row1, row2);

      float len1 = dot(vec_tmp0, vec_tmp0);
      float len2 = dot(vec_tmp1, vec_tmp1);
      float len3 = dot(vec_tmp2, vec_tmp2);

      float3 evecs2;
      if (len1 > len2 && len1 > len3) {
        evecs2 = vec_tmp0 * rsqrt(len1);
      } else if (len2 > len1 && len2 > len3) {
        evecs2 = vec_tmp1 * rsqrt(len2);
      } else {
        evecs2 = vec_tmp2 * rsqrt(len3);
      }
      float3 evecs1 = unitOrthogonal(evecs2);
      float3 evecs0 = fast_normalize(cross(evecs1, evecs2));
      vstore3(evecs0.z > 0.f ? -evecs0 : evecs0, centerIndex, normals);
    } else if (evals.z - evals.y <= 1.192092896e-07f) {
      float3 row0 = (float3)(cov[hook(3, 0)], cov[hook(3, 1)], cov[hook(3, 2)]);
      float3 row1 = (float3)(cov[hook(3, 1)], cov[hook(3, 3)], cov[hook(3, 4)]);
      float3 row2 = (float3)(cov[hook(3, 2)], cov[hook(3, 4)], cov[hook(3, 5)]);
      row0.x -= evals.x;
      row1.y -= evals.x;
      row2.z -= evals.x;

      float3 vec_tmp0 = cross(row0, row1);
      float3 vec_tmp1 = cross(row0, row2);
      float3 vec_tmp2 = cross(row1, row2);

      float len1 = dot(vec_tmp0, vec_tmp0);
      float len2 = dot(vec_tmp1, vec_tmp1);
      float len3 = dot(vec_tmp2, vec_tmp2);

      float3 evecs0;
      if (len1 > len2 && len1 > len3) {
        evecs0 = vec_tmp0 * rsqrt(len1);
      } else if (len2 > len1 && len2 > len3) {
        evecs0 = vec_tmp1 * rsqrt(len2);
      } else {
        evecs0 = vec_tmp2 * rsqrt(len3);
      }
      evecs0 = fast_normalize(evecs0);
      vstore3(evecs0.z > 0.f ? -evecs0 : evecs0, centerIndex, normals);
    } else {
      float3 row0 = (float3)(cov[hook(3, 0)], cov[hook(3, 1)], cov[hook(3, 2)]);
      float3 row1 = (float3)(cov[hook(3, 1)], cov[hook(3, 3)], cov[hook(3, 4)]);
      float3 row2 = (float3)(cov[hook(3, 2)], cov[hook(3, 4)], cov[hook(3, 5)]);
      row0.x -= evals.z;
      row1.y -= evals.z;
      row2.z -= evals.z;

      float3 vec_tmp0 = cross(row0, row1);
      float3 vec_tmp1 = cross(row0, row2);
      float3 vec_tmp2 = cross(row1, row2);

      float len1 = dot(vec_tmp0, vec_tmp0);
      float len2 = dot(vec_tmp1, vec_tmp1);
      float len3 = dot(vec_tmp2, vec_tmp2);

      float mmax[3];
      unsigned int min_el = 2;
      unsigned int max_el = 2;

      float3 evecs2;
      if (len1 > len2 && len1 > len3) {
        mmax[hook(4, 2)] = len1;
        evecs2 = vec_tmp0 * rsqrt(len1);
      } else if (len2 > len1 && len2 > len3) {
        mmax[hook(4, 2)] = len2;
        evecs2 = vec_tmp1 * rsqrt(len2);
      } else {
        mmax[hook(4, 2)] = len3;
        evecs2 = vec_tmp2 * rsqrt(len3);
      }

      row0.x = cov[hook(3, 0)] - evals.y;
      row1.y = cov[hook(3, 3)] - evals.y;
      row2.z = cov[hook(3, 5)] - evals.y;

      vec_tmp0 = cross(row0, row1);
      vec_tmp1 = cross(row0, row2);
      vec_tmp2 = cross(row1, row2);

      len1 = dot(vec_tmp0, vec_tmp0);
      len2 = dot(vec_tmp1, vec_tmp1);
      len3 = dot(vec_tmp2, vec_tmp2);

      float3 evecs1;
      if (len1 > len2 && len1 > len3) {
        mmax[hook(4, 1)] = len1;
        evecs1 = vec_tmp0 * rsqrt(len1);
        min_el = len1 <= mmax[hook(4, min_el)] ? 1 : min_el;
        max_el = len1 > mmax[hook(4, max_el)] ? 1 : max_el;
      } else if (len2 > len1 && len2 > len3) {
        mmax[hook(4, 1)] = len2;
        evecs1 = vec_tmp1 * rsqrt(len2);
        min_el = len2 <= mmax[hook(4, min_el)] ? 1 : min_el;
        max_el = len2 > mmax[hook(4, max_el)] ? 1 : max_el;
      } else {
        mmax[hook(4, 1)] = len3;
        evecs1 = vec_tmp2 * rsqrt(len3);
        min_el = len3 <= mmax[hook(4, min_el)] ? 1 : min_el;
        max_el = len3 > mmax[hook(4, max_el)] ? 1 : max_el;
      }

      row0.x = cov[hook(3, 0)] - evals.x;
      row1.y = cov[hook(3, 3)] - evals.x;
      row2.z = cov[hook(3, 5)] - evals.x;

      vec_tmp0 = cross(row0, row1);
      vec_tmp1 = cross(row0, row2);
      vec_tmp2 = cross(row1, row2);

      len1 = dot(vec_tmp0, vec_tmp0);
      len2 = dot(vec_tmp1, vec_tmp1);
      len3 = dot(vec_tmp2, vec_tmp2);

      float3 evecs0;
      if (len1 > len2 && len1 > len3) {
        mmax[hook(4, 0)] = len1;
        evecs0 = vec_tmp0 * rsqrt(len1);
        min_el = len1 <= mmax[hook(4, min_el)] ? 0 : min_el;
        max_el = len1 > mmax[hook(4, max_el)] ? 0 : max_el;
      } else if (len2 > len1 && len2 > len3) {
        mmax[hook(4, 0)] = len2;
        evecs0 = vec_tmp1 * rsqrt(len2);
        min_el = len2 <= mmax[hook(4, min_el)] ? 0 : min_el;
        max_el = len2 > mmax[hook(4, max_el)] ? 0 : max_el;
      } else {
        mmax[hook(4, 0)] = len3;
        evecs0 = vec_tmp2 * rsqrt(len3);
        min_el = len3 <= mmax[hook(4, min_el)] ? 0 : min_el;
        max_el = len3 > mmax[hook(4, max_el)] ? 0 : max_el;
      }

      if (min_el == 0) {
        evecs0 = fast_normalize(cross(evecs1, evecs2));
      } else if (max_el == 0) {
        evecs0 = fast_normalize(evecs0);
      } else if (min_el == 1) {
        evecs1 = cross(evecs0, evecs2);
        evecs0 = fast_normalize(cross(evecs1, evecs2));
      } else {
        evecs2 = cross(evecs0, evecs1);
        evecs0 = fast_normalize(cross(evecs1, evecs2));
      }
      vstore3(evecs0.z > 0.f ? -evecs0 : evecs0, centerIndex, normals);
    }
  } else {
    float3 norm = (float3)(0.0f, 0.0f, 0.0f);
    vstore3(norm, centerIndex, normals);
  }
}