//{"T->vertices":7,"array":3,"col":6,"ids_behind":13,"num":19,"nums":1,"passback":18,"points":8,"pr":16,"raw":11,"ret":9,"ret[0]":14,"ret[1]":15,"rotated":12,"size":20,"sizes":2,"tex_id":0,"triangle->vertices":10,"tris":17,"x":4,"y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct interp_container;
float rerror(float a, float b) {
  return fabs(a - b);
}

float min3(float x, float y, float z) {
  return min(min(x, y), z);
}

float max3(float x, float y, float z) {
  return max(max(x, y), z);
}

int imin3(int x, int y, int z) {
  return min(min(x, y), z);
}

int imax3(int x, int y, int z) {
  return max(max(x, y), z);
}

float calc_area(float3 x, float3 y) {
  return fabs((x.x * (y.y - y.z) + x.y * (y.z - y.x) + x.z * (y.x - y.y)) * 0.5f);
}

struct voxel {
  int offset;
  uchar valid_mask;
  uchar leaf_mask;
  uchar2 pad;
};

struct light {
  float4 pos;
  float4 col;
  unsigned int shadow;
  float brightness;
  float radius;
  float diffuse;
  float godray_intensity;
  int is_static;
};

enum object_feature_flag {
  FEATURE_FLAG_SS_REFLECTIVE = 1,
  FEATURE_FLAG_TWO_SIDED = 2,
  FEATURE_FLAG_OUTLINE = 4,
  FEATURE_FLAG_IS_STATIC = 8,
  FEATURE_FLAG_DOES_NOT_RECEIVE_DYNAMIC_SHADOWS = 16,
};

struct obj_g_descriptor {
  float4 world_pos;

  float4 world_rot_quat;

  float4 old_world_pos_1;
  float4 old_world_pos_2;
  float4 old_world_rot_quat_1;
  float4 old_world_rot_quat_2;

  float scale;
  unsigned int tid;
  unsigned int rid;
  unsigned int ssid;

  unsigned int has_bump;
  float specular;
  float spec_mult;
  float diffuse;

  int buffer_offset;

  int feature_flag;
};

bool has_feature(int feature_flag, enum object_feature_flag flag) {
  return (feature_flag & flag) > 0;
}

struct vertex {
  float4 pos;
  float4 normal;
  float2 vt;
  unsigned int object_id;
  unsigned int vertex_col;
};
struct triangle {
  struct vertex vertices[3];
};

float3 vertex_pos(global struct vertex* v) {
  return v->pos.xyz;
}

void set_tri_vertex(global struct triangle* T, int i, float3 pos) {
  T->vertices[hook(7, i)].pos.xyz = pos;
}

float3 reflect(float3 d, float3 n) {
  n = fast_normalize(n);

  float3 r = d - 2 * dot(d, n) * n;

  return r;
}

float calc_third_areas_i(float x1, float x2, float x3, float y1, float y2, float y3, float x, float y) {
  return (fabs(mad(x2, y, mad(x3, y2, x * y3) - mad(x3, y, mad(x, y2, x2 * y3)))) + fabs(mad(x, y1, mad(x3, y, x1 * y3) - mad(x3, y1, mad(x1, y, x * y3)))) + fabs(mad(x2, y1, mad(x, y2, x1 * y) - mad(x, y1, mad(x1, y2, x2 * y))))) * 0.5f;
}
float3 rot(const float3 point, const float3 c_pos, const float3 c_rot) {
  float3 c = native_cos(c_rot);
  float3 s = native_sin(c_rot);

  float3 rel = point - c_pos;

  float3 ret;

  ret.x = mad(c.y, (mad(s.z, rel.y, c.z * rel.x)), -s.y * rel.z);
  ret.y = mad(s.x, (mad(c.y, rel.z, s.y * (mad(s.z, rel.y, c.z * rel.x)))), c.x * (mad(c.z, rel.y, -s.z * rel.x)));
  ret.z = mad(c.x, (mad(c.y, rel.z, s.y * (mad(s.z, rel.y, c.z * rel.x)))), -s.x * (mad(c.z, rel.y, -s.z * rel.x)));
  return ret;
}

