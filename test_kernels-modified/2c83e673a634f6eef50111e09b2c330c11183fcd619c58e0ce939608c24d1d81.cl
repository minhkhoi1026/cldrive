//{"dir_buffer":5,"gravity":3,"living_time":1,"particle_count":2,"pos_time_buffer":4,"time_passed":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sfrand_0_1(unsigned int* seed);
float sfrand_m1_1(unsigned int* seed);
float sfrand_0_1(unsigned int* seed) {
  float res;
  *seed = mul24(*seed, 16807u);
  *((unsigned int*)&res) = ((*seed) >> 9) | 0x3F800000;
  return (res - 1.0f);
}

float sfrand_m1_1(unsigned int* seed) {
  float res;
  *seed = mul24(*seed, 16807u);
  *((unsigned int*)&res) = ((*seed) >> 9) | 0x40000000;
  return (res - 3.0f);
}

kernel void particle_compute(const float time_passed, const float living_time, const unsigned int particle_count, const float4 gravity, global float4* pos_time_buffer, global float4* dir_buffer) {
  int particle_num = get_global_id(0);

  float4 pos_time = pos_time_buffer[hook(4, particle_num)];
  float4 dir_vel = dir_buffer[hook(5, particle_num)];

  float tpassed = time_passed;
  if (pos_time.w > 0.0f && pos_time.w <= living_time) {
    if (living_time - time_passed < pos_time.w)
      tpassed = living_time - pos_time.w;
    float time_step = tpassed / 1000.0f;
    float4 acceleration = gravity * time_step;
    dir_vel += acceleration;
    pos_time.xyz += dir_vel.xyz * time_step;
  }

  pos_time.w -= time_passed;

  pos_time_buffer[hook(4, particle_num)] = pos_time;
  dir_buffer[hook(5, particle_num)] = dir_vel;
}