//{"M":21,"MD":22,"a":19,"b":20,"cell_tos":14,"frs":12,"grid_x_max":3,"grid_x_min":2,"grid_y_max":5,"grid_y_min":4,"m":16,"max_cells":0,"max_contacts":7,"n_cell_tos":15,"n_cells":1,"n_cts":11,"n_sqs":6,"r":18,"sorted_ids":9,"sq_inds":10,"sqs":8,"t":17,"tos":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 matmul(float4 m[], float4 v) {
  return m[hook(16, 0)] * v.s0 + m[hook(16, 1)] * v.s1 + m[hook(16, 2)] * v.s2 + m[hook(16, 3)] * v.s3;
}

void transpose(float4 m[], float4 t[]) {
  t[hook(17, 0)].s0 = m[hook(16, 0)].s0;
  t[hook(17, 0)].s1 = m[hook(16, 1)].s0;
  t[hook(17, 0)].s2 = m[hook(16, 2)].s0;
  t[hook(17, 0)].s3 = m[hook(16, 3)].s0;
  t[hook(17, 1)].s0 = m[hook(16, 0)].s1;
  t[hook(17, 1)].s1 = m[hook(16, 1)].s1;
  t[hook(17, 1)].s2 = m[hook(16, 2)].s1;
  t[hook(17, 1)].s3 = m[hook(16, 3)].s1;
  t[hook(17, 2)].s0 = m[hook(16, 0)].s2;
  t[hook(17, 2)].s1 = m[hook(16, 1)].s2;
  t[hook(17, 2)].s2 = m[hook(16, 2)].s2;
  t[hook(17, 2)].s3 = m[hook(16, 3)].s2;
  t[hook(17, 3)].s0 = m[hook(16, 0)].s3;
  t[hook(17, 3)].s1 = m[hook(16, 1)].s3;
  t[hook(17, 3)].s2 = m[hook(16, 2)].s3;
  t[hook(17, 3)].s3 = m[hook(16, 3)].s3;
}

