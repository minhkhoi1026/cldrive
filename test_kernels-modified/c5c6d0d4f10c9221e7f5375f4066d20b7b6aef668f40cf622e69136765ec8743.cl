//{"N":9,"adherence":3,"box_id":4,"box_length":13,"diameters":1,"grid_dimensions":15,"lengths":11,"mass":5,"max_displacement":7,"num_boxes_axis":14,"num_boxes_axis_":17,"positions":0,"result":16,"squared_radius":8,"starts":10,"successors":12,"timestep":6,"tractor_force":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
double norm(double3);
double squared_euclidian_distance(global double*, unsigned int, unsigned int);
int3 get_box_coordinates(double3, constant int*, unsigned int);
int3 get_box_coordinates_2(unsigned int, constant unsigned int*);
unsigned int get_box_id_2(int3, constant unsigned int*);
unsigned int get_box_id(double3, constant unsigned int*, constant int*, unsigned int);
void compute_force(global double*, global double*, unsigned int, unsigned int, double3*);
void default_force(global double*, global double*, unsigned int, unsigned int, ushort, global unsigned int*, double, double3*);
double norm(double3 v) {
  return sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
}

double squared_euclidian_distance(global double* positions, unsigned int idx, unsigned int nidx) {
  const double dx = positions[hook(0, 3 * idx + 0)] - positions[hook(0, 3 * nidx + 0)];
  const double dy = positions[hook(0, 3 * idx + 1)] - positions[hook(0, 3 * nidx + 1)];
  const double dz = positions[hook(0, 3 * idx + 2)] - positions[hook(0, 3 * nidx + 2)];
  return (dx * dx + dy * dy + dz * dz);
}

int3 get_box_coordinates(double3 pos, constant int* grid_dimensions, unsigned int box_length) {
  int3 box_coords;
  box_coords.x = (floor(pos.x) - grid_dimensions[hook(15, 0)]) / box_length;
  box_coords.y = (floor(pos.y) - grid_dimensions[hook(15, 1)]) / box_length;
  box_coords.z = (floor(pos.z) - grid_dimensions[hook(15, 2)]) / box_length;
  return box_coords;
}

int3 get_box_coordinates_2(unsigned int box_idx, constant unsigned int* num_boxes_axis_) {
  int3 box_coord;
  box_coord.z = box_idx / (num_boxes_axis_[hook(17, 0)] * num_boxes_axis_[hook(17, 1)]);
  unsigned int remainder = box_idx % (num_boxes_axis_[hook(17, 0)] * num_boxes_axis_[hook(17, 1)]);
  box_coord.y = remainder / num_boxes_axis_[hook(17, 0)];
  box_coord.x = remainder % num_boxes_axis_[hook(17, 0)];
  return box_coord;
}

unsigned int get_box_id_2(int3 bc, constant unsigned int* num_boxes_axis) {
  return bc.z * num_boxes_axis[hook(14, 0)] * num_boxes_axis[hook(14, 1)] + bc.y * num_boxes_axis[hook(14, 0)] + bc.x;
}

unsigned int get_box_id(double3 pos, constant unsigned int* num_boxes_axis, constant int* grid_dimensions, unsigned int box_length) {
  int3 box_coords = get_box_coordinates(pos, grid_dimensions, box_length);
  return get_box_id_2(box_coords, num_boxes_axis);
}

void compute_force(global double* positions, global double* diameters, unsigned int idx, unsigned int nidx, double3* collision_force) {
  double r1 = 0.5 * diameters[hook(1, idx)];
  double r2 = 0.5 * diameters[hook(1, nidx)];

  double additional_radius = 10.0 * 0.15;
  r1 += additional_radius;
  r2 += additional_radius;

  double comp1 = positions[hook(0, 3 * idx + 0)] - positions[hook(0, 3 * nidx + 0)];
  double comp2 = positions[hook(0, 3 * idx + 1)] - positions[hook(0, 3 * nidx + 1)];
  double comp3 = positions[hook(0, 3 * idx + 2)] - positions[hook(0, 3 * nidx + 2)];
  double center_distance = sqrt(comp1 * comp1 + comp2 * comp2 + comp3 * comp3);

  double delta = r1 + r2 - center_distance;

  if (delta < 0) {
    return;
  }

  if (center_distance < 0.00000001) {
    collision_force->x += 42.0;
    collision_force->y += 42.0;
    collision_force->z += 42.0;
    return;
  }

  double r = (r1 * r2) / (r1 + r2);
  double gamma = 1;
  double k = 2;
  double f = k * delta - gamma * sqrt(r * delta);

  double module = f / center_distance;
  collision_force->x += module * comp1;
  collision_force->y += module * comp2;
  collision_force->z += module * comp3;
}

void default_force(global double* positions, global double* diameters, unsigned int idx, unsigned int start, ushort length, global unsigned int* successors, double squared_radius, double3* collision_force) {
  unsigned int nidx = start;

  for (ushort nb = 0; nb < length; nb++) {
    if (nidx != idx) {
      if (squared_euclidian_distance(positions, idx, nidx) < squared_radius) {
        compute_force(positions, diameters, idx, nidx, collision_force);
      }
    }

    nidx = successors[hook(12, nidx)];
  }
}

kernel void collide(global double* positions, global double* diameters, global double* tractor_force, global double* adherence, global unsigned int* box_id, global double* mass, double timestep, double max_displacement, double squared_radius, unsigned int N, global unsigned int* starts, global ushort* lengths, global unsigned int* successors, unsigned int box_length, constant unsigned int* num_boxes_axis, constant int* grid_dimensions, global double* result) {
  unsigned int tidx = get_global_id(0);
  if (tidx < N) {
    result[hook(16, 3 * tidx + 0)] = timestep * tractor_force[hook(2, 3 * tidx + 0)];
    result[hook(16, 3 * tidx + 1)] = timestep * tractor_force[hook(2, 3 * tidx + 1)];
    result[hook(16, 3 * tidx + 2)] = timestep * tractor_force[hook(2, 3 * tidx + 2)];

    double3 collision_force = (double3)(0, 0, 0);

    int3 box_coords = get_box_coordinates_2(box_id[hook(4, tidx)], num_boxes_axis);
    for (int z = -1; z <= 1; z++) {
      for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
          unsigned int bidx = get_box_id_2(box_coords + (int3)(x, y, z), num_boxes_axis);
          if (lengths[hook(11, bidx)] != 0) {
            default_force(positions, diameters, tidx, starts[hook(10, bidx)], lengths[hook(11, bidx)], successors, squared_radius, &collision_force);
          }
        }
      }
    }

    double mh = timestep / mass[hook(5, tidx)];

    if (norm(collision_force) > adherence[hook(3, tidx)]) {
      result[hook(16, 3 * tidx + 0)] += collision_force.x * mh;
      result[hook(16, 3 * tidx + 1)] += collision_force.y * mh;
      result[hook(16, 3 * tidx + 2)] += collision_force.z * mh;

      if (norm(collision_force) * mh > max_displacement) {
        result[hook(16, 3 * tidx + 0)] = max_displacement;
        result[hook(16, 3 * tidx + 1)] = max_displacement;
        result[hook(16, 3 * tidx + 2)] = max_displacement;
      }
    }
  }
}