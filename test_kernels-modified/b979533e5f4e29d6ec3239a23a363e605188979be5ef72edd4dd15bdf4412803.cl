//{"M":23,"MD":24,"a":21,"b":22,"centers":6,"dirs":7,"dists":13,"frs":11,"lens":8,"m":18,"max_cells":0,"max_contacts":1,"n_cts":10,"n_planes":2,"norms":15,"plane_coeffs":5,"plane_norms":4,"plane_pts":3,"pts":14,"r":20,"rads":9,"reldists":16,"stiff":17,"t":19,"tos":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 matmul(float4 m[], float4 v) {
  return m[hook(18, 0)] * v.s0 + m[hook(18, 1)] * v.s1 + m[hook(18, 2)] * v.s2 + m[hook(18, 3)] * v.s3;
}

void transpose(float4 m[], float4 t[]) {
  t[hook(19, 0)].s0 = m[hook(18, 0)].s0;
  t[hook(19, 0)].s1 = m[hook(18, 1)].s0;
  t[hook(19, 0)].s2 = m[hook(18, 2)].s0;
  t[hook(19, 0)].s3 = m[hook(18, 3)].s0;
  t[hook(19, 1)].s0 = m[hook(18, 0)].s1;
  t[hook(19, 1)].s1 = m[hook(18, 1)].s1;
  t[hook(19, 1)].s2 = m[hook(18, 2)].s1;
  t[hook(19, 1)].s3 = m[hook(18, 3)].s1;
  t[hook(19, 2)].s0 = m[hook(18, 0)].s2;
  t[hook(19, 2)].s1 = m[hook(18, 1)].s2;
  t[hook(19, 2)].s2 = m[hook(18, 2)].s2;
  t[hook(19, 2)].s3 = m[hook(18, 3)].s2;
  t[hook(19, 3)].s0 = m[hook(18, 0)].s3;
  t[hook(19, 3)].s1 = m[hook(18, 1)].s3;
  t[hook(19, 3)].s2 = m[hook(18, 2)].s3;
  t[hook(19, 3)].s3 = m[hook(18, 3)].s3;
}

