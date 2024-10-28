//{"PARTICLE_COUNT":5,"closest_distances":9,"closest_indexes":10,"d_array":6,"delta":4,"gridCellIndex":7,"neighborMap":11,"particleIndex":12,"particleIndexBack":0,"position":13,"pressure":2,"rho":3,"rho0":1,"sortedPosition":8,"velocity":14}
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

void computeInteractionWithBoundaryParticles(int id, float r0, global float2* neighborMap, global unsigned int* particleIndexBack, global uint2* particleIndex, global float4* position, global float4* velocity, float4* pos_, bool tangVel, float4* vel, unsigned int PARTICLE_COUNT) {
  int idx = id * 32;
  int id_b;
  int id_b_source_particle, nc = 0;
  float4 n_c_i = (float4)(0.f, 0.f, 0.f, 0.f);
  float4 n_b;
  float w_c_ib, w_c_ib_sum = 0.f, w_c_ib_second_sum = 0.f;
  float4 delta_pos;
  float n_c_i_length, x_ib_dist;

  do {
    if ((id_b = neighborMap[hook(11, idx + nc)].x) != -1) {
      id_b_source_particle = particleIndex[hook(12, id_b)].y;
      if ((int)position[hook(13, id_b_source_particle)].w == 3) {
        x_ib_dist = ((*pos_).x - position[hook(13, id_b_source_particle)].x) * ((*pos_).x - position[hook(13, id_b_source_particle)].x);
        x_ib_dist += ((*pos_).y - position[hook(13, id_b_source_particle)].y) * ((*pos_).y - position[hook(13, id_b_source_particle)].y);
        x_ib_dist += ((*pos_).z - position[hook(13, id_b_source_particle)].z) * ((*pos_).z - position[hook(13, id_b_source_particle)].z);
        x_ib_dist = native_sqrt(x_ib_dist);
        w_c_ib = max(0.f, (r0 - x_ib_dist) / r0);
        n_b = velocity[hook(14, id_b_source_particle)];
        n_c_i += n_b * w_c_ib;
        w_c_ib_sum += w_c_ib;
        w_c_ib_second_sum += w_c_ib * (r0 - x_ib_dist);
      }
    }
  } while (++nc < 32);

  n_c_i_length = dot(n_c_i, n_c_i);
  if (n_c_i_length != 0) {
    n_c_i_length = sqrt(n_c_i_length);
    delta_pos = ((n_c_i / n_c_i_length) * w_c_ib_second_sum) / w_c_ib_sum;
    (*pos_).x += delta_pos.x;
    (*pos_).y += delta_pos.y;
    (*pos_).z += delta_pos.z;
    if (tangVel) {
      float eps = 0.99f;
      float vel_n_len = n_c_i.x * (*vel).x + n_c_i.y * (*vel).y + n_c_i.z * (*vel).z;
      if (vel_n_len < 0) {
        (*vel).x -= n_c_i.x * vel_n_len;
        (*vel).y -= n_c_i.y * vel_n_len;
        (*vel).z -= n_c_i.z * vel_n_len;
        (*vel) = (*vel) * eps;
      }
    }
  }
}

kernel void pcisph_correctPressure(global unsigned int* particleIndexBack, float rho0, global float* pressure, global float* rho, float delta, unsigned int PARTICLE_COUNT) {
  int id = get_global_id(0);
  if (id >= PARTICLE_COUNT)
    return;
  id = particleIndexBack[hook(0, id)];
  int idx = id * 32;
  int nc = 0;
  float rho_err;
  float p_corr;

  rho_err = rho[hook(3, PARTICLE_COUNT + id)] - rho0;
  p_corr = rho_err * delta;
  if (p_corr < 0.0f)
    p_corr = 0.0f;
  pressure[hook(2, id)] += p_corr;
}