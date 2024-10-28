//{"M":12,"MD":13,"a":10,"b":11,"centers":5,"grid_spacing":4,"grid_x_max":1,"grid_x_min":0,"grid_y_max":3,"grid_y_min":2,"m":7,"r":9,"sqs":6,"t":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 matmul(float4 m[], float4 v) {
  return m[hook(7, 0)] * v.s0 + m[hook(7, 1)] * v.s1 + m[hook(7, 2)] * v.s2 + m[hook(7, 3)] * v.s3;
}

void transpose(float4 m[], float4 t[]) {
  t[hook(8, 0)].s0 = m[hook(7, 0)].s0;
  t[hook(8, 0)].s1 = m[hook(7, 1)].s0;
  t[hook(8, 0)].s2 = m[hook(7, 2)].s0;
  t[hook(8, 0)].s3 = m[hook(7, 3)].s0;
  t[hook(8, 1)].s0 = m[hook(7, 0)].s1;
  t[hook(8, 1)].s1 = m[hook(7, 1)].s1;
  t[hook(8, 1)].s2 = m[hook(7, 2)].s1;
  t[hook(8, 1)].s3 = m[hook(7, 3)].s1;
  t[hook(8, 2)].s0 = m[hook(7, 0)].s2;
  t[hook(8, 2)].s1 = m[hook(7, 1)].s2;
  t[hook(8, 2)].s2 = m[hook(7, 2)].s2;
  t[hook(8, 2)].s3 = m[hook(7, 3)].s2;
  t[hook(8, 3)].s0 = m[hook(7, 0)].s3;
  t[hook(8, 3)].s1 = m[hook(7, 1)].s3;
  t[hook(8, 3)].s2 = m[hook(7, 2)].s3;
  t[hook(8, 3)].s3 = m[hook(7, 3)].s3;
}

void matmulmat(float4 a[], float4 b[], float4 r[]) {
  r[hook(9, 0)].s0 = a[hook(10, 0)].s0 * b[hook(11, 0)].s0 + a[hook(10, 1)].s0 * b[hook(11, 0)].s1 + a[hook(10, 2)].s0 * b[hook(11, 0)].s2 + a[hook(10, 3)].s0 * b[hook(11, 0)].s3;
  r[hook(9, 1)].s0 = a[hook(10, 0)].s0 * b[hook(11, 1)].s0 + a[hook(10, 1)].s0 * b[hook(11, 1)].s1 + a[hook(10, 2)].s0 * b[hook(11, 1)].s2 + a[hook(10, 3)].s0 * b[hook(11, 1)].s3;
  r[hook(9, 2)].s0 = a[hook(10, 0)].s0 * b[hook(11, 2)].s0 + a[hook(10, 1)].s0 * b[hook(11, 2)].s1 + a[hook(10, 2)].s0 * b[hook(11, 2)].s2 + a[hook(10, 3)].s0 * b[hook(11, 2)].s3;
  r[hook(9, 3)].s0 = a[hook(10, 0)].s0 * b[hook(11, 3)].s0 + a[hook(10, 1)].s0 * b[hook(11, 3)].s1 + a[hook(10, 2)].s0 * b[hook(11, 3)].s2 + a[hook(10, 3)].s0 * b[hook(11, 3)].s3;
  r[hook(9, 0)].s1 = a[hook(10, 0)].s1 * b[hook(11, 0)].s0 + a[hook(10, 1)].s1 * b[hook(11, 0)].s1 + a[hook(10, 2)].s1 * b[hook(11, 0)].s2 + a[hook(10, 3)].s1 * b[hook(11, 0)].s3;
  r[hook(9, 1)].s1 = a[hook(10, 0)].s1 * b[hook(11, 1)].s0 + a[hook(10, 1)].s1 * b[hook(11, 1)].s1 + a[hook(10, 2)].s1 * b[hook(11, 1)].s2 + a[hook(10, 3)].s1 * b[hook(11, 1)].s3;
  r[hook(9, 2)].s1 = a[hook(10, 0)].s1 * b[hook(11, 2)].s0 + a[hook(10, 1)].s1 * b[hook(11, 2)].s1 + a[hook(10, 2)].s1 * b[hook(11, 2)].s2 + a[hook(10, 3)].s1 * b[hook(11, 2)].s3;
  r[hook(9, 3)].s1 = a[hook(10, 0)].s1 * b[hook(11, 3)].s0 + a[hook(10, 1)].s1 * b[hook(11, 3)].s1 + a[hook(10, 2)].s1 * b[hook(11, 3)].s2 + a[hook(10, 3)].s1 * b[hook(11, 3)].s3;
  r[hook(9, 0)].s2 = a[hook(10, 0)].s2 * b[hook(11, 0)].s0 + a[hook(10, 1)].s2 * b[hook(11, 0)].s1 + a[hook(10, 2)].s2 * b[hook(11, 0)].s2 + a[hook(10, 3)].s2 * b[hook(11, 0)].s3;
  r[hook(9, 1)].s2 = a[hook(10, 0)].s2 * b[hook(11, 1)].s0 + a[hook(10, 1)].s2 * b[hook(11, 1)].s1 + a[hook(10, 2)].s2 * b[hook(11, 1)].s2 + a[hook(10, 3)].s2 * b[hook(11, 1)].s3;
  r[hook(9, 2)].s2 = a[hook(10, 0)].s2 * b[hook(11, 2)].s0 + a[hook(10, 1)].s2 * b[hook(11, 2)].s1 + a[hook(10, 2)].s2 * b[hook(11, 2)].s2 + a[hook(10, 3)].s2 * b[hook(11, 2)].s3;
  r[hook(9, 3)].s2 = a[hook(10, 0)].s2 * b[hook(11, 3)].s0 + a[hook(10, 1)].s2 * b[hook(11, 3)].s1 + a[hook(10, 2)].s2 * b[hook(11, 3)].s2 + a[hook(10, 3)].s2 * b[hook(11, 3)].s3;
  r[hook(9, 0)].s3 = a[hook(10, 0)].s3 * b[hook(11, 0)].s0 + a[hook(10, 1)].s3 * b[hook(11, 0)].s1 + a[hook(10, 2)].s3 * b[hook(11, 0)].s2 + a[hook(10, 3)].s3 * b[hook(11, 0)].s3;
  r[hook(9, 1)].s3 = a[hook(10, 0)].s3 * b[hook(11, 1)].s0 + a[hook(10, 1)].s3 * b[hook(11, 1)].s1 + a[hook(10, 2)].s3 * b[hook(11, 1)].s2 + a[hook(10, 3)].s3 * b[hook(11, 1)].s3;
  r[hook(9, 2)].s3 = a[hook(10, 0)].s3 * b[hook(11, 2)].s0 + a[hook(10, 1)].s3 * b[hook(11, 2)].s1 + a[hook(10, 2)].s3 * b[hook(11, 2)].s2 + a[hook(10, 3)].s3 * b[hook(11, 2)].s3;
  r[hook(9, 3)].s3 = a[hook(10, 0)].s3 * b[hook(11, 3)].s0 + a[hook(10, 1)].s3 * b[hook(11, 3)].s1 + a[hook(10, 2)].s3 * b[hook(11, 3)].s2 + a[hook(10, 3)].s3 * b[hook(11, 3)].s3;
}

