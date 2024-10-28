//{"body_count":17,"body_count_per_group":18,"damping":15,"input_position_x":6,"input_position_y":7,"input_position_z":8,"input_velocity_x":9,"input_velocity_y":10,"input_velocity_z":11,"mass":12,"output_position":13,"output_position_x":0,"output_position_y":1,"output_position_z":2,"output_velocity_x":3,"output_velocity_y":4,"output_velocity_z":5,"softening":16,"start_index":19,"time_delta":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void IntegrateSystemNonVectorized(global float* restrict output_position_x, global float* restrict output_position_y, global float* restrict output_position_z, global float* restrict output_velocity_x, global float* restrict output_velocity_y, global float* restrict output_velocity_z, global float* restrict input_position_x, global float* restrict input_position_y, global float* restrict input_position_z, global float* restrict input_velocity_x, global float* restrict input_velocity_y, global float* restrict input_velocity_z, global float* restrict mass, global float4* restrict output_position, float time_delta, float damping, float softening, int body_count, int body_count_per_group, int start_index) {
  int index = get_global_id(0);

  float softening_squared = softening * softening;
  float position_x, position_y, position_z, m;
  float current_x1, current_y1, current_z1, current_mass1;
  float current_x2, current_y2, current_z2, current_mass2;
  float velocity_x, velocity_y, velocity_z;
  float zero = 0.0f;

  int i, j, k, l;

  int inner_loop_count = body_count;
  int outer_loop_count = body_count_per_group;
  int start = index * outer_loop_count + start_index;
  int offset = index * body_count_per_group + start_index;

  for (l = 0; l < outer_loop_count; l++) {
    k = l + start;

    position_x = input_position_x[hook(6, k)];
    position_y = input_position_y[hook(7, k)];
    position_z = input_position_z[hook(8, k)];
    m = mass[hook(12, k)];

    float final_ax = zero;
    float final_ay = zero;
    float final_az = zero;

    current_x1 = position_x;
    current_y1 = position_y;
    current_z1 = position_z;
    current_mass1 = m;

    float acceleration_x1 = zero;
    float acceleration_y1 = zero;
    float acceleration_z1 = zero;

    for (i = 0; i < inner_loop_count; i++) {
      float dx = input_position_x[hook(6, i)] - current_x1;
      float dy = input_position_y[hook(7, i)] - current_y1;
      float dz = input_position_z[hook(8, i)] - current_z1;

      float mi = mass[hook(12, i)];

      float distance_squared = dx * dx + dy * dy + dz * dz;
      distance_squared += softening_squared;

      float inverse_distance = native_rsqrt(distance_squared);
      float s = (mi * inverse_distance) * (inverse_distance * inverse_distance);

      acceleration_x1 += dx * s;
      acceleration_y1 += dy * s;
      acceleration_z1 += dz * s;
    }

    final_ax = acceleration_x1;
    final_ay = acceleration_y1;
    final_az = acceleration_z1;

    velocity_x = input_velocity_x[hook(9, k)];
    velocity_y = input_velocity_y[hook(10, k)];
    velocity_z = input_velocity_z[hook(11, k)];

    velocity_x += final_ax * time_delta;
    velocity_y += final_ay * time_delta;
    velocity_z += final_az * time_delta;

    velocity_x *= damping;
    velocity_y *= damping;
    velocity_z *= damping;

    position_x += velocity_x * time_delta;
    position_y += velocity_y * time_delta;
    position_z += velocity_z * time_delta;

    output_position_x[hook(0, k)] = position_x;
    output_position_y[hook(1, k)] = position_y;
    output_position_z[hook(2, k)] = position_z;

    output_velocity_x[hook(3, k)] = velocity_x;
    output_velocity_y[hook(4, k)] = velocity_y;
    output_velocity_z[hook(5, k)] = velocity_z;

    output_position[hook(13, l + offset)] = (float4)(position_x, position_y, position_z, m);
  }
}