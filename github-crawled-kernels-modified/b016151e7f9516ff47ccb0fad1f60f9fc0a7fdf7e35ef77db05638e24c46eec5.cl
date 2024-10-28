//{"glTexture":0,"texture":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float MINIMUM_INTERSECT_DISTANCE = 1e-7f;
constant float BIAS_OFFSET = 1e-3f;
void swap(float* a, float* b) {
  float temp = *a;
  *a = *b;
  *b = temp;
}

float3 reflect(float3 I, float3 N) {
  return I - 2.0f * dot(N, I) * N;
}

float3 refract(float3 I, float3 N, float eta) {
  float k = 1.0f - eta * eta * (1.0f - dot(N, I) * dot(N, I));
  if (k < 0.0f) {
    return (float3)(0, 0, 0);
  } else {
    return eta * I - (eta * dot(N, I) + sqrt(k)) * N;
  }
}

float3 getNormalFromSphere(float8 sphere, float3 position) {
  return normalize((float3)(position.x - sphere.lo.x, position.y - sphere.lo.y, position.z - sphere.lo.z));
}

float4 getColorFromPlane(float16 plane, float3 point) {
  float tileSize = plane.lo.lo.w;
  int xt = (int)round(point.x / tileSize);
  int yt = (int)round(point.z / tileSize);

  bool evenX = xt % 2 == 0;
  bool evenY = yt % 2 == 0;

  if (evenX && evenY) {
    return plane.hi.lo;
  } else if (!evenX && evenY) {
    return plane.hi.hi;
  } else if (evenX && !evenY) {
    return plane.hi.hi;

  } else if (!evenX && !evenY) {
    return plane.hi.lo;
  } else {
    return plane.hi.hi;
  }
}

float3 getNormalFromPlane(float8 plane) {
  return plane.hi.xyz;
}

bool hasInterceptedPlane(float8 plane, float3 ray, float3 origin, float3* touchPoint) {
  float3 n = plane.hi.xyz;
  float denom = dot(n, ray);
  if (denom > 1e-6f) {
    float3 position = plane.lo.xyz;
    float3 p0l0 = position - origin;
    float d = dot(p0l0, n) / denom;

    *touchPoint = origin + (ray)*d;

    return (d >= 0);
  }
  return false;
}

bool solveQuadratic(const float a, const float b, const float c, float* x0, float* x1) {
  float discr = b * b - 4 * a * c;
  if (discr < 0) {
    return false;
  } else if (discr == 0) {
    *x0 = *x1 = -0.5f * b / a;
  } else {
    float q = (b > 0) ? -0.5f * (b + sqrt(discr)) : -0.5f * (b - sqrt(discr));
    *x0 = q / a;
    *x1 = c / q;
  }
  if (*x0 > *x1) {
    swap(x0, x1);
  }

  return true;
}

bool hasInterceptedSphere(float8 sphere, float3 dir, float3 orig, float3* touchPoint) {
  float t0, t1, t;
  float3 center = sphere.lo.xyz;
  float radius2 = sphere.lo.w * sphere.lo.w;
  float3 L = orig - center;
  float a = dot(dir, dir);
  float b = 2 * dot(L, dir);
  float c = dot(L, L) - radius2;
  if (!solveQuadratic(a, b, c, &t0, &t1)) {
    return false;
  }

  if (t0 > t1) {
    swap(&t0, &t1);
  }

  if (t0 < 0) {
    t0 = t1;
    if (t0 < 0) {
      return false;
    }
  }

  t = t0;
  *touchPoint = orig + (dir * (float)t);
  return true;
}

float schlickApproximation(float n1, float n2, float3 incident, float3 normal) {
  float r0 = (n1 - n2) / (n1 + n2);
  r0 = r0 * r0;
  float cosI = -dot(normal, incident);
  float cosX = cosI;
  if (n1 > n2) {
    const float n = n1 / n2;
    const float sinT2 = n * n * (1.0f - cosI * cosI);
    if (sinT2 > 1.0f) {
      return 1.0f;
    }
    cosX = sqrt(1.0f - sinT2);
  }
  const float x = 1.0f - cosX;
  return r0 + (1.0f - r0) * x * x * x * x * x;
}

float4 phong(float3 viewDir, float3 position, float3 normal, float4 diffuseColor, float3 light, float4 lightColor) {
  float4 outColor = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float3 lightDir = normalize(light - position);
  float lightDistance = fast_distance(light, position);

  float k = 0.005f;
  float attenuation = 1.0f / (1.0f + k * lightDistance * lightDistance);

  float4 ambientColor = (float4)(0.1f, 0.1f, 0.1f, 0.1f) * lightColor * diffuseColor;
  float diff = max(0.0f, dot(normal, lightDir));

  float3 reflection = normalize(reflect(-lightDir, normal));

  float specular = max(0.0f, dot(reflection, normalize(viewDir)));

  specular = pow(specular, 50);

  outColor += ambientColor;
  outColor += (diffuseColor * diff + lightColor * specular) * attenuation;
  return outColor;
}

