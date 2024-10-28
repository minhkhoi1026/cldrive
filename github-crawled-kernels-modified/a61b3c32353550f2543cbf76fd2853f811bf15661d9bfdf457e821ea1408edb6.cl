//{"M":15,"MD":16,"a":13,"b":14,"dangs":7,"dcenters":6,"deltap":2,"dirs":3,"dlens":9,"gamma":1,"lens":4,"m":10,"muA":0,"r":12,"rads":5,"t":11,"target_dlens":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 matmul(float4 m[], float4 v) {
  return m[hook(10, 0)] * v.s0 + m[hook(10, 1)] * v.s1 + m[hook(10, 2)] * v.s2 + m[hook(10, 3)] * v.s3;
}

void transpose(float4 m[], float4 t[]) {
  t[hook(11, 0)].s0 = m[hook(10, 0)].s0;
  t[hook(11, 0)].s1 = m[hook(10, 1)].s0;
  t[hook(11, 0)].s2 = m[hook(10, 2)].s0;
  t[hook(11, 0)].s3 = m[hook(10, 3)].s0;
  t[hook(11, 1)].s0 = m[hook(10, 0)].s1;
  t[hook(11, 1)].s1 = m[hook(10, 1)].s1;
  t[hook(11, 1)].s2 = m[hook(10, 2)].s1;
  t[hook(11, 1)].s3 = m[hook(10, 3)].s1;
  t[hook(11, 2)].s0 = m[hook(10, 0)].s2;
  t[hook(11, 2)].s1 = m[hook(10, 1)].s2;
  t[hook(11, 2)].s2 = m[hook(10, 2)].s2;
  t[hook(11, 2)].s3 = m[hook(10, 3)].s2;
  t[hook(11, 3)].s0 = m[hook(10, 0)].s3;
  t[hook(11, 3)].s1 = m[hook(10, 1)].s3;
  t[hook(11, 3)].s2 = m[hook(10, 2)].s3;
  t[hook(11, 3)].s3 = m[hook(10, 3)].s3;
}