float3 back_rot(const float3 point, const float3 c_pos, const float3 c_rot) {
  float3 c = native_cos(c_rot);
  float3 s = native_sin(c_rot);
  float3 rel = point - c_pos;

  float3 ret;
  ret.x = c.z * (mad(c.y, rel.x, mad(s.x, s.y * rel.y, c.x * s.y * rel.z)))

          + s.z * (s.x * rel.z - c.x * rel.y);

  ret.y = mad(s.z, c.y * rel.x, mad(mad(c.x, c.z, s.x * s.y * s.z), rel.y, (mad(-s.x, c.z, c.x * s.y * s.z) * rel.z)));

  ret.z = mad(-s.y, rel.x, c.y * mad(s.x, rel.y, c.x * rel.z));

  return ret;
}

float3 rot_quat(const float3 point, float4 quat) {
  quat = fast_normalize(quat);

  float3 t = 2.f * cross(quat.xyz, point);

  return point + quat.w * t + cross(quat.xyz, t);
}

float3 back_rot_quat(const float3 point, const float4 quat) {
  float4 conj = quat;

  conj.xyz = -conj.xyz;

  float len_sq = dot(conj, conj);

  return rot_quat(point, conj / len_sq);
}
float dcalc(float value) {
  return native_divide(value, 350000.0f);
}

float idcalc(float value) {
  return value * 350000.0f;
}

float calc_rconstant(float x[3], float y[3]) {
  return native_recip(x[hook(4, 1)] * y[hook(5, 2)] + x[hook(4, 0)] * (y[hook(5, 1)] - y[hook(5, 2)]) - x[hook(4, 2)] * y[hook(5, 1)] + (x[hook(4, 2)] - x[hook(4, 1)]) * y[hook(5, 0)]);
}

float calc_rconstant_v(const float3 x, const float3 y) {
  return native_recip(x.y * y.z + x.x * (y.y - y.z) - x.z * y.y + (x.z - x.y) * y.x);
}

void interpolate_get_const(float3 f, float3 x, float3 y, float rconstant, float* A, float* B, float* C) {
  *A = ((f.y * y.z + f.x * (y.y - y.z) - f.z * y.y + (f.z - f.y) * y.x) * rconstant);
  *B = (-(f.y * x.z + f.x * (x.y - x.z) - f.z * x.y + (f.z - f.y) * x.x) * rconstant);
  *C = f.x - (*A) * x.x - (*B) * y.x;
}

void calc_min_max(float3 points[3], float width, float height, float ret[4]) {
  float x[3];
  float y[3];

  for (int i = 0; i < 3; i++) {
    x[hook(4, i)] = round(points[hook(8, i)].x);
    y[hook(5, i)] = round(points[hook(8, i)].y);
  }

  ret[hook(9, 0)] = min3(x[hook(4, 0)], x[hook(4, 1)], x[hook(4, 2)]) - 1;
  ret[hook(9, 1)] = max3(x[hook(4, 0)], x[hook(4, 1)], x[hook(4, 2)]);
  ret[hook(9, 2)] = min3(y[hook(5, 0)], y[hook(5, 1)], y[hook(5, 2)]) - 1;
  ret[hook(9, 3)] = max3(y[hook(5, 0)], y[hook(5, 1)], y[hook(5, 2)]);

  ret[hook(9, 0)] = clamp(ret[hook(9, 0)], 0.0f, width - 1);
  ret[hook(9, 1)] = clamp(ret[hook(9, 1)], 0.0f, width - 1);
  ret[hook(9, 2)] = clamp(ret[hook(9, 2)], 0.0f, height - 1);
  ret[hook(9, 3)] = clamp(ret[hook(9, 3)], 0.0f, height - 1);
}

float4 calc_min_max_p(float3 p0, float3 p1, float3 p2, float2 s) {
  p0 = round(p0);
  p1 = round(p1);
  p2 = round(p2);

  float4 ret;

  ret.x = min3(p0.x, p1.x, p2.x) - 1.f;
  ret.y = max3(p0.x, p1.x, p2.x);
  ret.z = min3(p0.y, p1.y, p2.y) - 1.f;
  ret.w = max3(p0.y, p1.y, p2.y);

  ret = clamp(ret, 0.f, s.xxyy - 1.f);

  return ret;
}

