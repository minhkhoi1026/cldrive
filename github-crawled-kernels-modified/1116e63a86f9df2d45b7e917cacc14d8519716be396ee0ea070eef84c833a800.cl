//{"cityVertices":0,"cityVerticesCount":1,"hasShadow":9,"neighbours":2,"neighboursCount":3,"shadowBuildingsCount":6,"shadowTriangleNormals":7,"shadowVerticeCenters":4,"shadowVerticeCentersCount":5,"skymodel":11,"sunDirections":8,"workSize":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline char rayIntersectsTriangle(float3 p, float3 sunDirection, float3 v0, float3 v1, float3 v2) {
  float3 e1 = v1 - v0;
  float3 e2 = v2 - v0;

  float3 h = cross(sunDirection, e2);

  float a = dot(e1, h);

  if ((a > -0.00001f) && (a < 0.00001f)) {
    return 0;
  }

  float f = 1 / a;

  float3 s2 = p - v0;

  float u = f * dot(s2, h);

  if ((u < 0.0f) || (u > 1.0f)) {
    return 0;
  }

  float3 q = cross(s2, e1);

  float v = f * dot(sunDirection, q);
  if (!((v < 0.0f) || ((u + v) > 1.0f))) {
    float3 uv = v0 + e1 * u + e2 * v;
    float3 s = uv - p;

    if (dot(s, sunDirection) > 0.01f) {
      return 1;
    }
  }
  return 0;
}

kernel void calc(global const float* cityVertices, global const int* cityVerticesCount, global const int* neighbours, global const int* neighboursCount, global const float* shadowVerticeCenters, global const int* shadowVerticeCentersCount, const int shadowBuildingsCount, global const float* shadowTriangleNormals, global const float* sunDirections, global char* hasShadow, const int workSize, const int skymodel) {
  int gid = get_global_id(0);
  if (gid >= workSize) {
    return;
  }

  float3 v0, v1, v2, sunDirection, p;

  int gid3 = gid * 3;
  p = (float3)(shadowVerticeCenters[hook(4, gid3)], shadowVerticeCenters[hook(4, gid3 + 1)], shadowVerticeCenters[hook(4, gid3 + 2)]);
  int buildingIdx = 0;
  int buildingTriangle = gid;
  for (int i = 0; i < shadowBuildingsCount; ++i) {
    int tempBuildingTriangle = buildingTriangle - shadowVerticeCentersCount[hook(5, i)];
    if (tempBuildingTriangle < 0) {
      break;
    }
    buildingTriangle = tempBuildingTriangle;
    ++buildingIdx;
  }

  int neighbourOffset = 0;
  for (int i = 0; i < buildingIdx; ++i) {
    neighbourOffset += neighboursCount[hook(3, i)];
  }

  for (int i = 0; i < skymodel; i++) {
    sunDirection = (float3)(sunDirections[hook(8, i * 3)], sunDirections[hook(8, i * 3 + 1)], sunDirections[hook(8, i * 3 + 2)]);
    float3 n = (float3)(shadowTriangleNormals[hook(7, gid3)], shadowTriangleNormals[hook(7, gid3 + 1)], shadowTriangleNormals[hook(7, gid3 + 2)]);
    float l0 = fast_length(sunDirection);
    float l1 = fast_length(n);
    float c = dot(sunDirection, n) / (l0 * l1);
    if (c < 0) {
      hasShadow[hook(9, gid * (skymodel / 8) + i / 8)] |= (1 << (7 - i % 8));
      continue;
    }

    int breakInt = 0;
    for (int neighbourIdx = neighbourOffset; neighbourIdx < neighbourOffset + neighboursCount[hook(3, buildingIdx)]; ++neighbourIdx) {
      int offset = 0;
      for (int j = 0; j < neighbours[hook(2, neighbourIdx)]; ++j) {
        offset += cityVerticesCount[hook(1, j)];
      }

      for (int cityIdx = offset; cityIdx < offset + cityVerticesCount[hook(1, neighbours[nhook(2, neighbourIdx))]; cityIdx += 9) {
        v0 = (float3)(cityVertices[hook(0, cityIdx)], cityVertices[hook(0, cityIdx + 1)], cityVertices[hook(0, cityIdx + 2)]);
        v1 = (float3)(cityVertices[hook(0, cityIdx + 3)], cityVertices[hook(0, cityIdx + 4)], cityVertices[hook(0, cityIdx + 5)]);
        v2 = (float3)(cityVertices[hook(0, cityIdx + 6)], cityVertices[hook(0, cityIdx + 7)], cityVertices[hook(0, cityIdx + 8)]);
        char res = rayIntersectsTriangle(p, sunDirection, v0, v1, v2);
        if (res == 1) {
          hasShadow[hook(9, gid * (skymodel / 8) + i / 8)] |= (1 << (7 - i % 8));
          breakInt = 1;
          break;
        } else {
          int mask = 255 - (1 << (7 - i % 8));
          hasShadow[hook(9, gid * (skymodel / 8) + i / 8)] &= mask;
        }
      }

      if (breakInt == 1) {
        break;
      }
    }
  }
}