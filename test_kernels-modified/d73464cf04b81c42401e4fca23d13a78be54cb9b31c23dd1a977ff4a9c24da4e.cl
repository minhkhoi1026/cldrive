//{"body_count":7,"damping":5,"end_index":9,"input_position":2,"input_velocity":3,"output_position":0,"output_velocity":1,"shared_position":10,"softening":6,"start_index":8,"time_delta":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 ComputeForce(float4 force, float4 position_a, float4 position_b, float softening_squared) {
  float4 r;
  r.x = position_a.x - position_b.x;
  r.y = position_a.y - position_b.y;
  r.z = position_a.z - position_b.z;
  r.w = 1.0f;

  float distance_squared = mad(r.x, r.x, mad(r.y, r.y, r.z * r.z));

  distance_squared += softening_squared;

  float inverse_distance = native_rsqrt(distance_squared);
  float inverse_distance_cubed = inverse_distance * inverse_distance * inverse_distance;
  float s = position_a.w * inverse_distance_cubed;

  force.x += r.x * s;
  force.y += r.y * s;
  force.z += r.z * s;

  return force;
}

kernel void IntegrateSystem(global float4* restrict output_position, global float4* restrict output_velocity, global float4* restrict input_position, global float4* restrict input_velocity, const float time_delta, const float damping, const float softening, const int body_count, const int start_index, const int end_index, local float4* shared_position) {
  int index = get_global_id(0);
  int local_id = get_local_id(0);
  int tile_size = get_local_size(0);

  int tile = 0;

  index += start_index;

  float4 position = input_position[hook(2, index)];
  float softening_squared = softening * softening;

  float4 force = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  int i, j;

  for (i = 0; i < body_count; i += tile_size, tile++) {
    size_t local_index = (tile * tile_size + local_id);
    float4 local_position = input_position[hook(2, local_index)];

    shared_position[hook(10, local_id)] = local_position;

    barrier(0x01);

    for (j = 0; j < tile_size;) {
      force = ComputeForce(force, shared_position[hook(10, j++)], position, softening_squared);
      force = ComputeForce(force, shared_position[hook(10, j++)], position, softening_squared);
      force = ComputeForce(force, shared_position[hook(10, j++)], position, softening_squared);
      force = ComputeForce(force, shared_position[hook(10, j++)], position, softening_squared);
      force = ComputeForce(force, shared_position[hook(10, j++)], position, softening_squared);
      force = ComputeForce(force, shared_position[hook(10, j++)], position, softening_squared);
      force = ComputeForce(force, shared_position[hook(10, j++)], position, softening_squared);
      force = ComputeForce(force, shared_position[hook(10, j++)], position, softening_squared);
    }
    barrier(0x01);
  }

  float4 velocity = input_velocity[hook(3, index)];

  velocity.x += force.x * time_delta;
  velocity.y += force.y * time_delta;
  velocity.z += force.z * time_delta;
  velocity.x *= damping;
  velocity.y *= damping;
  velocity.z *= damping;
  position.x += velocity.x * time_delta;
  position.y += velocity.y * time_delta;
  position.z += velocity.z * time_delta;

  output_position[hook(0, index)] = position;
  output_velocity[hook(1, index)] = velocity;
}