void matmulmat(float4 a[], float4 b[], float4 r[]) {
  r[hook(20, 0)].s0 = a[hook(21, 0)].s0 * b[hook(22, 0)].s0 + a[hook(21, 1)].s0 * b[hook(22, 0)].s1 + a[hook(21, 2)].s0 * b[hook(22, 0)].s2 + a[hook(21, 3)].s0 * b[hook(22, 0)].s3;
  r[hook(20, 1)].s0 = a[hook(21, 0)].s0 * b[hook(22, 1)].s0 + a[hook(21, 1)].s0 * b[hook(22, 1)].s1 + a[hook(21, 2)].s0 * b[hook(22, 1)].s2 + a[hook(21, 3)].s0 * b[hook(22, 1)].s3;
  r[hook(20, 2)].s0 = a[hook(21, 0)].s0 * b[hook(22, 2)].s0 + a[hook(21, 1)].s0 * b[hook(22, 2)].s1 + a[hook(21, 2)].s0 * b[hook(22, 2)].s2 + a[hook(21, 3)].s0 * b[hook(22, 2)].s3;
  r[hook(20, 3)].s0 = a[hook(21, 0)].s0 * b[hook(22, 3)].s0 + a[hook(21, 1)].s0 * b[hook(22, 3)].s1 + a[hook(21, 2)].s0 * b[hook(22, 3)].s2 + a[hook(21, 3)].s0 * b[hook(22, 3)].s3;
  r[hook(20, 0)].s1 = a[hook(21, 0)].s1 * b[hook(22, 0)].s0 + a[hook(21, 1)].s1 * b[hook(22, 0)].s1 + a[hook(21, 2)].s1 * b[hook(22, 0)].s2 + a[hook(21, 3)].s1 * b[hook(22, 0)].s3;
  r[hook(20, 1)].s1 = a[hook(21, 0)].s1 * b[hook(22, 1)].s0 + a[hook(21, 1)].s1 * b[hook(22, 1)].s1 + a[hook(21, 2)].s1 * b[hook(22, 1)].s2 + a[hook(21, 3)].s1 * b[hook(22, 1)].s3;
  r[hook(20, 2)].s1 = a[hook(21, 0)].s1 * b[hook(22, 2)].s0 + a[hook(21, 1)].s1 * b[hook(22, 2)].s1 + a[hook(21, 2)].s1 * b[hook(22, 2)].s2 + a[hook(21, 3)].s1 * b[hook(22, 2)].s3;
  r[hook(20, 3)].s1 = a[hook(21, 0)].s1 * b[hook(22, 3)].s0 + a[hook(21, 1)].s1 * b[hook(22, 3)].s1 + a[hook(21, 2)].s1 * b[hook(22, 3)].s2 + a[hook(21, 3)].s1 * b[hook(22, 3)].s3;
  r[hook(20, 0)].s2 = a[hook(21, 0)].s2 * b[hook(22, 0)].s0 + a[hook(21, 1)].s2 * b[hook(22, 0)].s1 + a[hook(21, 2)].s2 * b[hook(22, 0)].s2 + a[hook(21, 3)].s2 * b[hook(22, 0)].s3;
  r[hook(20, 1)].s2 = a[hook(21, 0)].s2 * b[hook(22, 1)].s0 + a[hook(21, 1)].s2 * b[hook(22, 1)].s1 + a[hook(21, 2)].s2 * b[hook(22, 1)].s2 + a[hook(21, 3)].s2 * b[hook(22, 1)].s3;
  r[hook(20, 2)].s2 = a[hook(21, 0)].s2 * b[hook(22, 2)].s0 + a[hook(21, 1)].s2 * b[hook(22, 2)].s1 + a[hook(21, 2)].s2 * b[hook(22, 2)].s2 + a[hook(21, 3)].s2 * b[hook(22, 2)].s3;
  r[hook(20, 3)].s2 = a[hook(21, 0)].s2 * b[hook(22, 3)].s0 + a[hook(21, 1)].s2 * b[hook(22, 3)].s1 + a[hook(21, 2)].s2 * b[hook(22, 3)].s2 + a[hook(21, 3)].s2 * b[hook(22, 3)].s3;
  r[hook(20, 0)].s3 = a[hook(21, 0)].s3 * b[hook(22, 0)].s0 + a[hook(21, 1)].s3 * b[hook(22, 0)].s1 + a[hook(21, 2)].s3 * b[hook(22, 0)].s2 + a[hook(21, 3)].s3 * b[hook(22, 0)].s3;
  r[hook(20, 1)].s3 = a[hook(21, 0)].s3 * b[hook(22, 1)].s0 + a[hook(21, 1)].s3 * b[hook(22, 1)].s1 + a[hook(21, 2)].s3 * b[hook(22, 1)].s2 + a[hook(21, 3)].s3 * b[hook(22, 1)].s3;
  r[hook(20, 2)].s3 = a[hook(21, 0)].s3 * b[hook(22, 2)].s0 + a[hook(21, 1)].s3 * b[hook(22, 2)].s1 + a[hook(21, 2)].s3 * b[hook(22, 2)].s2 + a[hook(21, 3)].s3 * b[hook(22, 2)].s3;
  r[hook(20, 3)].s3 = a[hook(21, 0)].s3 * b[hook(22, 3)].s0 + a[hook(21, 1)].s3 * b[hook(22, 3)].s1 + a[hook(21, 2)].s3 * b[hook(22, 3)].s2 + a[hook(21, 3)].s3 * b[hook(22, 3)].s3;
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
  M[hook(23, 0)] = axis;
  M[hook(23, 1)] = y_prime;
  M[hook(23, 2)] = z_prime;
  M[hook(23, 3)] = 0.f;

  float4 MD[4];
  MD[hook(24, 0)] = 0.f;
  MD[hook(24, 1)] = M[hook(23, 1)] * diag;
  MD[hook(24, 2)] = M[hook(23, 2)] * diag;
  MD[hook(24, 3)] = 0.f;

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

kernel void find_plane_contacts(const int max_cells, const int max_contacts, const int n_planes, global const float4* plane_pts, global const float4* plane_norms, global const float* plane_coeffs, global const float4* centers, global const float4* dirs, global const float* lens, global const float* rads, global int* n_cts, global int* frs, global int* tos, global float* dists, global float4* pts, global float4* norms, global float* reldists, global float* stiff) {
  int i = get_global_id(0);

  int k = n_cts[hook(10, i)];

  float4 end1 = centers[hook(6, i)] - 0.5f * lens[hook(8, i)] * dirs[hook(7, i)];
  float4 end2 = centers[hook(6, i)] + 0.5f * lens[hook(8, i)] * dirs[hook(7, i)];

  for (int n = 0; n < n_planes; n++) {
    int to1 = -2 * n - 1;
    int to2 = to1 - 1;

    float dist1 = pt_to_plane_dist(plane_pts[hook(3, n)], plane_norms[hook(4, n)], end1) - rads[hook(9, i)];
    float dist2 = pt_to_plane_dist(plane_pts[hook(3, n)], plane_norms[hook(4, n)], end2) - rads[hook(9, i)];

    int cti1 = -1;
    int cti2 = -1;
    for (int m = i * max_contacts; m < i * max_contacts + n_cts[hook(10, i)]; m++) {
      if (tos[hook(12, m)] == to1)
        cti1 = m;
      else if (tos[hook(12, m)] == to2)
        cti2 = m;
    }

    float4 norm = -plane_norms[hook(4, n)];

    bool two_pts = ((cti1 >= 0) || (dist1 < 0.f)) && ((cti2 >= 0) || (dist2 < 0.f));
    float stiffness = two_pts * ((float)(1.f / sqrt(2.f))) + (!two_pts) * 1.0;

    if ((cti1 >= 0) || (dist1 < 0.f)) {
      if (cti1 < 0) {
        cti1 = i * max_contacts + k;
        k++;
      }

      frs[hook(11, cti1)] = i;
      tos[hook(12, cti1)] = to1;
      dists[hook(13, cti1)] = dist1;
      pts[hook(14, cti1)] = end1;
      norms[hook(15, cti1)] = norm;
      reldists[hook(16, cti1)] = stiffness * plane_coeffs[hook(5, n)] * dist1;
      stiff[hook(17, cti1)] = stiffness * plane_coeffs[hook(5, n)];
    }

    if ((cti2 >= 0) || (dist2 < 0.f)) {
      if (cti2 < 0) {
        cti2 = i * max_contacts + k;
        k++;
      }

      frs[hook(11, cti2)] = i;
      tos[hook(12, cti2)] = to2;
      dists[hook(13, cti2)] = dist2;
      pts[hook(14, cti2)] = end2;
      norms[hook(15, cti2)] = norm;
      reldists[hook(16, cti2)] = stiffness * plane_coeffs[hook(5, n)] * dist2;
      stiff[hook(17, cti2)] = stiffness * plane_coeffs[hook(5, n)];
    }
  }
  n_cts[hook(10, i)] = k;
}