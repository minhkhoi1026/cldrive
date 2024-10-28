//{"depthThreshold":2,"normals":1,"positions":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
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