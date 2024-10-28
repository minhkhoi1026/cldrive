//{"PARTICLE_COUNT":5,"closest_distances":9,"closest_indexes":10,"d_array":6,"gridCellIndex":7,"hScaled2":2,"mass_mult_Wpoly6Coefficient":1,"neighborMap":0,"particleIndexBack":4,"rho":3,"sortedPosition":8}
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
    if (d_array[hook(6, i)] > max_d) {
      max_d = d_array[hook(6, i)];
      result = i;
    }
  }
  return result;
}

int searchForNeighbors_b(int searchCell_, global unsigned int* gridCellIndex, float4 position_, int myParticleId, global float4* sortedPosition, global float2* neighborMap, int* closest_indexes, float* closest_distances, int last_farthest, int* found_count) {
  int baseParticleId = gridCellIndex[hook(7, searchCell_)];
  int nextParticleId = gridCellIndex[hook(7, searchCell_ + 1)];
  int particleCountThisCell = nextParticleId - baseParticleId;
  int i = 0;
  float _distanceSquared;
  int neighborParticleId;
  int farthest_neighbor = last_farthest;
  while (i < particleCountThisCell) {
    neighborParticleId = baseParticleId + i;
    if (myParticleId != neighborParticleId) {
      float4 d = position_ - sortedPosition[hook(8, neighborParticleId)];
      _distanceSquared = d.x * d.x + d.y * d.y + d.z * d.z;
      if (_distanceSquared <= closest_distances[hook(9, farthest_neighbor)]) {
        closest_distances[hook(9, farthest_neighbor)] = _distanceSquared;
        closest_indexes[hook(10, farthest_neighbor)] = neighborParticleId;
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

kernel void pcisph_computeDensity(global float2* neighborMap, float mass_mult_Wpoly6Coefficient, float hScaled2, global float* rho, global unsigned int* particleIndexBack, unsigned int PARTICLE_COUNT) {
  int id = get_global_id(0);
  if (id >= PARTICLE_COUNT)
    return;
  id = particleIndexBack[hook(4, id)];
  int idx = id * 32;
  int nc = 0;
  float density = 0.0f;
  float r_ij2;
  float hScaled6 = hScaled2 * hScaled2 * hScaled2;
  int real_nc = 0;

  do {
    if (neighborMap[hook(0, idx + nc)].x != -1) {
      r_ij2 = neighborMap[hook(0, idx + nc)].y;
      r_ij2 *= r_ij2;
      if (r_ij2 < hScaled2) {
        density += (hScaled2 - r_ij2) * (hScaled2 - r_ij2) * (hScaled2 - r_ij2);

        real_nc++;
      }
    }

  } while (++nc < 32);
  if (density < hScaled6)
    density = hScaled6;
  density *= mass_mult_Wpoly6Coefficient;
  rho[hook(3, id)] = density;
}