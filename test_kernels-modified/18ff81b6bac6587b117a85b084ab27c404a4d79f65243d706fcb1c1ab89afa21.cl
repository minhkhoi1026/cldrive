//{"PARTICLE_COUNT":21,"acceleration":0,"closest_distances":26,"closest_indexes":27,"d_array":24,"gravity_x":5,"gravity_y":6,"gravity_z":7,"gridCellIndex":25,"iterationCount":22,"mode":23,"neighborMap":20,"particleIndex":3,"particleIndexBack":4,"position":16,"r0":19,"rho":18,"simulationScaleInv":8,"sortedPosition":1,"sortedVelocity":2,"timeStep":9,"velocity":17,"xmax":11,"xmin":10,"ymax":13,"ymin":12,"zmax":15,"zmin":14}
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
    if (d_array[hook(24, i)] > max_d) {
      max_d = d_array[hook(24, i)];
      result = i;
    }
  }
  return result;
}

int searchForNeighbors_b(int searchCell_, global unsigned int* gridCellIndex, float4 position_, int myParticleId, global float4* sortedPosition, global float2* neighborMap, int* closest_indexes, float* closest_distances, int last_farthest, int* found_count) {
  int baseParticleId = gridCellIndex[hook(25, searchCell_)];
  int nextParticleId = gridCellIndex[hook(25, searchCell_ + 1)];
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
      if (_distanceSquared <= closest_distances[hook(26, farthest_neighbor)]) {
        closest_distances[hook(26, farthest_neighbor)] = _distanceSquared;
        closest_indexes[hook(27, farthest_neighbor)] = neighborParticleId;
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
    if ((id_b = neighborMap[hook(20, idx + nc)].x) != -1) {
      id_b_source_particle = particleIndex[hook(3, id_b)].y;
      if ((int)position[hook(16, id_b_source_particle)].w == 3) {
        x_ib_dist = ((*pos_).x - position[hook(16, id_b_source_particle)].x) * ((*pos_).x - position[hook(16, id_b_source_particle)].x);
        x_ib_dist += ((*pos_).y - position[hook(16, id_b_source_particle)].y) * ((*pos_).y - position[hook(16, id_b_source_particle)].y);
        x_ib_dist += ((*pos_).z - position[hook(16, id_b_source_particle)].z) * ((*pos_).z - position[hook(16, id_b_source_particle)].z);
        x_ib_dist = native_sqrt(x_ib_dist);
        w_c_ib = max(0.f, (r0 - x_ib_dist) / r0);
        n_b = velocity[hook(17, id_b_source_particle)];
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

float calcDeterminant3x3(float4 c1, float4 c2, float4 c3) {
  return c1.x * c2.y * c3.z + c1.y * c2.z * c3.x + c1.z * c2.x * c3.y - c1.z * c2.y * c3.x - c1.x * c2.z * c3.y - c1.y * c2.x * c3.z;
}

float4 calculateProjectionOfPointToPlane(float4 ps, float4 pa, float4 pb, float4 pc) {
  float4 pm = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float denominator;

  float b_1 = pa.x * ((pb.y - pa.y) * (pc.z - pa.z) - (pb.z - pa.z) * (pc.y - pa.y)) + pa.y * ((pb.z - pa.z) * (pc.x - pa.x) - (pb.x - pa.x) * (pc.z - pa.z)) + pa.z * ((pb.x - pa.x) * (pc.y - pa.y) - (pb.y - pa.y) * (pc.x - pa.x));
  float b_2 = ps.x * (pb.x - pa.x) + ps.y * (pb.y - pa.y) + ps.z * (pb.z - pa.z);
  float b_3 = ps.x * (pc.x - pa.x) + ps.y * (pc.y - pa.y) + ps.z * (pc.z - pa.z);
  float a_1_1 = (pb.y - pa.y) * (pc.z - pa.z) - (pb.z - pa.z) * (pc.y - pa.y);
  float a_1_2 = pb.x - pa.x;
  float a_1_3 = pc.x - pa.x;
  float a_2_1 = (pb.z - pa.z) * (pc.x - pa.x) - (pb.x - pa.x) * (pc.z - pa.z);
  float a_2_2 = pb.y - pa.y;
  float a_2_3 = pc.y - pa.y;
  float a_3_1 = (pb.x - pa.x) * (pc.y - pa.y) - (pb.y - pa.y) * (pc.x - pa.x);
  float a_3_2 = pb.z - pa.z;
  float a_3_3 = pc.z - pa.z;
  float4 a_1 = (float4)(a_1_1, a_1_2, a_1_3, 0.0f);
  float4 a_2 = (float4)(a_2_1, a_2_2, a_2_3, 0.0f);
  float4 a_3 = (float4)(a_3_1, a_3_2, a_3_3, 0.0f);
  float4 b = (float4)(b_1, b_2, b_3, 0.0f);
  denominator = calcDeterminant3x3(a_1, a_2, a_3);
  if (denominator != 0.0f) {
    pm.x = calcDeterminant3x3(b, a_2, a_3) / denominator;
    pm.y = calcDeterminant3x3(a_1, b, a_3) / denominator;
    pm.z = calcDeterminant3x3(a_1, a_2, b) / denominator;
  } else {
    pm.w = -1;
  }
  return pm;
}
float calculateTriangleSquare(float4 v1, float4 v2, float4 v3) {
  float4 a = v2 - v1;
  float4 b = v3 - v1;

  float4 ab = (float4)(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x, 0.0f);
  return sqrt(ab.x * ab.x + ab.y * ab.y + ab.z * ab.z) / 2.f;
}

kernel void pcisph_integrate(global float4* acceleration, global float4* sortedPosition, global float4* sortedVelocity, global uint2* particleIndex, global unsigned int* particleIndexBack, float gravity_x, float gravity_y, float gravity_z, float simulationScaleInv, float timeStep, float xmin, float xmax, float ymin, float ymax, float zmin, float zmax, global float4* position, global float4* velocity, global float* rho, float r0, global float2* neighborMap, unsigned int PARTICLE_COUNT, int iterationCount, int mode) {
  int id = get_global_id(0);
  if (id >= PARTICLE_COUNT)
    return;
  id = particleIndexBack[hook(4, id)];
  int id_source_particle = particleIndex[hook(3, id)].y;
  if ((int)(position[hook(16, id_source_particle)].w) == 3) {
    return;
  }

  if (iterationCount == 0) {
    acceleration[hook(0, PARTICLE_COUNT * 2 + id_source_particle)] = acceleration[hook(0, id)] + acceleration[hook(0, PARTICLE_COUNT + id)];
    return;
  }
  float4 acceleration_t = acceleration[hook(0, PARTICLE_COUNT * 2 + id_source_particle)];
  acceleration_t.w = 0.f;
  float4 velocity_t = sortedVelocity[hook(2, id)];
  float particleType = position[hook(16, id_source_particle)].w;
  if (mode == 2) {
    float4 acceleration_t_dt = acceleration[hook(0, id)] + acceleration[hook(0, PARTICLE_COUNT + id)];
    acceleration_t_dt.w = 0.f;
    float4 position_t = sortedPosition[hook(1, id)];
    float4 velocity_t_dt = velocity_t + (acceleration_t_dt)*timeStep;
    float4 position_t_dt = position_t + (velocity_t_dt)*timeStep * simulationScaleInv;

    float particleType = position[hook(16, id_source_particle)].w;
    computeInteractionWithBoundaryParticles(id, r0, neighborMap, particleIndexBack, particleIndex, position, velocity, &position_t_dt, true, &velocity_t_dt, PARTICLE_COUNT);

    velocity[hook(17, id_source_particle)] = velocity_t_dt;
    position[hook(16, id_source_particle)] = position_t_dt;
    position[hook(16, id_source_particle)].w = particleType;

    acceleration[hook(0, PARTICLE_COUNT * 2 + id_source_particle)] = acceleration_t_dt;
    return;
  }
  if (mode == 0) {
    float4 position_t = sortedPosition[hook(1, id)];
    float4 position_t_dt = position_t + (velocity_t * timeStep + acceleration_t * timeStep * timeStep / 2.f) * simulationScaleInv;
    sortedPosition[hook(1, id)] = position_t_dt;
    sortedPosition[hook(1, id)].w = particleType;

  } else if (mode == 1) {
    float4 position_t_dt = sortedPosition[hook(1, id)];
    float4 acceleration_t_dt = acceleration[hook(0, id)] + acceleration[hook(0, PARTICLE_COUNT + id)];
    acceleration_t_dt.w = 0.f;
    float4 velocity_t_dt = velocity_t + (acceleration_t + acceleration_t_dt) * timeStep / 2.f;

    computeInteractionWithBoundaryParticles(id, r0, neighborMap, particleIndexBack, particleIndex, position, velocity, &position_t_dt, true, &velocity_t_dt, PARTICLE_COUNT);
    velocity[hook(17, id_source_particle)] = velocity_t_dt;
    acceleration[hook(0, PARTICLE_COUNT * 2 + id_source_particle)] = acceleration_t_dt;

    position[hook(16, id_source_particle)] = position_t_dt;
    position[hook(16, id_source_particle)].w = particleType;
  }
  return;
}