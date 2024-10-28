//{"body_count":17,"body_count_per_group":18,"damping":15,"input_position_x":6,"input_position_y":7,"input_position_z":8,"input_velocity_x":9,"input_velocity_y":10,"input_velocity_z":11,"mass":12,"output_position":13,"output_position_x":0,"output_position_y":1,"output_position_z":2,"output_velocity_x":3,"output_velocity_y":4,"output_velocity_z":5,"softening":16,"start_index":19,"time_delta":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void IntegrateSystemVectorized(global float4* restrict output_position_x, global float4* restrict output_position_y, global float4* restrict output_position_z, global float4* restrict output_velocity_x, global float4* restrict output_velocity_y, global float4* restrict output_velocity_z, global float4* restrict input_position_x, global float4* restrict input_position_y, global float4* restrict input_position_z, global float4* restrict input_velocity_x, global float4* restrict input_velocity_y, global float4* restrict input_velocity_z, global float4* restrict mass, global float4* restrict output_position, float time_delta, float damping, float softening, int body_count, int body_count_per_group, int start_index) {
  int index = get_global_id(0);

  float softening_squared = softening * softening;
  float4 position_x, position_y, position_z, m;
  float4 current_x1, current_y1, current_z1, current_mass1;
  float4 current_x2, current_y2, current_z2, current_mass2;
  float4 velocity_x, velocity_y, velocity_z;
  float4 zero = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  int i, j, k, l;

  int inner_loop_count = (body_count >> 2);
  int outer_loop_count = (body_count_per_group >> 2);
  int start = index * outer_loop_count + (start_index >> 2);
  int offset = index * body_count_per_group + start_index;

  for (l = 0; l < outer_loop_count; l++) {
    k = l + start;

    position_x = input_position_x[hook(6, k)];
    position_y = input_position_y[hook(7, k)];
    position_z = input_position_z[hook(8, k)];
    m = mass[hook(12, k)];

    float4 final_ax = zero;
    float4 final_ay = zero;
    float4 final_az = zero;

    current_x1 = position_x.xxxx;
    current_y1 = position_y.xxxx;
    current_z1 = position_z.xxxx;
    current_mass1 = m.xxxx;

    current_x2 = position_x.yyyy;
    current_y2 = position_y.yyyy;
    current_z2 = position_z.yyyy;
    current_mass2 = m.yyyy;

    float4 acceleration_x1 = zero;
    float4 acceleration_y1 = zero;
    float4 acceleration_z1 = zero;

    float4 acceleration_x2 = zero;
    float4 acceleration_y2 = zero;
    float4 acceleration_z2 = zero;

    for (i = 0; i < inner_loop_count; i++) {
      float4 dx = input_position_x[hook(6, i)] - current_x1;
      float4 dy = input_position_y[hook(7, i)] - current_y1;
      float4 dz = input_position_z[hook(8, i)] - current_z1;

      float4 mi = mass[hook(12, i)];

      float4 distance_squared = dx * dx + dy * dy + dz * dz;
      distance_squared += softening_squared;

      float4 inverse_distance = native_rsqrt(distance_squared);
      float4 s = (mi * inverse_distance) * (inverse_distance * inverse_distance);

      acceleration_x1 += dx * s;
      acceleration_y1 += dy * s;
      acceleration_z1 += dz * s;

      dx = input_position_x[hook(6, i)] - current_x2;
      dy = input_position_y[hook(7, i)] - current_y2;
      dz = input_position_z[hook(8, i)] - current_z2;

      distance_squared = dx * dx + dy * dy + dz * dz;
      distance_squared += softening_squared;

      inverse_distance = native_rsqrt(distance_squared);

      s = (mi * inverse_distance) * (inverse_distance * inverse_distance);

      acceleration_x2 += dx * s;
      acceleration_y2 += dy * s;
      acceleration_z2 += dz * s;
    }

    final_ax.x = acceleration_x1.x + acceleration_x1.y + acceleration_x1.z + acceleration_x1.w;
    final_ay.x = acceleration_y1.x + acceleration_y1.y + acceleration_y1.z + acceleration_y1.w;
    final_az.x = acceleration_z1.x + acceleration_z1.y + acceleration_z1.z + acceleration_z1.w;

    final_ax.y = acceleration_x2.x + acceleration_x2.y + acceleration_x2.z + acceleration_x2.w;
    final_ay.y = acceleration_y2.x + acceleration_y2.y + acceleration_y2.z + acceleration_y2.w;
    final_az.y = acceleration_z2.x + acceleration_z2.y + acceleration_z2.z + acceleration_z2.w;

    current_x1 = position_x.zzzz;
    current_y1 = position_y.zzzz;
    current_z1 = position_z.zzzz;
    current_mass1 = m.zzzz;

    current_x2 = position_x.wwww;
    current_y2 = position_y.wwww;
    current_z2 = position_z.wwww;
    current_mass2 = m.wwww;

    acceleration_x1 = zero;
    acceleration_y1 = zero;
    acceleration_z1 = zero;

    acceleration_x2 = zero;
    acceleration_y2 = zero;
    acceleration_z2 = zero;

    for (i = 0; i < inner_loop_count; i++) {
      float4 dx = input_position_x[hook(6, i)] - current_x1;
      float4 dy = input_position_y[hook(7, i)] - current_y1;
      float4 dz = input_position_z[hook(8, i)] - current_z1;

      float4 mi = mass[hook(12, i)];

      float4 distance_squared = dx * dx + dy * dy + dz * dz;
      distance_squared += softening_squared;

      float4 inverse_distance = native_rsqrt(distance_squared);
      float4 s = (mi * inverse_distance) * (inverse_distance * inverse_distance);

      acceleration_x1 += dx * s;
      acceleration_y1 += dy * s;
      acceleration_z1 += dz * s;

      dx = input_position_x[hook(6, i)] - current_x2;
      dy = input_position_y[hook(7, i)] - current_y2;
      dz = input_position_z[hook(8, i)] - current_z2;

      distance_squared = dx * dx + dy * dy + dz * dz;
      distance_squared += softening_squared;

      inverse_distance = native_rsqrt(distance_squared);
      s = (mi * inverse_distance) * (inverse_distance * inverse_distance);

      acceleration_x2 += dx * s;
      acceleration_y2 += dy * s;
      acceleration_z2 += dz * s;
    }

    final_ax.z = acceleration_x1.x + acceleration_x1.y + acceleration_x1.z + acceleration_x1.w;
    final_ay.z = acceleration_y1.x + acceleration_y1.y + acceleration_y1.z + acceleration_y1.w;
    final_az.z = acceleration_z1.x + acceleration_z1.y + acceleration_z1.z + acceleration_z1.w;

    final_ax.w = acceleration_x2.x + acceleration_x2.y + acceleration_x2.z + acceleration_x2.w;
    final_ay.w = acceleration_y2.x + acceleration_y2.y + acceleration_y2.z + acceleration_y2.w;
    final_az.w = acceleration_z2.x + acceleration_z2.y + acceleration_z2.z + acceleration_z2.w;

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

    output_position[hook(13, 4 * l + 0 + offset)] = (float4)(position_x.x, position_y.x, position_z.x, m.x);
    output_position[hook(13, 4 * l + 1 + offset)] = (float4)(position_x.y, position_y.y, position_z.y, m.y);
    output_position[hook(13, 4 * l + 2 + offset)] = (float4)(position_x.z, position_y.z, position_z.z, m.z);
    output_position[hook(13, 4 * l + 3 + offset)] = (float4)(position_x.w, position_y.w, position_z.w, m.w);
  }
}