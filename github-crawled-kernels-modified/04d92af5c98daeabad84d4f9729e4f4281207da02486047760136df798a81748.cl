//{"rasterParams":4,"resultLine":3,"scanLine1":0,"scanLine2":1,"scanLine3":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float calcFirstDer(float x11, float x21, float x31, float x12, float x22, float x32, float x13, float x23, float x33, float inputNodataValue, float outputNodataValue, float zFactor, float mCellSize) {
  int weight = 0;
  float sum = 0;

  if (x31 != inputNodataValue && x11 != inputNodataValue) {
    sum += (x31 - x11);
    weight += 2;
  } else if (x31 == inputNodataValue && x11 != inputNodataValue && x21 != inputNodataValue) {
    sum += (x21 - x11);
    weight += 1;
  } else if (x11 == inputNodataValue && x31 != inputNodataValue && x21 != inputNodataValue) {
    sum += (x31 - x21);
    weight += 1;
  }

  if (x32 != inputNodataValue && x12 != inputNodataValue) {
    sum += 2.0f * (x32 - x12);
    weight += 4;
  } else if (x32 == inputNodataValue && x12 != inputNodataValue && x22 != inputNodataValue) {
    sum += 2.0f * (x22 - x12);
    weight += 2;
  } else if (x12 == inputNodataValue && x32 != inputNodataValue && x22 != inputNodataValue) {
    sum += 2.0f * (x32 - x22);
    weight += 2;
  }

  if (x33 != inputNodataValue && x13 != inputNodataValue) {
    sum += (x33 - x13);
    weight += 2;
  } else if (x33 == inputNodataValue && x13 != inputNodataValue && x23 != inputNodataValue) {
    sum += (x23 - x13);
    weight += 1;
  } else if (x13 == inputNodataValue && x33 != inputNodataValue && x23 != inputNodataValue) {
    sum += (x33 - x23);
    weight += 1;
  }

  if (weight == 0) {
    return outputNodataValue;
  }

  return sum / (weight * mCellSize) * zFactor;
}

kernel void processNineCellWindow(global float* scanLine1, global float* scanLine2, global float* scanLine3, global uchar4* resultLine, global float* rasterParams

) {
  const int i = get_global_id(0);

  float derX = calcFirstDer(scanLine1[hook(0, i)], scanLine2[hook(1, i)], scanLine3[hook(2, i)], scanLine1[hook(0, i + 1)], scanLine2[hook(1, i + 1)], scanLine3[hook(2, i + 1)], scanLine1[hook(0, i + 2)], scanLine2[hook(1, i + 2)], scanLine3[hook(2, i + 2)], rasterParams[hook(4, 0)], rasterParams[hook(4, 1)], rasterParams[hook(4, 2)], rasterParams[hook(4, 3)]);

  float derY = calcFirstDer(scanLine1[hook(0, i + 2)], scanLine1[hook(0, i + 1)], scanLine1[hook(0, i)], scanLine2[hook(1, i + 2)], scanLine2[hook(1, i + 1)], scanLine2[hook(1, i)], scanLine3[hook(2, i + 2)], scanLine3[hook(2, i + 1)], scanLine3[hook(2, i)], rasterParams[hook(4, 0)], rasterParams[hook(4, 1)], rasterParams[hook(4, 2)], rasterParams[hook(4, 4)]);

  float res;
  if (derX == rasterParams[hook(4, 1)] || derY == rasterParams[hook(4, 1)]) {
    res = rasterParams[hook(4, 1)];
  } else {
    float slope = sqrt(derX * derX + derY * derY);
    slope = atan(slope);
    res = slope * 255;
  }

  resultLine[hook(3, i)] = (uchar4)(res, res, res, 255);
}