float4 quat_inv(float4 q) {
  float l2 = dot(q, q);
  float4 inv = {-q.x / l2, -q.y / l2, -q.z / l2, q.w / l2};
  return inv;
}

float4 quat_prod(float4 a, float4 b) {
  float4 res;
  res.x = a.x * b.w + a.y * b.z - a.z * b.y + a.w * b.x;
  res.y = -a.x * b.z + a.y * b.w + a.z * b.x + a.w * b.y;
  res.z = a.x * b.y - a.y * b.x + a.z * b.w + a.w * b.z;
  res.w = -a.x * b.x - a.y * b.y - a.z * b.z + a.w * b.w;
  return res;
}

float4 quat_rot(float4 q, float4 v) {
  v.w = 0.f;
  float4 qi = quat_inv(q);
  float4 v_prime = quat_prod(q, quat_prod(v, qi));
  v_prime.w = 0.f;
  return v_prime;
}

float4 rot(float4 axis, float angle, float4 v) {
  float4 q = axis * sin(angle / 2.f);
  q.w = cos(angle / 2.f);
  return quat_rot(q, v);
}

void print_matrix(float4* m) {
}

void cyl_inv_inertia_tensor(float muA, float l, float4 axis, float4 res[]) {
  float diag = 12.f / (muA * l * l * l);

  float4 x_axis = {1.f, 0.f, 0.f, 0.f};
  float4 y_axis = {0.f, 1.f, 0.f, 0.f};
  float4 z_axis = {0.f, 0.f, 1.f, 0.f};
  float rot_ang = acos(dot(x_axis, axis));

  float4 y_prime = y_axis;
  float4 z_prime = z_axis;

  if (rot_ang > 0.1f) {
    y_prime = rot(z_prime, rot_ang, y_axis);
    z_prime = normalize(cross(x_axis, axis));
  }

  float4 M[4];
  M[hook(12, 0)] = axis;
  M[hook(12, 1)] = y_prime;
  M[hook(12, 2)] = z_prime;
  M[hook(12, 3)] = 0.f;

  float4 MD[4];
  MD[hook(13, 0)] = 0.f;
  MD[hook(13, 1)] = M[hook(12, 1)] * diag;
  MD[hook(13, 2)] = M[hook(12, 2)] * diag;
  MD[hook(13, 3)] = 0.f;

  float4 MDT[4];
  transpose(MD, MDT);

  matmulmat(M, MDT, res);
}

kernel void bin_cells(const int grid_x_min, const int grid_x_max, const int grid_y_min, const int grid_y_max, const float grid_spacing, global const float4* centers, global int* sqs) {
  int i = get_global_id(0);
  int x = (int)floor(centers[hook(5, i)].x / grid_spacing) - grid_x_min;
  int y = (int)floor(centers[hook(5, i)].y / grid_spacing) - grid_y_min;
  sqs[hook(6, i)] = y * (grid_x_max - grid_x_min) + x;
}