void matmulmat(float4 a[], float4 b[], float4 r[]) {
  r[hook(12, 0)].s0 = a[hook(13, 0)].s0 * b[hook(14, 0)].s0 + a[hook(13, 1)].s0 * b[hook(14, 0)].s1 + a[hook(13, 2)].s0 * b[hook(14, 0)].s2 + a[hook(13, 3)].s0 * b[hook(14, 0)].s3;
  r[hook(12, 1)].s0 = a[hook(13, 0)].s0 * b[hook(14, 1)].s0 + a[hook(13, 1)].s0 * b[hook(14, 1)].s1 + a[hook(13, 2)].s0 * b[hook(14, 1)].s2 + a[hook(13, 3)].s0 * b[hook(14, 1)].s3;
  r[hook(12, 2)].s0 = a[hook(13, 0)].s0 * b[hook(14, 2)].s0 + a[hook(13, 1)].s0 * b[hook(14, 2)].s1 + a[hook(13, 2)].s0 * b[hook(14, 2)].s2 + a[hook(13, 3)].s0 * b[hook(14, 2)].s3;
  r[hook(12, 3)].s0 = a[hook(13, 0)].s0 * b[hook(14, 3)].s0 + a[hook(13, 1)].s0 * b[hook(14, 3)].s1 + a[hook(13, 2)].s0 * b[hook(14, 3)].s2 + a[hook(13, 3)].s0 * b[hook(14, 3)].s3;
  r[hook(12, 0)].s1 = a[hook(13, 0)].s1 * b[hook(14, 0)].s0 + a[hook(13, 1)].s1 * b[hook(14, 0)].s1 + a[hook(13, 2)].s1 * b[hook(14, 0)].s2 + a[hook(13, 3)].s1 * b[hook(14, 0)].s3;
  r[hook(12, 1)].s1 = a[hook(13, 0)].s1 * b[hook(14, 1)].s0 + a[hook(13, 1)].s1 * b[hook(14, 1)].s1 + a[hook(13, 2)].s1 * b[hook(14, 1)].s2 + a[hook(13, 3)].s1 * b[hook(14, 1)].s3;
  r[hook(12, 2)].s1 = a[hook(13, 0)].s1 * b[hook(14, 2)].s0 + a[hook(13, 1)].s1 * b[hook(14, 2)].s1 + a[hook(13, 2)].s1 * b[hook(14, 2)].s2 + a[hook(13, 3)].s1 * b[hook(14, 2)].s3;
  r[hook(12, 3)].s1 = a[hook(13, 0)].s1 * b[hook(14, 3)].s0 + a[hook(13, 1)].s1 * b[hook(14, 3)].s1 + a[hook(13, 2)].s1 * b[hook(14, 3)].s2 + a[hook(13, 3)].s1 * b[hook(14, 3)].s3;
  r[hook(12, 0)].s2 = a[hook(13, 0)].s2 * b[hook(14, 0)].s0 + a[hook(13, 1)].s2 * b[hook(14, 0)].s1 + a[hook(13, 2)].s2 * b[hook(14, 0)].s2 + a[hook(13, 3)].s2 * b[hook(14, 0)].s3;
  r[hook(12, 1)].s2 = a[hook(13, 0)].s2 * b[hook(14, 1)].s0 + a[hook(13, 1)].s2 * b[hook(14, 1)].s1 + a[hook(13, 2)].s2 * b[hook(14, 1)].s2 + a[hook(13, 3)].s2 * b[hook(14, 1)].s3;
  r[hook(12, 2)].s2 = a[hook(13, 0)].s2 * b[hook(14, 2)].s0 + a[hook(13, 1)].s2 * b[hook(14, 2)].s1 + a[hook(13, 2)].s2 * b[hook(14, 2)].s2 + a[hook(13, 3)].s2 * b[hook(14, 2)].s3;
  r[hook(12, 3)].s2 = a[hook(13, 0)].s2 * b[hook(14, 3)].s0 + a[hook(13, 1)].s2 * b[hook(14, 3)].s1 + a[hook(13, 2)].s2 * b[hook(14, 3)].s2 + a[hook(13, 3)].s2 * b[hook(14, 3)].s3;
  r[hook(12, 0)].s3 = a[hook(13, 0)].s3 * b[hook(14, 0)].s0 + a[hook(13, 1)].s3 * b[hook(14, 0)].s1 + a[hook(13, 2)].s3 * b[hook(14, 0)].s2 + a[hook(13, 3)].s3 * b[hook(14, 0)].s3;
  r[hook(12, 1)].s3 = a[hook(13, 0)].s3 * b[hook(14, 1)].s0 + a[hook(13, 1)].s3 * b[hook(14, 1)].s1 + a[hook(13, 2)].s3 * b[hook(14, 1)].s2 + a[hook(13, 3)].s3 * b[hook(14, 1)].s3;
  r[hook(12, 2)].s3 = a[hook(13, 0)].s3 * b[hook(14, 2)].s0 + a[hook(13, 1)].s3 * b[hook(14, 2)].s1 + a[hook(13, 2)].s3 * b[hook(14, 2)].s2 + a[hook(13, 3)].s3 * b[hook(14, 2)].s3;
  r[hook(12, 3)].s3 = a[hook(13, 0)].s3 * b[hook(14, 3)].s0 + a[hook(13, 1)].s3 * b[hook(14, 3)].s1 + a[hook(13, 2)].s3 * b[hook(14, 3)].s2 + a[hook(13, 3)].s3 * b[hook(14, 3)].s3;
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
  M[hook(15, 0)] = axis;
  M[hook(15, 1)] = y_prime;
  M[hook(15, 2)] = z_prime;
  M[hook(15, 3)] = 0.f;

  float4 MD[4];
  MD[hook(16, 0)] = 0.f;
  MD[hook(16, 1)] = M[hook(15, 1)] * diag;
  MD[hook(16, 2)] = M[hook(15, 2)] * diag;
  MD[hook(16, 3)] = 0.f;

  float4 MDT[4];
  transpose(MD, MDT);

  matmulmat(M, MDT, res);
}

