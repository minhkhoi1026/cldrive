//{"PARTICLE_COUNT":3,"gridCellCount":1,"gridCellIndex":2,"particleIndex":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int cellId(int4 cellFactors_, unsigned int gridCellsX, unsigned int gridCellsY, unsigned int gridCellsZ) {
  int cellId_ = cellFactors_.x + cellFactors_.y * gridCellsX + cellFactors_.z * gridCellsX * gridCellsY;
  return cellId_;
}

int4 cellFactors(float4 position, float xmin, float ymin, float zmin, float hashGridCellSizeInv) {
  int4 result;
  result.x = (int)(position.x * hashGridCellSizeInv);
  result.y = (int)(position.y * hashGridCellSizeInv);
  result.z = (int)(position.z * hashGridCellSizeInv);
  return result;
}
kernel void indexx(global uint2* particleIndex, unsigned int gridCellCount, global unsigned int* gridCellIndex, unsigned int PARTICLE_COUNT) {
  int id = get_global_id(0);
  if (id > gridCellCount) {
    return;
  }
  if (id == gridCellCount) {
    gridCellIndex[hook(2, id)] = PARTICLE_COUNT;
    return;
  }
  if (id == 0) {
    gridCellIndex[hook(2, id)] = 0;
    return;
  }

  int low = 0;
  int high = PARTICLE_COUNT - 1;
  bool converged = false;
  int cellIndex = -1;
  while (!converged) {
    if (low > high) {
      converged = true;
      cellIndex = -1;
      continue;
    }
    int idx = ((high - low) >> 1) + low;
    uint2 sampleMinus1 = particleIndex[hook(0, idx - 1)];
    uint2 sample = particleIndex[hook(0, idx)];
    int sampleCellId = sample.x;
    bool isHigh = (sampleCellId > id);
    high = isHigh ? idx - 1 : high;
    bool isLow = (sampleCellId < id);
    low = isLow ? idx + 1 : low;
    bool isMiddle = !(isHigh || isLow);

    bool zeroCase = (idx == 0 && isMiddle);
    int sampleM1CellId = zeroCase ? -1 : sampleMinus1.x;
    converged = isMiddle && (zeroCase || sampleM1CellId < sampleCellId);
    cellIndex = converged ? idx : cellIndex;
    high = (isMiddle && !converged) ? idx - 1 : high;
  }
  gridCellIndex[hook(2, id)] = cellIndex;
}