void matmulmat(float4 a[], float4 b[], float4 r[]) {
  r[hook(18, 0)].s0 = a[hook(19, 0)].s0 * b[hook(20, 0)].s0 + a[hook(19, 1)].s0 * b[hook(20, 0)].s1 + a[hook(19, 2)].s0 * b[hook(20, 0)].s2 + a[hook(19, 3)].s0 * b[hook(20, 0)].s3;
  r[hook(18, 1)].s0 = a[hook(19, 0)].s0 * b[hook(20, 1)].s0 + a[hook(19, 1)].s0 * b[hook(20, 1)].s1 + a[hook(19, 2)].s0 * b[hook(20, 1)].s2 + a[hook(19, 3)].s0 * b[hook(20, 1)].s3;
  r[hook(18, 2)].s0 = a[hook(19, 0)].s0 * b[hook(20, 2)].s0 + a[hook(19, 1)].s0 * b[hook(20, 2)].s1 + a[hook(19, 2)].s0 * b[hook(20, 2)].s2 + a[hook(19, 3)].s0 * b[hook(20, 2)].s3;
  r[hook(18, 3)].s0 = a[hook(19, 0)].s0 * b[hook(20, 3)].s0 + a[hook(19, 1)].s0 * b[hook(20, 3)].s1 + a[hook(19, 2)].s0 * b[hook(20, 3)].s2 + a[hook(19, 3)].s0 * b[hook(20, 3)].s3;
  r[hook(18, 0)].s1 = a[hook(19, 0)].s1 * b[hook(20, 0)].s0 + a[hook(19, 1)].s1 * b[hook(20, 0)].s1 + a[hook(19, 2)].s1 * b[hook(20, 0)].s2 + a[hook(19, 3)].s1 * b[hook(20, 0)].s3;
  r[hook(18, 1)].s1 = a[hook(19, 0)].s1 * b[hook(20, 1)].s0 + a[hook(19, 1)].s1 * b[hook(20, 1)].s1 + a[hook(19, 2)].s1 * b[hook(20, 1)].s2 + a[hook(19, 3)].s1 * b[hook(20, 1)].s3;
  r[hook(18, 2)].s1 = a[hook(19, 0)].s1 * b[hook(20, 2)].s0 + a[hook(19, 1)].s1 * b[hook(20, 2)].s1 + a[hook(19, 2)].s1 * b[hook(20, 2)].s2 + a[hook(19, 3)].s1 * b[hook(20, 2)].s3;
  r[hook(18, 3)].s1 = a[hook(19, 0)].s1 * b[hook(20, 3)].s0 + a[hook(19, 1)].s1 * b[hook(20, 3)].s1 + a[hook(19, 2)].s1 * b[hook(20, 3)].s2 + a[hook(19, 3)].s1 * b[hook(20, 3)].s3;
  r[hook(18, 0)].s2 = a[hook(19, 0)].s2 * b[hook(20, 0)].s0 + a[hook(19, 1)].s2 * b[hook(20, 0)].s1 + a[hook(19, 2)].s2 * b[hook(20, 0)].s2 + a[hook(19, 3)].s2 * b[hook(20, 0)].s3;
  r[hook(18, 1)].s2 = a[hook(19, 0)].s2 * b[hook(20, 1)].s0 + a[hook(19, 1)].s2 * b[hook(20, 1)].s1 + a[hook(19, 2)].s2 * b[hook(20, 1)].s2 + a[hook(19, 3)].s2 * b[hook(20, 1)].s3;
  r[hook(18, 2)].s2 = a[hook(19, 0)].s2 * b[hook(20, 2)].s0 + a[hook(19, 1)].s2 * b[hook(20, 2)].s1 + a[hook(19, 2)].s2 * b[hook(20, 2)].s2 + a[hook(19, 3)].s2 * b[hook(20, 2)].s3;
  r[hook(18, 3)].s2 = a[hook(19, 0)].s2 * b[hook(20, 3)].s0 + a[hook(19, 1)].s2 * b[hook(20, 3)].s1 + a[hook(19, 2)].s2 * b[hook(20, 3)].s2 + a[hook(19, 3)].s2 * b[hook(20, 3)].s3;
  r[hook(18, 0)].s3 = a[hook(19, 0)].s3 * b[hook(20, 0)].s0 + a[hook(19, 1)].s3 * b[hook(20, 0)].s1 + a[hook(19, 2)].s3 * b[hook(20, 0)].s2 + a[hook(19, 3)].s3 * b[hook(20, 0)].s3;
  r[hook(18, 1)].s3 = a[hook(19, 0)].s3 * b[hook(20, 1)].s0 + a[hook(19, 1)].s3 * b[hook(20, 1)].s1 + a[hook(19, 2)].s3 * b[hook(20, 1)].s2 + a[hook(19, 3)].s3 * b[hook(20, 1)].s3;
  r[hook(18, 2)].s3 = a[hook(19, 0)].s3 * b[hook(20, 2)].s0 + a[hook(19, 1)].s3 * b[hook(20, 2)].s1 + a[hook(19, 2)].s3 * b[hook(20, 2)].s2 + a[hook(19, 3)].s3 * b[hook(20, 2)].s3;
  r[hook(18, 3)].s3 = a[hook(19, 0)].s3 * b[hook(20, 3)].s0 + a[hook(19, 1)].s3 * b[hook(20, 3)].s1 + a[hook(19, 2)].s3 * b[hook(20, 3)].s2 + a[hook(19, 3)].s3 * b[hook(20, 3)].s3;
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
  M[hook(21, 0)] = axis;
  M[hook(21, 1)] = y_prime;
  M[hook(21, 2)] = z_prime;
  M[hook(21, 3)] = 0.f;

  float4 MD[4];
  MD[hook(22, 0)] = 0.f;
  MD[hook(22, 1)] = M[hook(21, 1)] * diag;
  MD[hook(22, 2)] = M[hook(21, 2)] * diag;
  MD[hook(22, 3)] = 0.f;

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

kernel void collect_tos(const int max_cells, const int n_cells, const int grid_x_min, const int grid_x_max, const int grid_y_min, const int grid_y_max, const int n_sqs, const int max_contacts, global const int* sqs, global const int* sorted_ids, global const int* sq_inds, global const int* n_cts, global const int* frs, global const int* tos, global int* cell_tos, global int* n_cell_tos) {
  int i = get_global_id(0);

  int grid_x_range = grid_x_max - grid_x_min;
  int grid_y_range = grid_y_max - grid_y_min;
  int sq_row = sqs[hook(8, i)] / grid_x_range;
  int sq_col = sqs[hook(8, i)] % grid_x_range;

  int k = 0;

  for (int row = max(0, sq_row - 1); row < min((int)(sq_row + 2), grid_y_range); row++) {
    for (int col = max(0, sq_col - 1); col < min((int)(sq_col + 2), grid_x_range); col++) {
      int sq = row * grid_x_range + col;

      for (int n = sq_inds[hook(10, sq)]; n < (sq < n_sqs - 1 ? sq_inds[hook(10, sq + 1)] : n_cells); n++) {
        int j = sorted_ids[hook(9, n)];

        if (j >= i || j < 0)
          continue;

        for (int m = 0; m < n_cts[hook(11, j)]; m++) {
          int ct_i = (int)(j) * (int)(max_contacts) + m;
          if (tos[hook(13, ct_i)] == i) {
            cell_tos[hook(14, i * max_contacts + k)] = ct_i;
            k++;
          }
        }
      }
    }
  }
  n_cell_tos[hook(15, i)] = k;

  for (int u = k; u < max_contacts; u++) {
    cell_tos[hook(14, i * max_contacts + u)] = 0;
  }
}