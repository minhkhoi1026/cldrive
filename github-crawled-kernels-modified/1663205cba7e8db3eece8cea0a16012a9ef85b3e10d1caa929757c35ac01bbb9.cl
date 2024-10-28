//{"PARTICLE_COUNT":14,"closest_distances":17,"closest_indexes":18,"d_array":15,"gridCellCount":2,"gridCellIndex":16,"gridCellIndexFixedUp":0,"gridCellsX":3,"gridCellsY":4,"gridCellsZ":5,"h":6,"hashGridCellSize":7,"hashGridCellSizeInv":8,"neighborMap":13,"searchCells":19,"simulationScale":9,"sortedPosition":1,"xmin":10,"ymin":11,"zmin":12}
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
int getMaxIndex(float* d_array) {
  int result;
  float max_d = -1.f;
  for (int i = 0; i < 32; i++) {
    if (d_array[hook(15, i)] > max_d) {
      max_d = d_array[hook(15, i)];
      result = i;
    }
  }
  return result;
}

int searchForNeighbors_b(int searchCell_, global unsigned int* gridCellIndex, float4 position_, int myParticleId, global float4* sortedPosition, global float2* neighborMap, int* closest_indexes, float* closest_distances, int last_farthest, int* found_count) {
  int baseParticleId = gridCellIndex[hook(16, searchCell_)];
  int nextParticleId = gridCellIndex[hook(16, searchCell_ + 1)];
  int particleCountThisCell = nextParticleId - baseParticleId;
  int i = 0;
  float _distanceSquared;
  int neighborParticleId;
  int farthest_neighbor = last_farthest;
  while (i < particleCountThisCell) {
    neighborParticleId = baseParticleId + i;
    if (myParticleId != neighborParticleId) {
      float4 d = position_ - sortedPosition[hook(1, neighborParticleId)];
      _distanceSquared = d.x * d.x + d.y * d.y + d.z * d.z;
      if (_distanceSquared <= closest_distances[hook(17, farthest_neighbor)]) {
        closest_distances[hook(17, farthest_neighbor)] = _distanceSquared;
        closest_indexes[hook(18, farthest_neighbor)] = neighborParticleId;
        if (*found_count < 32 - 1) {
          (*found_count)++;
          farthest_neighbor = *found_count;
        } else {
          farthest_neighbor = getMaxIndex(closest_distances);
        }
      }
    }
    i++;
  }
  return farthest_neighbor;
}

int searchCell(int cellId, int deltaX, int deltaY, int deltaZ, unsigned int gridCellsX, unsigned int gridCellsY, unsigned int gridCellsZ, unsigned int gridCellCount) {
  int dx = deltaX;
  int dy = deltaY * gridCellsX;
  int dz = deltaZ * gridCellsX * gridCellsY;
  int newCellId = cellId + dx + dy + dz;
  newCellId = newCellId < 0 ? newCellId + gridCellCount : newCellId;
  newCellId = newCellId >= gridCellCount ? newCellId - gridCellCount : newCellId;
  return newCellId;
}