void closest_points_on_segments(const float4 r_a, const float4 r_b, const float4 a, const float4 b, const float len_a, const float len_b, float4* p_a, float4* p_b, float4* p_a2, float4* p_b2, int* two_pts) {
  float hlen_a = len_a / 2.f;
  float hlen_b = len_b / 2.f;
  float4 r = r_b - r_a;
  float a_dot_r = dot(a, r);
  float b_dot_r = dot(b, r);
  float a_dot_b = dot(a, b);
  float denom = 1.f - a_dot_b * a_dot_b;

  float t_a = 0.f;
  float t_b = 0.f;

  *two_pts = 0;
  float t_a2 = 0.f;
  float t_b2 = 0.f;

  if (sqrt(denom) > 0.1f) {
    float t_a0 = (a_dot_r - b_dot_r * a_dot_b) / denom;
    float t_b0 = (a_dot_r * a_dot_b - b_dot_r) / denom;

    bool on_a = fabs(t_a0) < hlen_a;
    bool on_b = fabs(t_b0) < hlen_b;
    if (!on_a && !on_b) {
      float c_a = copysign(hlen_a, t_a0);
      float c_b = copysign(hlen_b, t_b0);

      float dd_dt_a = 2.f * (c_a - a_dot_b * c_b - a_dot_r);
      float dd_dt_b = 2.f * (c_b - a_dot_b * c_a + b_dot_r);

      if (sign(dd_dt_a) == sign(c_a)) {
        t_b = c_b;
        t_a = clamp(t_b * a_dot_b + a_dot_r, -hlen_a, hlen_a);
      } else {
        t_a = c_a;
        t_b = clamp(t_a * a_dot_b - b_dot_r, -hlen_b, hlen_b);
      }
    } else if (on_a && !on_b) {
      t_b = copysign(hlen_b, t_b0);
      t_a = clamp(t_b * a_dot_b + a_dot_r, -hlen_a, hlen_a);
    } else if (!on_a && on_b) {
      t_a = copysign(hlen_a, t_a0);
      t_b = clamp(t_a * a_dot_b - b_dot_r, -hlen_b, hlen_b);
    } else {
      t_a = t_a0;
      t_b = t_b0;
    }
  } else {
    float x_dot_r = copysign(min(a_dot_r, b_dot_r), a_dot_r);

    float a_l = -x_dot_r - hlen_a;
    float a_r = -x_dot_r + hlen_a;

    float i_l = max(a_l, -hlen_b);
    float i_r = min(a_r, hlen_b);

    if (i_l > i_r) {
      if (a_l < -hlen_b) {
        t_a = hlen_a;
        t_b = -hlen_b;
      } else {
        t_a = -hlen_a;
        t_b = hlen_b;
      }
    } else {
      *two_pts = 1;
      t_b = i_l;
      t_a = t_b + x_dot_r;
      t_b2 = i_r;
      t_a2 = t_b2 + x_dot_r;
    }

    if (a_dot_b < 0.f) {
      t_b = -t_b;
      t_b2 = -t_b2;
    }
  }
  *p_a = r_a + t_a * a;
  *p_b = r_b + t_b * b;
  if (two_pts) {
    *p_a2 = r_a + t_a2 * a;
    *p_b2 = r_b + t_b2 * b;
  }
}

float pt_to_plane_dist(float4 v, float4 n, float4 p) {
  return dot((p - v), n);
}

kernel void add_impulse(const float muA, const float gamma, global const float8* deltap, global const float4* dirs, global const float* lens, global const float* rads, global float4* dcenters, global float4* dangs, global const float* target_dlens, global float* dlens) {
  int i = get_global_id(0);

  float4 dir_i = dirs[hook(3, i)];
  float len_i = lens[hook(4, i)];
  float rad_i = rads[hook(5, i)];
  float8 deltap_i = deltap[hook(2, i)];

  float4 dplin = 0.f;
  dplin.s012 = deltap_i.s012;
  dcenters[hook(6, i)] += dplin / (muA * (lens[hook(4, i)] + 2.f * rads[hook(5, i)]));

  float4 Iinv[4];
  cyl_inv_inertia_tensor(muA, len_i + 2.f * rad_i, dir_i, Iinv);
  float4 dL = 0.f;
  dL.s012 = deltap_i.s345;
  float4 dpang = matmul(Iinv, dL);
  float dpangmag = length(dpang);
  if (dpangmag > ((float)(5.f * 3.14159f / 180.f))) {
    dpang *= ((float)(5.f * 3.14159f / 180.f)) / dpangmag;
  }
  dangs[hook(7, i)] += dpang;

  float dplen = deltap_i.s6;

  dlens[hook(9, i)] = max(0.f, dlens[hook(9, i)] + dplen / gamma);
}