//{"new_rays":1,"original_rays":0,"p_mat_and_vec":5,"p_matrix":4,"pixel":2,"rotmat_rows_and_dof_pos":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 ia_mul(float2 a, float2 b) {
  if ((((a).x) <= 0 && ((a).y) >= 0)) {
    if ((((b).x) <= 0 && ((b).y) >= 0)) {
      return ((float2)(min(((a).x) * ((b).y), ((b).x) * ((a).y)), max(((a).x) * ((b).x), ((a).y) * ((b).y))));

    } else {
      float2 tmp = b;
      b = a;
      a = tmp;
    }
  }

  if (((a).y) < 0) {
    a = (((float2)(-((a).y), -((a).x))));
    b = (((float2)(-((b).y), -((b).x))));
  }

  if (((b).y) < 0)
    return ((float2)(((a).y) * ((b).x), ((a).x) * ((b).y)));
  else if ((((b).x) <= 0 && ((b).y) >= 0))
    return ((float2)(((a).y) * ((b).x), ((a).y) * ((b).y)));
  else
    return a * b;
}

float2 ia_pow2(float2 a) {
  float2 ab = ((((a).x) >= 0.0) ? (a) : ((((a).y) <= 0.0) ? (((float2)(-((a).y), -((a).x)))) : ((float2)(0.0, max(-((a).x), ((a).y))))));
  return ab * ab;
}

float2 ia_pow3(float2 a) {
  return a * a * a;
}

float2 ia_pow4(float2 a) {
  float2 a2 = ia_pow2(a);
  return a2 * a2;
}

float3 apply_linear_transform(constant const float4* p_matrix, float3 vector) {
  return (float3)(dot(p_matrix[hook(4, 0)].xyz, vector), dot(p_matrix[hook(4, 1)].xyz, vector), dot(p_matrix[hook(4, 2)].xyz, vector));
}

float3 apply_transposed_linear_transform(constant const float4* p_matrix, float3 vector) {
  return (float3)(dot((float3)(p_matrix[hook(4, 0)].x, p_matrix[hook(4, 1)].x, p_matrix[hook(4, 2)].x), vector), dot((float3)(p_matrix[hook(4, 0)].y, p_matrix[hook(4, 1)].y, p_matrix[hook(4, 2)].y), vector), dot((float3)(p_matrix[hook(4, 0)].z, p_matrix[hook(4, 1)].z, p_matrix[hook(4, 2)].z), vector));
}

float3 apply_affine_transform(constant const float4* p_mat_and_vec, float3 vector) {
  return apply_linear_transform(p_mat_and_vec, vector) + p_mat_and_vec[hook(5, 3)].xyz;
}

float4 quaternion_mult(float4 q1, float4 q2) {
  float4 r;
  r.x = q1.x * q2.x - dot(q1.yzw, q2.yzw);
  r.yzw = q1.x * q2.yzw + q2.x * q1.yzw + cross(q1.yzw, q2.yzw);
  return r;
}

float4 quaternion_square(float4 q) {
  float4 r;
  r.x = q.x * q.x - dot(q.yzw, q.yzw);
  r.yzw = 2 * q.x * q.yzw;
  return r;
}

kernel void subsample_transform_camera(global const float3* original_rays, global float3* new_rays, global int* pixel, constant float4* rotmat_rows_and_dof_pos) {
  const int gid = get_global_id(0);
  const float sharp_distance = rotmat_rows_and_dof_pos[hook(3, 3)].w;
  const float3 campos = rotmat_rows_and_dof_pos[hook(3, 3)].xyz;
  const float3 ray = original_rays[hook(0, gid)];

  pixel[hook(2, gid)] = gid;

  const float3 rot_ray = (float3)(dot(rotmat_rows_and_dof_pos[hook(3, 0)].xyz, ray), dot(rotmat_rows_and_dof_pos[hook(3, 1)].xyz, ray), dot(rotmat_rows_and_dof_pos[hook(3, 2)].xyz, ray));

  if (sharp_distance > 0.0)
    new_rays[hook(1, gid)] = fast_normalize(sharp_distance * rot_ray - campos);
  else
    new_rays[hook(1, gid)] = rot_ray;
}