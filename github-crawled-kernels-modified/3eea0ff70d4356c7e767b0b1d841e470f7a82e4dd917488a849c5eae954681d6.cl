//{"a":14,"cellLocations":2,"dx":9,"dy":10,"dz":11,"epsilon":12,"minX":6,"minY":7,"minZ":8,"numOfCells":13,"tetX":15,"tetY":16,"tetZ":17,"tetrahedralConnectivities":1,"vertexPositions":0,"xRes":3,"yRes":4,"zRes":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int Sign(double a, double epsilon) {
  return a < -epsilon ? -1 : a > epsilon;
}

inline double DeterminantThree(double* a) {
  return a[hook(14, 0)] * a[hook(14, 4)] * a[hook(14, 8)] + a[hook(14, 1)] * a[hook(14, 5)] * a[hook(14, 6)] + a[hook(14, 2)] * a[hook(14, 3)] * a[hook(14, 7)] - a[hook(14, 0)] * a[hook(14, 5)] * a[hook(14, 7)] - a[hook(14, 1)] * a[hook(14, 3)] * a[hook(14, 8)] - a[hook(14, 2)] * a[hook(14, 4)] * a[hook(14, 6)];
}

inline bool Inside(double X, double Y, double Z, double* tetX, double* tetY, double* tetZ, double epsilon) {
  X -= tetX[hook(15, 0)];
  Y -= tetY[hook(16, 0)];
  Z -= tetZ[hook(17, 0)];

  double det[9] = {tetX[hook(15, 1)] - tetX[hook(15, 0)], tetY[hook(16, 1)] - tetY[hook(16, 0)], tetZ[hook(17, 1)] - tetZ[hook(17, 0)], tetX[hook(15, 2)] - tetX[hook(15, 0)], tetY[hook(16, 2)] - tetY[hook(16, 0)], tetZ[hook(17, 2)] - tetZ[hook(17, 0)], tetX[hook(15, 3)] - tetX[hook(15, 0)], tetY[hook(16, 3)] - tetY[hook(16, 0)], tetZ[hook(17, 3)] - tetZ[hook(17, 0)]};

  double V = 1 / DeterminantThree(det);

  double z41 = tetZ[hook(17, 3)] - tetZ[hook(17, 0)];
  double y34 = tetY[hook(16, 2)] - tetY[hook(16, 3)];
  double z34 = tetZ[hook(17, 2)] - tetZ[hook(17, 3)];
  double y41 = tetY[hook(16, 3)] - tetY[hook(16, 0)];
  double a11 = (z41 * y34 - z34 * y41) * V;

  double x41 = tetX[hook(15, 3)] - tetX[hook(15, 0)];
  double x34 = tetX[hook(15, 2)] - tetX[hook(15, 3)];
  double a12 = (x41 * z34 - x34 * z41) * V;

  double a13 = (y41 * x34 - y34 * x41) * V;

  double coordinate1 = a11 * X + a12 * Y + a13 * Z;
  if (Sign(coordinate1, epsilon) < 0)
    return false;

  double y12 = tetY[hook(16, 0)] - tetY[hook(16, 1)];
  double z12 = tetZ[hook(17, 0)] - tetZ[hook(17, 1)];
  double a21 = (z41 * y12 - z12 * y41) * V;

  double x12 = tetX[hook(15, 0)] - tetX[hook(15, 1)];
  double a22 = (x41 * z12 - x12 * z41) * V;

  double a23 = (y41 * x12 - y12 * x41) * V;

  double coordinate2 = a21 * X + a22 * Y + a23 * Z;
  if (Sign(coordinate2, epsilon) < 0)
    return false;

  double z23 = tetZ[hook(17, 1)] - tetZ[hook(17, 2)];
  double y23 = tetY[hook(16, 1)] - tetY[hook(16, 2)];
  double a31 = (z23 * y12 - z12 * y23) * V;

  double x23 = tetX[hook(15, 1)] - tetX[hook(15, 2)];
  double a32 = (x23 * z12 - x12 * z23) * V;

  double a33 = (y23 * x12 - y12 * x23) * V;

  double coordinate3 = a31 * X + a32 * Y + a33 * Z;
  if (Sign(coordinate3, epsilon) < 0)
    return false;

  double coordinate0 = 1 - coordinate1 - coordinate2 - coordinate3;
  if (Sign(coordinate0, epsilon) < 0)
    return false;
  return true;
}

