//{"depthThreshold":2,"dotThreshold":3,"normals":1,"positions":0}
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

kernel void smooth_normals_kernel(global float* positions, global float* normals, float depthThreshold, float dotThreshold) {
  unsigned int gidx = get_global_id(0);
  unsigned int gidy = get_global_id(1);
  unsigned int gsizex = get_global_size(0);
  unsigned int gsizey = get_global_size(1);

  const unsigned int centerIndex = mul24(gidy, gsizex) + gidx;
  float3 center = vload3(centerIndex, positions);
  float3 centerNm = vload3(centerIndex, normals);
  float3 accNm = centerNm;
  if (center.z > 0.0f && length(centerNm) > 0.0f) {
    if (gidx > 0) {
      const unsigned int leftIndex = centerIndex - 1;
      float3 left = vload3(leftIndex, positions);
      if (left.z > 0.0f && fabs(center.z - left.z) < depthThreshold) {
        float3 leftNm = vload3(leftIndex, normals);
        float confidence = dot(leftNm, centerNm);
        if (confidence > dotThreshold) {
          accNm += confidence * leftNm;
        }

        if (gidx > 1) {
          const unsigned int leftLeftIndex = centerIndex - 2;
          float3 leftLeft = vload3(leftLeftIndex, positions);
          if (leftLeft.z > 0.0f && fabs(center.z - leftLeft.z) < depthThreshold) {
            float3 leftLeftNm = vload3(leftLeftIndex, normals);
            float confidence = dot(leftLeftNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * leftLeftNm;
            }
          }
        }
      }
    }

    if (gidx < gsizex - 1) {
      const unsigned int rightIndex = centerIndex + 1;
      float3 right = vload3(rightIndex, positions);
      if (right.z > 0.0f && fabs(center.z - right.z) < depthThreshold) {
        float3 rightNm = vload3(rightIndex, normals);
        float confidence = dot(rightNm, centerNm);
        if (confidence > dotThreshold) {
          accNm += confidence * rightNm;
        }

        if (gidx < gsizex - 2) {
          const unsigned int rightRightIndex = centerIndex + 2;
          float3 rightRight = vload3(rightRightIndex, positions);
          if (rightRight.z > 0.0f && fabs(center.z - rightRight.z) < depthThreshold) {
            float3 rightRightNm = vload3(rightRightIndex, normals);
            float confidence = dot(rightRightNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * rightRightNm;
            }
          }
        }
      }
    }

    if (gidy > 0) {
      const unsigned int upIndex = centerIndex - gsizex;
      float3 up = vload3(upIndex, positions);
      if (up.z > 0.0f && fabs(center.z - up.z) < depthThreshold) {
        float3 upNm = vload3(upIndex, normals);
        float confidence = dot(upNm, centerNm);
        if (confidence > dotThreshold) {
          accNm += confidence * upNm;
        }

        if (gidy > 1) {
          const unsigned int upUpIndex = centerIndex - 2 * gsizex;
          float3 upUp = vload3(upUpIndex, positions);
          if (upUp.z > 0.0f && fabs(center.z - upUp.z) < depthThreshold) {
            float3 upUpNm = vload3(upUpIndex, normals);
            float confidence = dot(upUpNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * upUpNm;
            }
          }
        }
      }
    }

    if (gidy < gsizey - 1) {
      const unsigned int downIndex = centerIndex + gsizex;
      float3 down = vload3(downIndex, positions);
      if (down.z > 0.0f && fabs(center.z - down.z) < depthThreshold) {
        float3 downNm = vload3(downIndex, normals);
        float confidence = dot(downNm, centerNm);
        if (confidence > dotThreshold) {
          accNm += confidence * downNm;
        }

        if (gidy < gsizey - 2) {
          const unsigned int downDownIndex = centerIndex + 2 * gsizex;
          float3 downDown = vload3(downDownIndex, positions);
          if (downDown.z > 0.0f && fabs(center.z - downDown.z) < depthThreshold) {
            float3 downDownNm = vload3(downDownIndex, normals);
            float confidence = dot(downDownNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * downDownNm;
            }
          }
        }
      }
    }

    if (gidx > 0 && gidy > 0) {
      const unsigned int leftUpIndex = centerIndex - gsizex - 1;
      float3 leftUp = vload3(leftUpIndex, positions);
      if (leftUp.z > 0.0f && fabs(center.z - leftUp.z) < depthThreshold) {
        float3 leftUpNm = vload3(leftUpIndex, normals);
        float confidence = dot(leftUpNm, centerNm);
        if (confidence > dotThreshold) {
          accNm += confidence * leftUpNm;
        }

        if (gidx > 1 && gidy > 0) {
          const unsigned int leftUpLeftIndex = centerIndex - gsizex - 2;
          float3 leftUpLeft = vload3(leftUpLeftIndex, positions);
          if (leftUpLeft.z > 0.0f && fabs(center.z - leftUpLeft.z) < depthThreshold) {
            float3 leftUpLeftNm = vload3(leftUpLeftIndex, normals);
            float confidence = dot(leftUpLeftNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * leftUpLeftNm;
            }
          }
        }

        if (gidx > 0 && gidy > 1) {
          const unsigned int leftUpUpIndex = centerIndex - 2 * gsizex - 1;
          float3 leftUpUp = vload3(leftUpUpIndex, positions);
          if (leftUpUp.z > 0.0f && fabs(center.z - leftUpUp.z) < depthThreshold) {
            float3 leftUpUpNm = vload3(leftUpUpIndex, normals);
            float confidence = dot(leftUpUpNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * leftUpUpNm;
            }
          }
        }

        if (gidx > 1 && gidy > 1) {
          const unsigned int leftUpLeftUpIndex = centerIndex - 2 * gsizex - 2;
          float3 leftUpLeftUp = vload3(leftUpLeftUpIndex, positions);
          if (leftUpLeftUp.z > 0.0f && fabs(center.z - leftUpLeftUp.z) < depthThreshold) {
            float3 leftUpLeftUpNm = vload3(leftUpLeftUpIndex, normals);
            float confidence = dot(leftUpLeftUpNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * leftUpLeftUpNm;
            }
          }
        }
      }
    }

    if (gidx > 0 && gidy < gsizey - 1) {
      const unsigned int leftDownIndex = centerIndex + gsizex - 1;
      float3 leftDown = vload3(leftDownIndex, positions);
      if (leftDown.z > 0.0f && fabs(center.z - leftDown.z) < depthThreshold) {
        float3 leftDownNm = vload3(leftDownIndex, normals);
        float confidence = dot(leftDownNm, centerNm);
        if (confidence > dotThreshold) {
          accNm += confidence * leftDownNm;
        }

        if (gidx > 1 && gidy < gsizey - 1) {
          const unsigned int leftDownLeftIndex = centerIndex + gsizex - 2;
          float3 leftDownLeft = vload3(leftDownLeftIndex, positions);
          if (leftDownLeft.z > 0.0f && fabs(center.z - leftDownLeft.z) < depthThreshold) {
            float3 leftDownLeftNm = vload3(leftDownLeftIndex, normals);
            float confidence = dot(leftDownLeftNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * leftDownLeftNm;
            }
          }
        }

        if (gidx > 0 && gidy < gsizey - 2) {
          const unsigned int leftDownDownIndex = centerIndex + 2 * gsizex - 1;
          float3 leftDownDown = vload3(leftDownDownIndex, positions);
          if (leftDownDown.z > 0.0f && fabs(center.z - leftDownDown.z) < depthThreshold) {
            float3 leftDownDownNm = vload3(leftDownDownIndex, normals);
            float confidence = dot(leftDownDownNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * leftDownDownNm;
            }
          }
        }

        if (gidx > 1 && gidy < gsizey - 2) {
          const unsigned int leftDownLeftDownIndex = centerIndex + 2 * gsizex - 2;
          float3 leftDownLeftDown = vload3(leftDownLeftDownIndex, positions);
          if (leftDownLeftDown.z > 0.0f && fabs(center.z - leftDownLeftDown.z) < depthThreshold) {
            float3 leftDownLeftDownNm = vload3(leftDownLeftDownIndex, normals);
            float confidence = dot(leftDownLeftDownNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * leftDownLeftDownNm;
            }
          }
        }
      }
    }

    if (gidx < gsizex - 1 && gidy > 0) {
      const unsigned int rightUpIndex = centerIndex - gsizex + 1;
      float3 rightUp = vload3(rightUpIndex, positions);
      if (rightUp.z > 0.0f && fabs(center.z - rightUp.z) < depthThreshold) {
        float3 rightUpNm = vload3(rightUpIndex, normals);
        float confidence = dot(rightUpNm, centerNm);
        if (confidence > dotThreshold) {
          accNm += confidence * rightUpNm;
        }

        if (gidx < gsizex - 2 && gidy > 0) {
          const unsigned int rightUpRightIndex = centerIndex - gsizex + 2;
          float3 rightUpRight = vload3(rightUpRightIndex, positions);
          if (rightUpRight.z > 0.0f && fabs(center.z - rightUpRight.z) < depthThreshold) {
            float3 rightUpRightNm = vload3(rightUpRightIndex, normals);
            float confidence = dot(rightUpRightNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * rightUpRightNm;
            }
          }
        }

        if (gidx < gsizex - 1 && gidy > 1) {
          const unsigned int rightUpUpIndex = centerIndex - 2 * gsizex + 1;
          float3 rightUpUp = vload3(rightUpUpIndex, positions);
          if (rightUpUp.z > 0.0f && fabs(center.z - rightUpUp.z) < depthThreshold) {
            float3 rightUpUpNm = vload3(rightUpUpIndex, normals);
            float confidence = dot(rightUpUpNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * rightUpUpNm;
            }
          }
        }

        if (gidx < gsizex - 2 && gidy > 1) {
          const unsigned int rightUpRightUpIndex = centerIndex - 2 * gsizex + 2;
          float3 rightUpRightUp = vload3(rightUpRightUpIndex, positions);
          if (rightUpRightUp.z > 0.0f && fabs(center.z - rightUpRightUp.z) < depthThreshold) {
            float3 rightUpRightUpNm = vload3(rightUpRightUpIndex, normals);
            float confidence = dot(rightUpRightUpNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * rightUpRightUpNm;
            }
          }
        }
      }
    }

    if (gidx < gsizex - 1 && gidy < gsizey - 1) {
      const unsigned int rightDownIndex = centerIndex + gsizex + 1;
      float3 rightDown = vload3(rightDownIndex, positions);
      if (rightDown.z > 0.0f && fabs(center.z - rightDown.z) < depthThreshold) {
        float3 rightDownNm = vload3(rightDownIndex, normals);
        float confidence = dot(rightDownNm, centerNm);
        if (confidence > dotThreshold) {
          accNm += confidence * rightDownNm;
        }

        if (gidx < gsizex - 2 && gidy < gsizey - 1) {
          const unsigned int rightDownRightIndex = centerIndex + gsizex + 2;
          float3 rightDownRight = vload3(rightDownRightIndex, positions);
          if (rightDownRight.z > 0.0f && fabs(center.z - rightDownRight.z) < depthThreshold) {
            float3 rightDownRightNm = vload3(rightDownRightIndex, normals);
            float confidence = dot(rightDownRightNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * rightDownRightNm;
            }
          }
        }

        if (gidx < gsizex - 1 && gidy < gsizey - 2) {
          const unsigned int rightDownDownIndex = centerIndex + 2 * gsizex + 1;
          float3 rightDownDown = vload3(rightDownDownIndex, positions);
          if (rightDownDown.z > 0.0f && fabs(center.z - rightDownDown.z) < depthThreshold) {
            float3 rightDownDownNm = vload3(rightDownDownIndex, normals);
            float confidence = dot(rightDownDownNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * rightDownDownNm;
            }
          }
        }

        if (gidx < gsizex - 2 && gidy < gsizey - 2) {
          const unsigned int rightDownRightDownIndex = centerIndex + 2 * gsizex + 2;
          float3 rightDownRightDown = vload3(rightDownRightDownIndex, positions);
          if (rightDownRightDown.z > 0.0f && fabs(center.z - rightDownRightDown.z) < depthThreshold) {
            float3 rightDownRightDownNm = vload3(rightDownRightDownIndex, normals);
            float confidence = dot(rightDownRightDownNm, centerNm);
            if (confidence > dotThreshold) {
              accNm += 0.8f * confidence * rightDownRightDownNm;
            }
          }
        }
      }
    }
  }

  barrier(0x02);
  vstore3(accNm, centerIndex, normals);
}