void calc_min_max_oc(float3 points[3], float mx, float my, float width, float height, float ret[4]) {
  float x[3];
  float y[3];

  for (int i = 0; i < 3; i++) {
    x[hook(4, i)] = round(points[hook(8, i)].x);
    y[hook(5, i)] = round(points[hook(8, i)].y);
  }

  ret[hook(9, 0)] = min3(x[hook(4, 0)], x[hook(4, 1)], x[hook(4, 2)]) - 1;
  ret[hook(9, 1)] = max3(x[hook(4, 0)], x[hook(4, 1)], x[hook(4, 2)]);
  ret[hook(9, 2)] = min3(y[hook(5, 0)], y[hook(5, 1)], y[hook(5, 2)]) - 1;
  ret[hook(9, 3)] = max3(y[hook(5, 0)], y[hook(5, 1)], y[hook(5, 2)]);

  ret[hook(9, 0)] = clamp(ret[hook(9, 0)], mx, width - 1);
  ret[hook(9, 1)] = clamp(ret[hook(9, 1)], mx, width - 1);
  ret[hook(9, 2)] = clamp(ret[hook(9, 2)], my, height - 1);
  ret[hook(9, 3)] = clamp(ret[hook(9, 3)], my, height - 1);
}

float3 get_flat_normal(float3 p0, float3 p1, float3 p2) {
  return cross(p1 - p0, p2 - p0);
}

int backface_cull_expanded(float3 p0, float3 p1, float3 p2) {
  return cross((p1 - p0), (p2 - p0)).z < 0.f;
}

float3 rot_with_offset(const float3 pos, const float3 c_pos, const float3 c_rot, const float3 offset, const float3 rotation_offset) {
  float3 intermediate = rot(pos, 0, rotation_offset);

  return rot(intermediate + offset, c_pos, c_rot);
}

float3 rot_quat_with_offset(float3 pos, float3 c_pos, float3 c_rot, float3 offset, float4 rotation_offset) {
  float3 intermediate = rot_quat(pos, rotation_offset);

  return rot(intermediate + offset, c_pos, c_rot);
}

void rot_3(global struct triangle* triangle, const float3 c_pos, const float3 c_rot, const float3 offset, const float3 rotation_offset, float3 ret[3]) {
  ret[hook(9, 0)] = rot(vertex_pos(&triangle->vertices[hook(10, 0)]), 0, rotation_offset);
  ret[hook(9, 1)] = rot(vertex_pos(&triangle->vertices[hook(10, 1)]), 0, rotation_offset);
  ret[hook(9, 2)] = rot(vertex_pos(&triangle->vertices[hook(10, 2)]), 0, rotation_offset);

  ret[hook(9, 0)] = rot(ret[hook(9, 0)] + offset, c_pos, c_rot);
  ret[hook(9, 1)] = rot(ret[hook(9, 1)] + offset, c_pos, c_rot);
  ret[hook(9, 2)] = rot(ret[hook(9, 2)] + offset, c_pos, c_rot);
}

void rot_3_raw(const float3 raw[3], const float3 rotation, float3 ret[3]) {
  ret[hook(9, 0)] = rot(raw[hook(11, 0)], 0, rotation);
  ret[hook(9, 1)] = rot(raw[hook(11, 1)], 0, rotation);
  ret[hook(9, 2)] = rot(raw[hook(11, 2)], 0, rotation);
}

void rot_3_pos(const float3 raw[3], const float3 pos, const float3 rotation, float3 ret[3]) {
  ret[hook(9, 0)] = rot(raw[hook(11, 0)], pos, rotation);
  ret[hook(9, 1)] = rot(raw[hook(11, 1)], pos, rotation);
  ret[hook(9, 2)] = rot(raw[hook(11, 2)], pos, rotation);
}

void depth_project(float3 rotated[3], float width, float height, float fovc, float3 ret[3]) {
  for (int i = 0; i < 3; i++) {
    float2 rxy = mad(rotated[hook(12, i)].xy, fovc / rotated[hook(12, i)].z, (float2){width / 2.f, height / 2.f});

    ret[hook(9, i)].xy = rxy;
    ret[hook(9, i)].z = rotated[hook(12, i)].z;
  }
}

float3 depth_project_singular(float3 rotated, float width, float height, float fovc) {
  float2 rxy = mad(rotated.xy, fovc / rotated.z, (float2){width / 2.f, height / 2.f});

  float3 ret;

  ret.xy = rxy;
  ret.z = rotated.z;

  return ret;
}