kernel void InitialCellLocation(global double* vertexPositions, global int* tetrahedralConnectivities, volatile global int* cellLocations, int xRes, int yRes, int zRes, double minX, double minY, double minZ, double dx, double dy, double dz, double epsilon, int numOfCells) {
  int globalID = get_global_id(0);
  int globalSize = get_global_size(0);

  if (globalID < numOfCells) {
    int point1 = tetrahedralConnectivities[hook(1, globalID << 2)];
    int float2 = tetrahedralConnectivities[hook(1, (globalID << 2) + 1)];
    int float3 = tetrahedralConnectivities[hook(1, (globalID << 2) + 2)];
    int float4 = tetrahedralConnectivities[hook(1, (globalID << 2) + 3)];

    double tetX[4], tetY[4], tetZ[4];

    tetX[hook(15, 0)] = vertexPositions[hook(0, point1 * 3)];
    tetY[hook(16, 0)] = vertexPositions[hook(0, point1 * 3 + 1)];
    tetZ[hook(17, 0)] = vertexPositions[hook(0, point1 * 3 + 2)];

    tetX[hook(15, 1)] = vertexPositions[hook(0, float2 * 3)];
    tetY[hook(16, 1)] = vertexPositions[hook(0, float2 * 3 + 1)];
    tetZ[hook(17, 1)] = vertexPositions[hook(0, float2 * 3 + 2)];

    tetX[hook(15, 2)] = vertexPositions[hook(0, float3 * 3)];
    tetY[hook(16, 2)] = vertexPositions[hook(0, float3 * 3 + 1)];
    tetZ[hook(17, 2)] = vertexPositions[hook(0, float3 * 3 + 2)];

    tetX[hook(15, 3)] = vertexPositions[hook(0, float4 * 3)];
    tetY[hook(16, 3)] = vertexPositions[hook(0, float4 * 3 + 1)];
    tetZ[hook(17, 3)] = vertexPositions[hook(0, float4 * 3 + 2)];

    double tetMinX = min(min(tetX[hook(15, 0)], tetX[hook(15, 1)]), min(tetX[hook(15, 2)], tetX[hook(15, 3)]));
    double tetMaxX = max(max(tetX[hook(15, 0)], tetX[hook(15, 1)]), max(tetX[hook(15, 2)], tetX[hook(15, 3)]));

    double tetMinY = min(min(tetY[hook(16, 0)], tetY[hook(16, 1)]), min(tetY[hook(16, 2)], tetY[hook(16, 3)]));
    double tetMaxY = max(max(tetY[hook(16, 0)], tetY[hook(16, 1)]), max(tetY[hook(16, 2)], tetY[hook(16, 3)]));

    double tetMinZ = min(min(tetZ[hook(17, 0)], tetZ[hook(17, 1)]), min(tetZ[hook(17, 2)], tetZ[hook(17, 3)]));
    double tetMaxZ = max(max(tetZ[hook(17, 0)], tetZ[hook(17, 1)]), max(tetZ[hook(17, 2)], tetZ[hook(17, 3)]));

    if (Sign(tetMaxX - minX, epsilon) < 0)
      return;
    if (Sign(tetMaxY - minY, epsilon) < 0)
      return;
    if (Sign(tetMaxZ - minZ, epsilon) < 0)
      return;

    double maxX = minX + dx * xRes;
    double maxY = minY + dy * yRes;
    double maxZ = minZ + dz * zRes;

    if (Sign(tetMinX - maxX, epsilon) > 0)
      return;
    if (Sign(tetMinY - maxY, epsilon) > 0)
      return;
    if (Sign(tetMinZ - maxZ, epsilon) > 0)
      return;

    int xStart = 0, yStart = 0, zStart = 0;
    if (tetMinX > minX)
      xStart = (int)((tetMinX - minX) / dx);
    if (tetMinY > minY)
      yStart = (int)((tetMinY - minY) / dy);
    if (tetMinZ > minZ)
      zStart = (int)((tetMinZ - minZ) / dz);

    int xFinish = xRes, yFinish = yRes, zFinish = zRes;
    if (tetMaxX < maxX)
      xFinish = min((int)((tetMaxX - minX) / dx) + 1, xRes);
    if (tetMaxY < maxY)
      yFinish = min((int)((tetMaxY - minY) / dy) + 1, yRes);
    if (tetMaxZ < maxZ)
      zFinish = min((int)((tetMaxZ - minZ) / dz) + 1, zRes);

    int numOfCandidates = (xFinish - xStart + 1) * (yFinish - yStart + 1) * (zFinish - zStart + 1);

    for (int i = 0; i < numOfCandidates; i++) {
      int zIdx = i % (zFinish - zStart + 1) + zStart;
      int temp = i / (zFinish - zStart + 1);
      int yIdx = temp % (yFinish - yStart + 1) + yStart;
      int xIdx = temp / (yFinish - yStart + 1) + xStart;
      double X = minX + dx * xIdx;
      double Y = minY + dy * yIdx;
      double Z = minZ + dz * zIdx;
      if (Inside(X, Y, Z, tetX, tetY, tetZ, epsilon)) {
        int index = (xIdx * (yRes + 1) + yIdx) * (zRes + 1) + zIdx;
        int oldValue = atomic_add(cellLocations + index, globalID + 1);
        if (oldValue != -1)
          atomic_add(cellLocations + index, -globalID - 1);
      }
    }
  }
}