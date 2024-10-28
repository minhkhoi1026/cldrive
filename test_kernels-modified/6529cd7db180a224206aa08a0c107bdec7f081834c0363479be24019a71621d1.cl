//{"N":1,"diameters":6,"grid_dimensions":3,"num_boxes_axis":5,"num_boxes_axis_":4,"positions":2,"result":0,"successors":7}
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
  const double dx = positions[hook(2, 3 * idx + 0)] - positions[hook(2, 3 * nidx + 0)];
  const double dy = positions[hook(2, 3 * idx + 1)] - positions[hook(2, 3 * nidx + 1)];
  const double dz = positions[hook(2, 3 * idx + 2)] - positions[hook(2, 3 * nidx + 2)];
  return (dx * dx + dy * dy + dz * dz);
}

int3 get_box_coordinates(double3 pos, constant int* grid_dimensions, unsigned int box_length) {
  int3 box_coords;
  box_coords.x = (floor(pos.x) - grid_dimensions[hook(3, 0)]) / box_length;
  box_coords.y = (floor(pos.y) - grid_dimensions[hook(3, 1)]) / box_length;
  box_coords.z = (floor(pos.z) - grid_dimensions[hook(3, 2)]) / box_length;
  return box_coords;
}

int3 get_box_coordinates_2(unsigned int box_idx, constant unsigned int* num_boxes_axis_) {
  int3 box_coord;
  box_coord.z = box_idx / (num_boxes_axis_[hook(4, 0)] * num_boxes_axis_[hook(4, 1)]);
  unsigned int remainder = box_idx % (num_boxes_axis_[hook(4, 0)] * num_boxes_axis_[hook(4, 1)]);
  box_coord.y = remainder / num_boxes_axis_[hook(4, 0)];
  box_coord.x = remainder % num_boxes_axis_[hook(4, 0)];
  return box_coord;
}

unsigned int get_box_id_2(int3 bc, constant unsigned int* num_boxes_axis) {
  return bc.z * num_boxes_axis[hook(5, 0)] * num_boxes_axis[hook(5, 1)] + bc.y * num_boxes_axis[hook(5, 0)] + bc.x;
}

unsigned int get_box_id(double3 pos, constant unsigned int* num_boxes_axis, constant int* grid_dimensions, unsigned int box_length) {
  int3 box_coords = get_box_coordinates(pos, grid_dimensions, box_length);
  return get_box_id_2(box_coords, num_boxes_axis);
}

void compute_force(global double* positions, global double* diameters, unsigned int idx, unsigned int nidx, double3* collision_force) {
  double r1 = 0.5 * diameters[hook(6, idx)];
  double r2 = 0.5 * diameters[hook(6, nidx)];

  double additional_radius = 10.0 * 0.15;
  r1 += additional_radius;
  r2 += additional_radius;

  double comp1 = positions[hook(2, 3 * idx + 0)] - positions[hook(2, 3 * nidx + 0)];
  double comp2 = positions[hook(2, 3 * idx + 1)] - positions[hook(2, 3 * nidx + 1)];
  double comp3 = positions[hook(2, 3 * idx + 2)] - positions[hook(2, 3 * nidx + 2)];
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

    nidx = successors[hook(7, nidx)];
  }
}

kernel void clear_force_opencl(global double* result, unsigned int N) {
  unsigned int tidx = get_global_id(0);
  if (tidx < N * N * N) {
    result[hook(0, 3 * tidx + 0)] = 0;
    result[hook(0, 3 * tidx + 1)] = 0;
    result[hook(0, 3 * tidx + 2)] = 0;
  }
}