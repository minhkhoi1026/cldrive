//{"PARTICLE_COUNT":16,"acceleration":5,"closest_distances":20,"closest_indexes":21,"d_array":18,"gravity_x":11,"gravity_y":12,"gravity_z":13,"gridCellIndex":19,"hScaled":9,"mass":17,"mass_mult_divgradWviscosityCoefficient":8,"mu":10,"neighborMap":0,"particleIndex":15,"particleIndexBack":6,"position":14,"pressure":2,"rho":1,"sortedPosition":3,"sortedVelocity":4,"surfTensCoeff":7}
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
    if (d_array[hook(18, i)] > max_d) {
      max_d = d_array[hook(18, i)];
      result = i;
    }
  }
  return result;
}

int searchForNeighbors_b(int searchCell_, global unsigned int* gridCellIndex, float4 position_, int myParticleId, global float4* sortedPosition, global float2* neighborMap, int* closest_indexes, float* closest_distances, int last_farthest, int* found_count) {
  int baseParticleId = gridCellIndex[hook(19, searchCell_)];
  int nextParticleId = gridCellIndex[hook(19, searchCell_ + 1)];
  int particleCountThisCell = nextParticleId - baseParticleId;
  int i = 0;
  float _distanceSquared;
  int neighborParticleId;
  int farthest_neighbor = last_farthest;
  while (i < particleCountThisCell) {
    neighborParticleId = baseParticleId + i;
    if (myParticleId != neighborParticleId) {
      float4 d = position_ - sortedPosition[hook(3, neighborParticleId)];
      _distanceSquared = d.x * d.x + d.y * d.y + d.z * d.z;
      if (_distanceSquared <= closest_distances[hook(20, farthest_neighbor)]) {
        closest_distances[hook(20, farthest_neighbor)] = _distanceSquared;
        closest_indexes[hook(21, farthest_neighbor)] = neighborParticleId;
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

kernel void pcisph_computeForcesAndInitPressure(global float2* neighborMap, global float* rho, global float* pressure, global float4* sortedPosition, global float4* sortedVelocity, global float4* acceleration, global unsigned int* particleIndexBack, float surfTensCoeff, float mass_mult_divgradWviscosityCoefficient, float hScaled, float mu, float gravity_x, float gravity_y, float gravity_z, global float4* position, global uint2* particleIndex, unsigned int PARTICLE_COUNT, float mass

) {
  int id = get_global_id(0);
  if (id >= PARTICLE_COUNT)
    return;
  id = particleIndexBack[hook(6, id)];
  int id_source_particle = particleIndex[hook(15, id)].y;
  if ((int)(position[hook(14, id_source_particle)].w) == 3) {
    acceleration[hook(5, id)] = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
    acceleration[hook(5, PARTICLE_COUNT + id)] = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
    pressure[hook(2, id)] = 0.f;
    return;
  }
  int idx = id * 32;
  float hScaled2 = hScaled * hScaled;

  float4 acceleration_i;
  float2 nm;
  float r_ij, r_ij2;
  int nc = 0;
  int jd;
  float4 accel_viscosityForce = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float4 vi, vj;
  float rho_i, rho_j;
  float4 accel_surfTensForce = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float not_bp;
  int jd_source_particle;
  do {
    if ((jd = neighborMap[hook(0, idx + nc)].x) != -1) {
      r_ij = neighborMap[hook(0, idx + nc)].y;
      r_ij2 = r_ij * r_ij;
      if (r_ij < hScaled) {
        rho_i = rho[hook(1, id)];
        rho_j = rho[hook(1, jd)];
        vi = sortedVelocity[hook(4, id)];
        vj = sortedVelocity[hook(4, jd)];
        jd_source_particle = particleIndex[hook(15, jd)].y;
        not_bp = (float)((int)(position[hook(14, jd_source_particle)].w) != 3);

        if ((((position[hook(14, id_source_particle)].w > 2.05f) && (position[hook(14, id_source_particle)].w < 2.25f)) && ((position[hook(14, jd_source_particle)].w > 2.25f) && (position[hook(14, jd_source_particle)].w < 2.35f + 0.f))) || (((position[hook(14, id_source_particle)].w > 2.25f) && (position[hook(14, id_source_particle)].w < 2.35f)) && ((position[hook(14, jd_source_particle)].w > 2.05f) && (position[hook(14, jd_source_particle)].w < 2.25f)))) {
          accel_viscosityForce += 1.0e-5f * (sortedVelocity[hook(4, jd)] * not_bp - sortedVelocity[hook(4, id)]) * (hScaled - r_ij) / 1000;

          if (((position[hook(14, id_source_particle)].w > 2.25f) && (position[hook(14, id_source_particle)].w < 2.35f))) {
            position[hook(14, id_source_particle)].w = 2.32;
          }
        } else if ((((position[hook(14, id_source_particle)].w > 2.25f) && (position[hook(14, id_source_particle)].w < 2.35f)) && ((position[hook(14, jd_source_particle)].w > 2.25f) && (position[hook(14, jd_source_particle)].w < 2.35f)))) {
          accel_viscosityForce += 1.0e-4f * (sortedVelocity[hook(4, jd)] * not_bp - sortedVelocity[hook(4, id)]) * (hScaled - r_ij) / 1000;
        } else if ((((position[hook(14, id_source_particle)].w > 2.0f) && (position[hook(14, id_source_particle)].w < 2.25f)) && ((position[hook(14, jd_source_particle)].w > 2.0f) && (position[hook(14, jd_source_particle)].w < 2.25f)))) {
          accel_viscosityForce += 1.0e-4f * (sortedVelocity[hook(4, jd)] * not_bp - sortedVelocity[hook(4, id)]) * (hScaled - r_ij) / 1000;
        } else if ((((int)position[hook(14, id_source_particle)].w) == 1) || (((int)position[hook(14, jd_source_particle)].w) == 1)) {
          accel_viscosityForce += 1.0e-4f * (sortedVelocity[hook(4, jd)] * not_bp - sortedVelocity[hook(4, id)]) * (hScaled - r_ij) / 1000;

        } else {
          accel_viscosityForce += 1.0e-4f * (sortedVelocity[hook(4, jd)] * not_bp - sortedVelocity[hook(4, id)]) * (hScaled - r_ij) / 1000;
        }
        float surffKern = (hScaled2 - r_ij2) * (hScaled2 - r_ij2) * (hScaled2 - r_ij2);

        accel_surfTensForce += -1.7e-09f * surfTensCoeff * surffKern * (sortedPosition[hook(3, id)] - sortedPosition[hook(3, jd)]);
      }
    }
  } while (++nc < 32);
  accel_surfTensForce.w = 0.f;
  accel_surfTensForce /= mass;

  accel_viscosityForce *= 1.5f * mass_mult_divgradWviscosityCoefficient / rho[hook(1, id)];
  accel_viscosityForce *= 50.f;

  acceleration_i = accel_viscosityForce;
  acceleration_i += (float4)(gravity_x, gravity_y, gravity_z, 0.0f);
  acceleration_i += accel_surfTensForce;
  acceleration[hook(5, id)] = acceleration_i;

  acceleration[hook(5, PARTICLE_COUNT + id)] = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  pressure[hook(2, id)] = 0.f;
}