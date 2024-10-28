//{"angle":4,"dir_buffer":11,"direction":6,"extents":5,"gravity":9,"living_time":1,"particle_count":2,"pos_time_buffer":10,"position_offset":7,"seed":8,"type":0,"velocity":3}
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
float2 sincos_f2(const float val);
float2 sincos_f2(const float val) {
  return (float2)(sin(val), cos(val));
}

void init_particles(float8* ret, unsigned int* kernel_seed, const unsigned int type, const float spawn_rate_ts, const float living_time, const unsigned int particle_count, const float velocity, const float4 angle, const float4 extents, const float4 direction, const float4 position_offset);
void init_particles(float8* ret, unsigned int* kernel_seed, const unsigned int type, const float spawn_rate_ts, const float living_time, const unsigned int particle_count, const float velocity, const float4 angle, const float4 extents, const float4 direction, const float4 position_offset) {
  int particle_num = get_global_id(0);
  float ltime = spawn_rate_ts;

  float4 position = (float4)0.0f;
  float4 dir;

  switch (type) {
    case 0: {
      float4 rand = (float4)(sfrand_m1_1(kernel_seed), sfrand_m1_1(kernel_seed), sfrand_m1_1(kernel_seed), 0.0f);
      position.xyz = 0.5f * rand.xyz * extents.xyz;
    } break;
    case 1: {
      float theta = 2.0f * 3.1415926535897932384626433832795f * sfrand_0_1(kernel_seed);
      float u = sfrand_m1_1(kernel_seed);

      position = (float4)(cos(theta) * u, sin(theta) * u, u, 0.0f);

      float scale = sfrand_m1_1(kernel_seed);
      position.xyz *= extents.x * scale;
    } break;
    case 2:
    default:
      position = (float4)(0.0f);
      break;
  }

  position += position_offset;

  if (spawn_rate_ts != 0.0f) {
    float particle_batch_ts = floor(particle_num / spawn_rate_ts);
    ltime = living_time + particle_batch_ts * 40.0f + ((particle_num / spawn_rate_ts) - particle_batch_ts) * 40.0f;
  }

  float4 rangle = (float4)(sfrand_m1_1(kernel_seed), sfrand_m1_1(kernel_seed), sfrand_m1_1(kernel_seed), 0.0f) * angle;
  float4 sina = sin(rangle);
  float4 cosa = cos(rangle);
  dir.x = dot((float4)(cosa.y * cosa.z + sina.x * sina.y * sina.z, -cosa.x * sina.z, sina.x * cosa.y * sina.z - sina.y * cosa.z, 0.0f), direction);
  dir.y = dot((float4)(cosa.y * sina.z - sina.x * sina.y * cosa.z, cosa.x * cosa.z, -sina.y * sina.z - sina.x * cosa.y * cosa.z, 0.0f), direction);
  dir.z = dot((float4)(cosa.x * sina.y, sina.x, cosa.x * cosa.y, 0.0f), direction);
  dir *= velocity;

  *ret = (float8)(position.x, position.y, position.z, ltime, dir.x, dir.y, dir.z, 0.0f);
}
kernel void particle_respawn

    (const unsigned int type, const float living_time, const unsigned int particle_count, const float velocity, const float4 angle, const float4 extents, const float4 direction, const float4 position_offset, const unsigned int seed,

     const float4 gravity,

     global float4* pos_time_buffer, global float4* dir_buffer) {
  unsigned int particle_num = get_global_id(0);

  unsigned int kernel_seed = seed ^ mul24(seed - particle_num, 16807u);

  float4 pos_time = pos_time_buffer[hook(10, particle_num)];

  float particle_time = pos_time.w;
  if (particle_time > 0.0f)
    return;

  float spawn_rate_ts = 0.0f;

  float8 ret;
  init_particles(&ret, &kernel_seed, type, spawn_rate_ts, living_time, particle_count, velocity, angle, extents, direction, position_offset);
  float4 position = ret.s0123;
  float4 dir = ret.s4567;

  float tpassed = -particle_time;
  float time_step = tpassed / 1000.0f;
  float4 acceleration = gravity * time_step;
  dir += acceleration;
  position += dir * time_step;

  particle_time += living_time;
  position = (float4)(position.x, position.y, position.z, particle_time);
  dir = (float4)(dir.x, dir.y, dir.z, 0.0f);

  pos_time_buffer[hook(10, particle_num)] = position;
  dir_buffer[hook(11, particle_num)] = dir;
}