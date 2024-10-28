//{"((__private float *)&ret_mat)":12,"((const __private float *)&mat_1)":13,"((const __private float *)&mat_2)":14,"IMVM":7,"cam_position":4,"dbg_buffer":11,"depth_buffer":1,"light_count":10,"lights":9,"normal_nuv_buffer":0,"output_buffer_diff":2,"output_buffer_spec":3,"projection_ab":6,"screen_size":5,"tiles":8}
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
typedef float16 matrix4;

float4 matrix4_mul_float4(const matrix4 mat, const float4 vec);
matrix4 matrix4_mul_matrix4(const matrix4 mat_1, const matrix4 mat_2);

matrix4 matrix4_mul_matrix4(const matrix4 mat_1, const matrix4 mat_2) {
  matrix4 ret_mat;
  for (size_t i = 0; i < 4; i++) {
    for (size_t j = 0; j < 4; j++) {
      ((float*)&ret_mat)[hook(12, i * 4 + j)] = 0.0f;
      for (size_t k = 0; k < 4; k++) {
        ((float*)&ret_mat)[hook(12, i * 4 + j)] += ((const float*)&mat_1)[hook(13, i * 4 + k)] * ((const float*)&mat_2)[hook(14, k * 4 + j)];
      }
    }
  }
  return ret_mat;
}

float4 matrix4_mul_float4(const matrix4 mat, const float4 vec) {
  float4 ret_vec;
  ret_vec = vec.x * (mat).lo.lo;
  ret_vec += vec.y * (mat).lo.hi;
  ret_vec += vec.z * (mat).hi.lo;
  ret_vec += vec.w * (mat).hi.hi;
  return ret_vec;
}

struct __attribute__((aligned(32), packed)) ir_light {
  float4 position;
  float4 float3;
};

float3 reflect(const float3 N, const float3 I);
float3 reflect(const float3 N, const float3 I) {
  return I - 2.0f * dot(N, I) * N;
}

bool light_intersects(global const struct ir_light* lights, const float2 minmax_depth, const unsigned int light_index);
bool light_intersects(global const struct ir_light* lights, const float2 minmax_depth, const unsigned int light_index) {
  return true;
}

kernel void ir_lighting(

    read_only image2d_t normal_nuv_buffer, read_only image2d_t depth_buffer,

    write_only image2d_t output_buffer_diff, write_only image2d_t output_buffer_spec,

    const float3 cam_position, const uint2 screen_size, const float2 projection_ab, const matrix4 IMVM, const uint2 tiles,

    constant const struct ir_light* lights, const unsigned int light_count,

    global unsigned int* dbg_buffer) {
  const unsigned int local_id = get_local_id(0);
  const unsigned int group_id = get_group_id(0);
  const unsigned int idx = (group_id % tiles.x) * 8 + (local_id % 8);
  const unsigned int idy = (group_id / tiles.x) * 8 + (local_id / 8);
  if (idx >= screen_size.x || idy >= screen_size.y)
    return;

  const int2 tex_coord = (int2)(idx, idy);
  const sampler_t point_sampler = 0 | 0x10 | 0;

  const float2 fscreen_size = (float2)(screen_size.x, screen_size.y);
  float2 ftex_coord = (float2)(idx, idy) / fscreen_size;

  float depth = read_imagef(depth_buffer, point_sampler, tex_coord).x;
  if (depth >= 1.0f)
    return;
  float4 norm_nuv_read = read_imagef(normal_nuv_buffer, point_sampler, tex_coord);
  float2 normal_read = norm_nuv_read.xy;
  float2 nuv = norm_nuv_read.zw;

  const float linear_depth = projection_ab.y / (depth - projection_ab.x);
  const float up_vec = 0.72654252800536066024136247722454f;
  const float right_vec = up_vec * (fscreen_size.x / fscreen_size.y);

  float3 rep_pos;
  rep_pos.z = -linear_depth;
  rep_pos.xy = (ftex_coord * 2.0f - 1.0f) * (float2)(right_vec, up_vec) * linear_depth;
  rep_pos = matrix4_mul_float4(IMVM, (float4)(rep_pos, 1.0f)).xyz;

  float3 normal;
  normal.z = dot(normal_read.xy, normal_read.xy) * 2.0f - 1.0f;

  normal.xy = normalize(normal_read.xy) * sqrt(fabs(1.0f - normal.z * normal.z));

  float3 view_dir = cam_position - rep_pos;
  view_dir = normalize(view_dir);

  if (nuv.x == 0.0f && nuv.y == 0.0f) {
    normal = normalize(view_dir + (float3)(0.01f, -0.01f, 0.01f));
    nuv = (float2)(1.0f, 1.0f);
  }

  float4 diff_color = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float4 spec_color = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  for (unsigned int i = 0; i < light_count; i++) {
    const float4 light_position = lights[hook(9, i)].position;
    const float4 light_color = lights[hook(9, i)].float3;

    float3 light_dir = (light_position.xyz - rep_pos);
    light_dir *= light_color.w;
    float attenuation = 1.0f - dot(light_dir, light_dir) * (light_position.w * light_position.w);
    if (attenuation <= 0.01f)
      continue;
    light_dir = normalize(light_dir);

    float3 half_vec = normalize(light_dir + view_dir);

    float3 epsilon = (float3)(1.0f, 0.0f, 0.0f);
    float3 tangent = normalize(cross(normal, epsilon));
    float3 bitangent = normalize(cross(normal, tangent));

    float LdotN = dot(light_dir, normal);
    if (LdotN <= 0.001f)
      continue;

    float VdotN = dot(view_dir, normal);
    float HdotN = dot(half_vec, normal);
    float HdotL = dot(half_vec, light_dir);
    float HdotT = dot(half_vec, tangent);
    float HdotB = dot(half_vec, bitangent);

    float3 light_rgb = light_color.xyz * attenuation;

    const float pd_const = 28.0f / (23.0f * 3.14159f);
    float pd_0 = 1.0f - pow(1.0f - (LdotN / 2.0f), 5.0f);
    float pd_1 = 1.0f - pow(1.0f - (VdotN / 2.0f), 5.0f);
    diff_color.xyz += pd_const * pd_0 * pd_1 * light_rgb;

    float ps_num_exp = nuv.x * HdotT * HdotT + nuv.y * HdotB * HdotB;
    ps_num_exp /= (1.0f - HdotN * HdotN);
    float ps_num = sqrt((nuv.x + 1.0f) * (nuv.y + 1.0f));
    ps_num *= pow(HdotN, ps_num_exp);

    float ps_den = (8.0f * 3.14159f) * HdotL * max(LdotN, VdotN);

    spec_color.xyz += light_rgb * (ps_num / ps_den);
    spec_color.w += pow(1.0f - HdotL, 5.0f);
  }

  write_imagef(output_buffer_diff, tex_coord, diff_color);
  write_imagef(output_buffer_spec, tex_coord, spec_color);
}