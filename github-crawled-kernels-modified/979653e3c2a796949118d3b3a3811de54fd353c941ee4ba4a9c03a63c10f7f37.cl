//{"camera_pos":1,"dist_buffer":2,"pos_buffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float sfrand_0_1(unsigned int* seed);
inline float sfrand_m1_1(unsigned int* seed);
inline float sfrand_0_1(unsigned int* seed) {
  float res;
  *seed = mul24(*seed, 16807u);
  *((unsigned int*)&res) = ((*seed) >> 9) | 0x3F800000;
  return (res - 1.0f);
}

inline float sfrand_m1_1(unsigned int* seed) {
  float res;
  *seed = mul24(*seed, 16807u);
  *((unsigned int*)&res) = ((*seed) >> 9) | 0x40000000;
  return (res - 3.0f);
}

kernel void compute_distances(global const float4* pos_buffer, const float4 camera_pos, global float* dist_buffer) {
  const unsigned int global_id = get_global_id(0);
  if (global_id >= get_global_size(0))
    return;
  const float4 pos = pos_buffer[hook(0, global_id)];
  dist_buffer[hook(2, global_id)] = fast_distance(pos.xyz, camera_pos.xyz);
}