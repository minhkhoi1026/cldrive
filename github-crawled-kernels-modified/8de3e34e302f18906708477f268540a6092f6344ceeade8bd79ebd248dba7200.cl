//{"depthThreshold":2,"normals":1,"positions":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void smooth_normals_kernel(global float* positions, global float* normals, float depthThreshold) {
  unsigned int gidx = get_global_id(0);
  unsigned int gidy = get_global_id(1);
  unsigned int gsizex = get_global_size(0);
  unsigned int gsizey = get_global_size(1);
  const float dotThreshold = 0.3f;

  const unsigned int centerIndex = mul24(gidy, gsizex) + gidx;
  float3 center = vload3(centerIndex, positions);
  float3 centerNm = vload3(centerIndex, normals);
  if (center.z > 0.0f) {
    float3 leftNm = centerNm;
    if (gidx > 0) {
      float3 left = vload3(centerIndex - 1, positions);
      if (left.z > 0.0f && fabs(center.z - left.z) < depthThreshold) {
        leftNm = vload3(centerIndex - 1, normals);
        if (dot(leftNm, centerNm) < dotThreshold)
          leftNm = centerNm;
      }
    }
    float3 rightNm = centerNm;
    if (gidx < gsizex - 1) {
      float3 right = vload3(centerIndex + 1, positions);
      if (right.z > 0.0f && fabs(center.z - right.z) < depthThreshold) {
        rightNm = vload3(centerIndex + 1, normals);
        if (dot(rightNm, centerNm) < dotThreshold)
          rightNm = centerNm;
      }
    }
    float3 upNm = centerNm;
    if (gidy > 0) {
      float3 up = vload3(centerIndex - gsizex, positions);
      if (up.z > 0.0f && fabs(center.z - up.z) < depthThreshold) {
        upNm = vload3(centerIndex - gsizex, normals);
        if (dot(upNm, centerNm) < dotThreshold)
          upNm = centerNm;
      }
    }
    float3 downNm = centerNm;
    if (gidy < gsizey - 1) {
      float3 down = vload3(centerIndex + gsizex, positions);
      if (down.z > 0.0f && fabs(center.z - down.z) < depthThreshold) {
        downNm = vload3(centerIndex + gsizex, normals);
        if (dot(downNm, centerNm) < dotThreshold)
          downNm = centerNm;
      }
    }
    float3 leftUpNm = centerNm;
    if (gidx > 0 && gidy > 0) {
      float3 leftUp = vload3(centerIndex - gsizex - 1, positions);
      if (leftUp.z > 0.0f && fabs(center.z - leftUp.z) < depthThreshold) {
        leftUpNm = vload3(centerIndex - gsizex - 1, normals);
        if (dot(leftUpNm, centerNm) < dotThreshold)
          leftUpNm = centerNm;
      }
    }
    float3 leftDownNm = centerNm;
    if (gidx > 0 && gidy < gsizey - 1) {
      float3 leftDown = vload3(centerIndex + gsizex - 1, positions);
      if (leftDown.z > 0.0f && fabs(center.z - leftDown.z) < depthThreshold) {
        leftDownNm = vload3(centerIndex + gsizex - 1, normals);
        if (dot(leftDownNm, centerNm) < dotThreshold)
          leftDownNm = centerNm;
      }
    }
    float3 rightUpNm = centerNm;
    if (gidx < gsizex - 1 && gidy > 0) {
      float3 rightUp = vload3(centerIndex - gsizex + 1, positions);
      if (rightUp.z > 0.0f && fabs(center.z - rightUp.z) < depthThreshold) {
        rightUpNm = vload3(centerIndex - gsizex + 1, normals);
        if (dot(rightUpNm, centerNm) < dotThreshold)
          rightUpNm = centerNm;
      }
    }
    float3 rightDownNm = centerNm;
    if (gidx < gsizex - 1 && gidy < gsizey - 1) {
      float3 rightDown = vload3(centerIndex + gsizex + 1, positions);
      if (rightDown.z > 0.0f && fabs(center.z - rightDown.z) < depthThreshold) {
        rightDownNm = vload3(centerIndex + gsizex + 1, normals);
        if (dot(rightDownNm, centerNm) < dotThreshold)
          rightDownNm = centerNm;
      }
    }

    float3 norm = centerNm + 0.6f * leftNm + 0.6f * rightNm + 0.6f * upNm + 0.6f * downNm + 0.4f * leftUpNm + 0.4f * leftDownNm + 0.4f * rightUpNm + 0.4f * rightDownNm;
    vstore3(norm, centerIndex, normals);
  }
}