void generate_new_triangles(float3 points[3], int* num, float3 ret[2][3]) {
  int id_valid;
  int ids_behind[3];
  int n_behind = 0;

  for (int i = 0; i < 3; i++) {
    if (points[hook(8, i)].z <= 20 || points[hook(8, i)].z > 350000.0f) {
      ids_behind[hook(13, n_behind)] = i;
      n_behind++;
    } else {
      id_valid = i;
    }
  }

  if (n_behind > 2) {
    *num = 0;
    return;
  }

  float3 p1, p2, c1, c2;

  if (n_behind == 0) {
    ret[hook(9, 0)][hook(14, 0)] = points[hook(8, 0)];
    ret[hook(9, 0)][hook(14, 1)] = points[hook(8, 1)];
    ret[hook(9, 0)][hook(14, 2)] = points[hook(8, 2)];

    *num = 1;
    return;
  }

  int g1, g2, g3;

  if (n_behind == 1) {
    int id = ids_behind[hook(13, 0)];

    g1 = id;

    g2 = (id + 1) >= 3 ? id - 2 : id + 1;
    g3 = (id + 2) >= 3 ? id - 1 : id + 2;
  }

  if (n_behind == 2) {
    g2 = ids_behind[hook(13, 0)];
    g3 = ids_behind[hook(13, 1)];
    g1 = id_valid;
  }

  p1 = points[hook(8, g2)] + native_divide((20 - points[hook(8, g2)].z) * (points[hook(8, g1)] - points[hook(8, g2)]), points[hook(8, g1)].z - points[hook(8, g2)].z);
  p2 = points[hook(8, g3)] + native_divide((20 - points[hook(8, g3)].z) * (points[hook(8, g1)] - points[hook(8, g3)]), points[hook(8, g1)].z - points[hook(8, g3)].z);

  if (n_behind == 1) {
    c1 = points[hook(8, g2)];
    c2 = points[hook(8, g3)];

    ret[hook(9, 0)][hook(14, 0)] = p1;
    ret[hook(9, 0)][hook(14, 1)] = c1;
    ret[hook(9, 0)][hook(14, 2)] = c2;

    ret[hook(9, 1)][hook(15, 0)] = p1;
    ret[hook(9, 1)][hook(15, 1)] = c2;
    ret[hook(9, 1)][hook(15, 2)] = p2;
    *num = 2;
  } else {
    c1 = points[hook(8, g1)];
    ret[hook(9, 0)][hook(14, ids_behind[0hook(13, 0))] = p1;
    ret[hook(9, 0)][hook(14, ids_behind[1hook(13, 1))] = p2;
    ret[hook(9, 0)][hook(14, id_valid)] = c1;
    *num = 1;
  }
}

void full_rotate_n_extra(float3 v1, float3 v2, float3 v3, float3 passback[2][3], int* num, const float3 c_pos, const float3 c_rot, const float3 offset, const float3 rotation_offset, const float fovc, const float width, const float height) {
  float3 tris[2][3];

  float3 pr[3];

  pr[hook(16, 0)] = rot_with_offset(v1, c_pos, c_rot, offset, rotation_offset);
  pr[hook(16, 1)] = rot_with_offset(v2, c_pos, c_rot, offset, rotation_offset);
  pr[hook(16, 2)] = rot_with_offset(v3, c_pos, c_rot, offset, rotation_offset);

  int n = 0;

  generate_new_triangles(pr, &n, tris);

  *num = n;

  if (n == 0) {
    return;
  }

  depth_project(tris[hook(17, 0)], width, height, fovc, passback[hook(18, 0)]);

  if (n == 2) {
    depth_project(tris[hook(17, 1)], width, height, fovc, passback[hook(18, 1)]);
  }
}

void full_rotate_quat(float3 v1, float3 v2, float3 v3, float3 passback[2][3], int* num, float3 c_pos, float3 c_rot, float3 offset, float4 rotation_offset, float scale, float fovc, float width, float height) {
  float3 tris[2][3];

  float3 pr[3];

  pr[hook(16, 0)] = rot_quat_with_offset(v1 * scale, c_pos, c_rot, offset, rotation_offset);
  pr[hook(16, 1)] = rot_quat_with_offset(v2 * scale, c_pos, c_rot, offset, rotation_offset);
  pr[hook(16, 2)] = rot_quat_with_offset(v3 * scale, c_pos, c_rot, offset, rotation_offset);

  int n = 0;

  generate_new_triangles(pr, &n, tris);

  *num = n;

  if (n == 0) {
    return;
  }

  depth_project(tris[hook(17, 0)], width, height, fovc, passback[hook(18, 0)]);

  if (n == 2) {
    depth_project(tris[hook(17, 1)], width, height, fovc, passback[hook(18, 1)]);
  }
}

typedef global uchar4* image_3d_write;

typedef global uchar4* image_3d_read;

void write_image_3d_hardware(int4 coord, global uchar4* array, uint4 to_write, int width, int height)

{
  array[hook(3, coord.z * width * height + mul24(coord.y, width) + coord.x)] = convert_uchar4(to_write);
}

uint4 read_image_3d_hardware(int4 coord, global uchar4* array, int width, int height)

{
  return convert_uint4(array[hook(3, coord.z * width * height + mul24(coord.y, width) + coord.x)]);
}

float4 read_tex_array(float2 coords, unsigned int tid, global unsigned int* num, global unsigned int* size, image_3d_read array) {
  int nv = num[hook(19, tid)];

  int slice = nv >> 16;

  int which = nv & 0x0000FFFF;

  const float max_tex_size = 2048;

  float width = size[hook(20, slice)];

  float hnum = floor(native_divide(max_tex_size, width));

  float tnumy = floor(native_divide(which, hnum));
  float tnumx = mad(-tnumy, hnum, which);

  coords = clamp(coords, 0.001f, width - 0.001f);

  float2 res = mad((float2){tnumx, tnumy}, width, coords);

  int4 coord;
  coord.xy = convert_int2(res);
  coord.z = slice;

  uint4 col;
  col = read_image_3d_hardware(coord, array, max_tex_size, max_tex_size);

  float4 t = convert_float4(col);

  return t;
}

float4 read_tex_array_all_precalculated(float2 coord_absolute_coordinates, int which, int slice, float width, image_3d_read array) {
  float2 coords = coord_absolute_coordinates;

  const float max_tex_size = 2048;
  const float imax_tex_size = 1.f / 2048;

  float ihnum = width * imax_tex_size;

  float tnumy = floor(which * ihnum);
  float tnumx = which - tnumy / ihnum;

  coords = clamp(coords, 0.001f, width - 0.001f);

  float2 res = mad((float2){tnumx, tnumy}, width, coords);

  int4 coord;
  coord.xy = convert_int2(res);
  coord.z = slice;

  uint4 col;
  col = read_image_3d_hardware(coord, array, max_tex_size, max_tex_size);

  float4 t = convert_float4(col);

  return t;
}

void write_tex_array(uint4 to_write, float2 coords, unsigned int tid, global unsigned int* num, global unsigned int* size, image_3d_write array) {
  int nv = num[hook(19, tid)];

  int slice = nv >> 16;

  int which = nv & 0x0000FFFF;

  const float max_tex_size = 2048;

  float width = size[hook(20, slice)];

  float hnum = floor(native_divide(max_tex_size, width));

  float tnumy = floor(native_divide(which, hnum));
  float tnumx = mad(-tnumy, hnum, which);

  float tx = tnumx * width;
  float ty = tnumy * width;

  coords = fmod(coords, width);

  coords = clamp(coords, 0.001f, width - 0.001f);

  int4 coord = {tx + coords.x, ty + coords.y, slice, 0};

  write_image_3d_hardware(coord, array, to_write, max_tex_size, max_tex_size);
}

void blend_tex_array(uint4 to_write, float2 coords, unsigned int tid, global unsigned int* num, global unsigned int* size, image_3d_write array) {
  float4 ccol = read_tex_array(coords, tid, num, size, array) / 255.f;

  float4 b1 = convert_float4(to_write) / 255.f;
  float4 b2 = convert_float4(ccol) / 255.f;

  float3 pre1 = b1.xyz * b1.w;
  float3 pre2 = b2.xyz * b2.w;

  float4 res = (float4)(pre1.xyz + pre2 * (1.f - b1.w), 1.f) * 255.f;

  write_tex_array(convert_uint4(res), coords, tid, num, size, array);
}

kernel void write_col_to_tex(unsigned int tex_id, global unsigned int* nums, global unsigned int* sizes, image_3d_write array, int x, int y, float4 col) {
  if (get_global_id(0) > 1)
    return;

  uint4 ucol = convert_uint4(col * 255);

  int slice = nums[hook(1, tex_id)] >> 16;
  float width = sizes[hook(2, slice)];

  write_tex_array(ucol, (float2){x, y}, tex_id, nums, sizes, array);
}