//{"MUSCLE_COUNT":12,"PARTICLE_COUNT":11,"acceleration":3,"closest_distances":18,"closest_indexes":19,"d_array":16,"elasticConnectionsData":10,"elasticityCoefficient":15,"gridCellIndex":17,"h":6,"mass":7,"muscle_activation_signal":13,"neighborMap":0,"numOfElasticP":9,"particleIndex":5,"particleIndexBack":4,"position":14,"simulationScale":8,"sortedPosition":1,"sortedVelocity":2}
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
    if (d_array[hook(16, i)] > max_d) {
      max_d = d_array[hook(16, i)];
      result = i;
    }
  }
  return result;
}

int searchForNeighbors_b(int searchCell_, global unsigned int* gridCellIndex, float4 position_, int myParticleId, global float4* sortedPosition, global float2* neighborMap, int* closest_indexes, float* closest_distances, int last_farthest, int* found_count) {
  int baseParticleId = gridCellIndex[hook(17, searchCell_)];
  int nextParticleId = gridCellIndex[hook(17, searchCell_ + 1)];
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
      if (_distanceSquared <= closest_distances[hook(18, farthest_neighbor)]) {
        closest_distances[hook(18, farthest_neighbor)] = _distanceSquared;
        closest_indexes[hook(19, farthest_neighbor)] = neighborParticleId;
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

kernel void pcisph_computeElasticForces(global float2* neighborMap, global float4* sortedPosition, global float4* sortedVelocity, global float4* acceleration, global unsigned int* particleIndexBack, global uint2* particleIndex, float h, float mass, float simulationScale, int numOfElasticP, global float4* elasticConnectionsData, int PARTICLE_COUNT, int MUSCLE_COUNT, global float* muscle_activation_signal, global float4* position, float elasticityCoefficient) {
  int index = get_global_id(0);

  if (index >= numOfElasticP) {
    return;
  }
  int nc = 0;
  float4 p_xyzw = position[hook(14, index)];
  int id = particleIndexBack[hook(4, index)];
  int idx = index * 32;
  float r_ij_equilibrium, r_ij, delta_r_ij, v_i_cm_length;
  float4 vect_r_ij;

  float check;
  float4 proj_v_i_cm_on_r_ij;
  int jd, id_sp, jd_sp;
  int i;
  int L_index_i, L_index_j;
  id_sp = particleIndex[hook(5, id)].y;
  do {
    if ((jd = (int)elasticConnectionsData[hook(10, idx + nc)].x) != -1) {
      jd = particleIndexBack[hook(4, jd)];
      jd_sp = particleIndex[hook(5, jd)].y;
      r_ij_equilibrium = elasticConnectionsData[hook(10, idx + nc)].y;
      vect_r_ij = (sortedPosition[hook(1, id)] - sortedPosition[hook(1, jd)]) * simulationScale;
      vect_r_ij.w = 0.0f;
      r_ij = sqrt(dot(vect_r_ij, vect_r_ij));
      delta_r_ij = r_ij - r_ij_equilibrium;
      if (r_ij != 0.f) {
        {
          if (((position[hook(14, id_sp)].w > 2.05f) && (position[hook(14, id_sp)].w < 2.25f)) && ((position[hook(14, jd_sp)].w > 2.05f) && (position[hook(14, jd_sp)].w < 2.25f))) {
            if ((position[hook(14, id_sp)].w > 2.05f) && (position[hook(14, id_sp)].w < 2.15f))
              L_index_i = (int)((position[hook(14, id_sp)].w - 2.1f) * 10000.f) - 100;
            else
              L_index_i = (int)((position[hook(14, id_sp)].w - 2.2f) * 10000.f) - 100;

            if ((position[hook(14, jd_sp)].w > 2.05f) && (position[hook(14, jd_sp)].w < 2.15f))
              L_index_j = (int)((position[hook(14, id_sp)].w - 2.1f) * 10000.f) - 100;
            else
              L_index_j = (int)((position[hook(14, id_sp)].w - 2.2f) * 10000.f) - 100;

            if ((L_index_i != L_index_j) && (L_index_i < -80) && (L_index_j < -80))
              acceleration[hook(3, id)] += -(vect_r_ij / r_ij) * delta_r_ij * elasticityCoefficient * 0.4f;
            else
              acceleration[hook(3, id)] += -(vect_r_ij / r_ij) * delta_r_ij * elasticityCoefficient;
          } else {
            acceleration[hook(3, id)] += -(vect_r_ij / r_ij) * delta_r_ij * elasticityCoefficient * 0.5f;
          }
        }

        for (i = 0; i < MUSCLE_COUNT; i++) {
          if ((int)(elasticConnectionsData[hook(10, idx + nc)].z) == (i + 1)) {
            if (muscle_activation_signal[hook(13, i)] > 0.f) {
              if ((L_index_i != L_index_j) && (((L_index_i < -80) && (L_index_j < -80)) || ((L_index_i > 80) && (L_index_j > 80))))
                acceleration[hook(3, id)] += -(vect_r_ij / r_ij) * muscle_activation_signal[hook(13, i)] * (900.0f) * 0.4f * 1.0e-13f / mass;
              else
                acceleration[hook(3, id)] += -(vect_r_ij / r_ij) * muscle_activation_signal[hook(13, i)] * (900.0f) * 1.0e-13f / mass;
            }
          }
        }
      }
    } else
      break;
  } while (++nc < 32);
  return;
}