kernel void findNeighbors(global unsigned int* gridCellIndexFixedUp, global float4* sortedPosition, unsigned int gridCellCount, unsigned int gridCellsX, unsigned int gridCellsY, unsigned int gridCellsZ, float h, float hashGridCellSize, float hashGridCellSizeInv, float simulationScale, float xmin, float ymin, float zmin, global float2* neighborMap, unsigned int PARTICLE_COUNT) {
  int id = get_global_id(0);
  if (id >= PARTICLE_COUNT)
    return;
  global unsigned int* gridCellIndex = gridCellIndexFixedUp;
  float4 position_ = sortedPosition[hook(1, id)];
  int myCellId = (int)position_.w & 0xffff;
  int searchCells[8];
  float r_thr2 = h * h;
  float closest_distances[32];
  int closest_indexes[32];
  int found_count = 0;
  for (int k = 0; k < 32; k++) {
    closest_distances[hook(17, k)] = r_thr2;
    closest_indexes[hook(18, k)] = -1;
  }

  searchCells[hook(19, 0)] = myCellId;

  float4 p;
  float4 p0 = (float4)(xmin, ymin, zmin, 0.0f);
  p = position_ - p0;

  int4 cellFactors_ = cellFactors(position_, xmin, ymin, zmin, hashGridCellSizeInv);
  float4 cf;
  cf.x = cellFactors_.x * hashGridCellSize;
  cf.y = cellFactors_.y * hashGridCellSize;
  cf.z = cellFactors_.z * hashGridCellSize;

  int4 lo;
  lo = ((p - cf) < h);

  int4 delta;
  int4 one = (int4)(1, 1, 1, 1);
  delta = one + 2 * lo;

  searchCells[hook(19, 1)] = searchCell(myCellId, delta.x, 0, 0, gridCellsX, gridCellsY, gridCellsZ, gridCellCount);
  searchCells[hook(19, 2)] = searchCell(myCellId, 0, delta.y, 0, gridCellsX, gridCellsY, gridCellsZ, gridCellCount);
  searchCells[hook(19, 3)] = searchCell(myCellId, 0, 0, delta.z, gridCellsX, gridCellsY, gridCellsZ, gridCellCount);
  searchCells[hook(19, 4)] = searchCell(myCellId, delta.x, delta.y, 0, gridCellsX, gridCellsY, gridCellsZ, gridCellCount);
  searchCells[hook(19, 5)] = searchCell(myCellId, delta.x, 0, delta.z, gridCellsX, gridCellsY, gridCellsZ, gridCellCount);
  searchCells[hook(19, 6)] = searchCell(myCellId, 0, delta.y, delta.z, gridCellsX, gridCellsY, gridCellsZ, gridCellCount);
  searchCells[hook(19, 7)] = searchCell(myCellId, delta.x, delta.y, delta.z, gridCellsX, gridCellsY, gridCellsZ, gridCellCount);

  int last_farthest = 0;

  last_farthest = searchForNeighbors_b(searchCells[hook(19, 0)], gridCellIndex, position_, id, sortedPosition, neighborMap, closest_indexes, closest_distances, last_farthest, &found_count);

  last_farthest = searchForNeighbors_b(searchCells[hook(19, 1)], gridCellIndex, position_, id, sortedPosition, neighborMap, closest_indexes, closest_distances, last_farthest, &found_count);

  last_farthest = searchForNeighbors_b(searchCells[hook(19, 2)], gridCellIndex, position_, id, sortedPosition, neighborMap, closest_indexes, closest_distances, last_farthest, &found_count);

  last_farthest = searchForNeighbors_b(searchCells[hook(19, 3)], gridCellIndex, position_, id, sortedPosition, neighborMap, closest_indexes, closest_distances, last_farthest, &found_count);

  last_farthest = searchForNeighbors_b(searchCells[hook(19, 4)], gridCellIndex, position_, id, sortedPosition, neighborMap, closest_indexes, closest_distances, last_farthest, &found_count);

  last_farthest = searchForNeighbors_b(searchCells[hook(19, 5)], gridCellIndex, position_, id, sortedPosition, neighborMap, closest_indexes, closest_distances, last_farthest, &found_count);

  last_farthest = searchForNeighbors_b(searchCells[hook(19, 6)], gridCellIndex, position_, id, sortedPosition, neighborMap, closest_indexes, closest_distances, last_farthest, &found_count);

  last_farthest = searchForNeighbors_b(searchCells[hook(19, 7)], gridCellIndex, position_, id, sortedPosition, neighborMap, closest_indexes, closest_distances, last_farthest, &found_count);

  for (int j = 0; j < 32; j++) {
    float2 neighbor_data;
    neighbor_data.x = closest_indexes[hook(18, j)];
    if (closest_indexes[hook(18, j)] >= 0) {
      neighbor_data.y = native_sqrt(closest_distances[hook(17, j)]) * simulationScale;
    } else {
      neighbor_data.y = -1.f;
    }
    neighborMap[hook(13, id * 32 + j)] = neighbor_data;
  }
}