float4 traceRay(float3 eye, float3 ray, global const float* spheres, int numSpheres, global const float* planes, int numPlanes, global const float* lights, int numLights, local float* temp, local float* temp2, float3* newRay, float3* touchPos, int* lastSphereIdx, int* lastPlaneIdx) {
  float4 outColor = (float4)(0.0f, 0.0f, 0.0f, 1.0f);
  bool hasHit = false;
  float3 closestPoint;
  float3 normal;
  float minDist = 10e7f;
  float3 touchPoint;
  float4 objectColor;

  int sphereOffset = numSpheres % 2 == 0 ? (numSpheres / 2) : ((numSpheres + 1) / 2);

  int currentPlaneIdx = -1;
  for (int i = 0; i < numPlanes; i++) {
    if (isequal(length(ray), 0.0f)) {
      break;
    }

    float16 plane = vload16(i + sphereOffset, temp);
    if (hasInterceptedPlane(plane.lo, ray, eye, &touchPoint)) {
      float dist = fast_distance(touchPoint, eye);
      if (dist < minDist) {
        minDist = dist;
        closestPoint = touchPoint;

        float tileSize = plane.lo.lo.w;
        if (isnotequal(tileSize, 0.0f)) {
          objectColor = getColorFromPlane(plane, closestPoint);
        } else {
          objectColor = plane.hi.lo;
        }

        normal = getNormalFromPlane(plane.lo);
        hasHit = true;
        currentPlaneIdx = i;
      }
    }
  }
  if (!hasHit) {
    *lastPlaneIdx = -1;
  } else {
    *lastPlaneIdx = currentPlaneIdx;
  }

  bool hasHitSphere = false;
  int currentSphereIdx = -1;
  for (int i = 0; i < numSpheres; i++) {
    if (isequal(length(ray), 0.0f)) {
      break;
    }
    if ((*lastSphereIdx) == i) {
      continue;
    }
    float8 sphere = vload8(i, temp);

    if (hasInterceptedSphere(sphere, ray, eye, &touchPoint)) {
      float dist = fast_distance(touchPoint, eye);
      if (dist < minDist) {
        minDist = dist;
        closestPoint = touchPoint;
        objectColor = sphere.hi;
        normal = getNormalFromSphere(sphere, touchPoint);
        hasHit = true;
        currentSphereIdx = i;
        hasHitSphere = true;
      }
    }
  }
  if (!hasHitSphere) {
    *lastSphereIdx = -1;
  } else {
    *lastSphereIdx = currentSphereIdx;
    *lastPlaneIdx = -1;
  }

  if (hasHit) {
    if (isgreater(objectColor.w, 0.0f)) {
      float3 reflectionDir = reflect(ray, normal);
      *newRay = reflectionDir;
      *touchPos = closestPoint + reflectionDir * BIAS_OFFSET;
    } else if (isless(objectColor.w, 0.0f)) {
      float n1 = 1.0f;
      float n2 = -objectColor.w;

      float R = schlickApproximation(n1, n2, ray, normal);
      float T = 1.0f - R;

      if (R > T) {
        *newRay = reflect(ray, normal);
      } else {
        *newRay = refract(ray, normal, n1 / n2);
      }
      *touchPos = closestPoint + (*newRay) * BIAS_OFFSET;
    } else {
      *newRay = (float3)(0.0f);
      *touchPos = closestPoint;
    }

    for (int i = 0; i < numLights; i++) {
      float8 light = vload8(i, temp2);
      float3 lightPos = light.lo.xyz;
      float4 lightColor = light.hi;

      float3 lightDir = normalize(closestPoint - lightPos);
      bool isInShadow = false;

      for (int j = 0; j < numSpheres; j++) {
        float8 sphere = vload8(j, temp);
        float3 occludedPoint;

        if (j != *lastSphereIdx) {
          if (hasInterceptedSphere(sphere, lightDir, lightPos, &occludedPoint)) {
            if (fast_distance(occludedPoint, lightPos - lightDir * BIAS_OFFSET) < fast_distance(lightPos, closestPoint)) {
              isInShadow = true;
              break;
            }
          }
        }
      }

      if (!isInShadow) {
        float3 viewDir = eye - closestPoint;
        float4 phongColor = phong(viewDir, closestPoint, normal, objectColor, light.lo.xyz, lightColor);
        outColor += phongColor;
        outColor.w = objectColor.w;
      }
    }
  }

  return outColor;
}

kernel void drawToTextureKernel(write_only image2d_t glTexture, global float* texture) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int idx = x * get_global_size(1) + y;
  float4 float3 = vload4(idx, texture);
  write_imagef(glTexture, (int2)(x, y), float3);
}