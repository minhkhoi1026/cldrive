//{"accumulated_probabilities":1,"population_indexes":2,"population_size":3,"selection_probabilities":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float cross2d(float2 a, float2 b) {
  return a.x * b.y - a.y * b.x;
}

float dot2d(float2 a, float2 b) {
  return a.x * b.x + a.y * b.y;
}

float2 perp(float2 a) {
  return (float2)(-a.y, a.x);
}

float2 rotate2d(float orientation, float2 input) {
  float cs = cos(radians(orientation));
  float sn = sin(radians(orientation));
  return (float2)(input.x * cs - input.y * sn, input.x * sn + input.y * cs);
}

float2 vector_rejection(float2 point, float2 v1, float2 v2) {
  float2 b = v2 - v1;
  float2 a = point - v1;
  return a - (dot2d(a, b) / dot2d(b, b)) * b;
}

bool VertexBelowLine(float2 x0, float2 x1, float2 v1, float2* contact_point, float2* n, float* penetration_depth) {
  if (x0.x < x1.x) {
    if (x0.x <= v1.x && v1.x <= x1.x) {
      if ((v1.y < x0.y) && (v1.y < x1.y)) {
        return false;
      }

      float k = (v1.x - x0.x) / (x1.x - x0.x);
      float2 p = x0 + k * (x1 - x0);

      if (p.y < v1.y) {
        *penetration_depth = length(vector_rejection(v1, x0, x1));

        *n = normalize(perp(x1 - x0));
        *contact_point = p;
        return true;
      }
    }
  }
  return false;
}

bool VertexBelowLine2(float2 x0, float2 x1, float2 v1, float2* contact_point, float2* n, float* penetration_depth) {
  float2 line = normalize(x1 - x0);
  float2 v = v1 - x0;
  float k = dot2d(v, line);
  float t = cross2d(v, line);

  if (k >= 0 && k <= length(x1 - x0) && t < 0) {
    *contact_point = x0 + k * line;
    *n = perp(line);
    *penetration_depth = length(v1 - (k * line + x0));
    return true;
  }

  return false;
}

bool VertexTriangleIntersection2d(float2 p, float2 a, float2 b, float2 c, float2* contact_point, float2* n, float* penetration_depth) {
  float2 v0 = c - a;
  float2 v1 = b - a;
  float2 v2 = p - a;

  float dot00 = dot2d(v0, v0);
  float dot01 = dot2d(v0, v1);
  float dot02 = dot2d(v0, v2);
  float dot11 = dot2d(v1, v1);
  float dot12 = dot2d(v1, v2);

  float invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
  float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
  float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

  if ((u >= 0) && (v >= 0) && (u + v < 1)) {
    float2 ab = vector_rejection(p, b, a);
    float distance = length(ab);
    *n = -normalize(ab);

    float2 ac = vector_rejection(p, c, a);
    if (length(ac) < distance) {
      distance = length(ac);
      *n = -normalize(ac);
    }

    float2 bc = vector_rejection(p, c, b);
    if (length(bc) < distance) {
      distance = length(bc);
      *n = -normalize(bc);
    }

    *contact_point = p;
    *penetration_depth = distance;

    return true;
  }
  return false;
}

bool detect_collision(float2 x0, float2 x1, float2 v0, float2 v1, float2 v2, float2* contact_point, float2* n, float* penetration_depth) {
  float tentative_penetration_depth = 0x1.fffffep127f;

  if (true) {
    if (VertexTriangleIntersection2d(x0, v0, v1, v2, contact_point, n, &tentative_penetration_depth)) {
      if (tentative_penetration_depth > *penetration_depth) {
        *penetration_depth = tentative_penetration_depth;
      }
    }
  }

  if (true) {
    if (VertexBelowLine(x0, x1, v0, contact_point, n, &tentative_penetration_depth)) {
      if (tentative_penetration_depth > *penetration_depth) {
        *penetration_depth = tentative_penetration_depth;
      }
    }

    if (VertexBelowLine(x0, x1, v1, contact_point, n, &tentative_penetration_depth)) {
      if (tentative_penetration_depth > *penetration_depth) {
        *penetration_depth = tentative_penetration_depth;
      }
    }

    if (VertexBelowLine(x0, x1, v2, contact_point, n, &tentative_penetration_depth)) {
      if (tentative_penetration_depth > *penetration_depth) {
        *penetration_depth = tentative_penetration_depth;
      }
    }
  }

  if (*penetration_depth > 0)
    return true;

  return false;
}

bool CircleVertexIntersection2d(float2 x0, float2 center, float r, float2* contact_point, float2* n, float* penetration_depth) {
  if (length((x0 - center)) < r) {
    *contact_point = x0;
    *n = normalize(x0 - center);
    *penetration_depth = r - length((x0 - center));
    return true;
  }
  return false;
}

bool CircleSegmentIntersection2d(float2 x0, float2 x1, float2 center, float r, float2* contact_point, float2* n, float* penetration_depth) {
  float2 d = x1 - x0;
  float2 f = x0 - center;

  float a = dot2d(d, d);
  float b = 2 * dot2d(f, d);
  float c = dot2d(f, f) - r * r;

  float discriminant = b * b - 4 * a * c;

  if (discriminant < 0) {
    return false;
  } else {
    discriminant = sqrt(discriminant);

    float sol1 = (-b + discriminant) / (2 * a);
    float sol2 = (-b - discriminant) / (2 * a);

    float t0 = min(sol1, sol2);
    float t1 = max(sol1, sol2);

    *n = perp(normalize(d));

    if (0 <= t1 && t1 <= 1 && 0 <= t0 && t0 <= 1) {
      *contact_point = x0 + ((t0 + t1) / 2) * d;
      *penetration_depth = r - length(*contact_point - center);
      return true;
    }

    if (t1 < 0)
      return false;

    if ((0 > t0 && 0 > t1) || (t0 > 1 && t1 > 1))
      return false;

    if (t0 < 0 && t1 > 1) {
      *contact_point = x0;
      *penetration_depth = r;
      return true;
    }

    if (t0 < 0 && 0 <= t1 && t1 <= 1) {
      float2 middle = x0 + (t1 / 2.0f) * d;
      *contact_point = x0 + t1 * d;

      *penetration_depth = (r - length(vector_rejection(center, x0, x1)));
      return true;
    }

    if (t1 > 1 && 0 <= t0 && t0 <= 1) {
      *contact_point = x0 + t0 * d;
      *penetration_depth = (r - length(vector_rejection(center, x0, x1)));
      return true;
    }

    if (length(t0 - t1) < 0.005f) {
      return true;
    }
  }

  return false;
}

bool CircleSegmentIntersection2dsimple(float2 x0, float2 x1, float2 center, float r) {
  float2 contact_point = 0;
  float2 n = 0;
  float penetration_depth = 0;
  return CircleSegmentIntersection2d(x0, x1, center, r, &contact_point, &n, &penetration_depth);
}

kernel void roulette_wheel_selection(global float* selection_probabilities, global float* accumulated_probabilities, global unsigned int* population_indexes, unsigned int population_size) {
  int gid = get_global_id(0);
  float probability = selection_probabilities[hook(0, gid)];

  unsigned int low = 0;
  unsigned int high = population_size;
  unsigned int mid;

  while (low < high) {
    mid = (low + high) / 2;
    if (accumulated_probabilities[hook(1, mid)] < probability) {
      low = mid + 1;
    } else {
      high = mid;
    }
  }

  population_indexes[hook(2, gid)] = low;
}