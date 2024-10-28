//{"T->vertices":7,"array":21,"camera_pos":5,"camera_rot":6,"colours":27,"coords":26,"depth_buffer":0,"ids_behind":15,"lights":4,"lnum":3,"mgauss":29,"mgauss[j + 1]":28,"num":22,"nums":24,"passback":20,"points":10,"pr":18,"raw":13,"ret":11,"ret[0]":16,"ret[1]":17,"rotated":14,"screen_in":1,"screen_out":2,"size":23,"sizes":25,"triangle->vertices":12,"tris":19,"x":8,"y":9}
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
  return native_recip(x[hook(8, 1)] * y[hook(9, 2)] + x[hook(8, 0)] * (y[hook(9, 1)] - y[hook(9, 2)]) - x[hook(8, 2)] * y[hook(9, 1)] + (x[hook(8, 2)] - x[hook(8, 1)]) * y[hook(9, 0)]);
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
    x[hook(8, i)] = round(points[hook(10, i)].x);
    y[hook(9, i)] = round(points[hook(10, i)].y);
  }

  ret[hook(11, 0)] = min3(x[hook(8, 0)], x[hook(8, 1)], x[hook(8, 2)]) - 1;
  ret[hook(11, 1)] = max3(x[hook(8, 0)], x[hook(8, 1)], x[hook(8, 2)]);
  ret[hook(11, 2)] = min3(y[hook(9, 0)], y[hook(9, 1)], y[hook(9, 2)]) - 1;
  ret[hook(11, 3)] = max3(y[hook(9, 0)], y[hook(9, 1)], y[hook(9, 2)]);

  ret[hook(11, 0)] = clamp(ret[hook(11, 0)], 0.0f, width - 1);
  ret[hook(11, 1)] = clamp(ret[hook(11, 1)], 0.0f, width - 1);
  ret[hook(11, 2)] = clamp(ret[hook(11, 2)], 0.0f, height - 1);
  ret[hook(11, 3)] = clamp(ret[hook(11, 3)], 0.0f, height - 1);
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
    x[hook(8, i)] = round(points[hook(10, i)].x);
    y[hook(9, i)] = round(points[hook(10, i)].y);
  }

  ret[hook(11, 0)] = min3(x[hook(8, 0)], x[hook(8, 1)], x[hook(8, 2)]) - 1;
  ret[hook(11, 1)] = max3(x[hook(8, 0)], x[hook(8, 1)], x[hook(8, 2)]);
  ret[hook(11, 2)] = min3(y[hook(9, 0)], y[hook(9, 1)], y[hook(9, 2)]) - 1;
  ret[hook(11, 3)] = max3(y[hook(9, 0)], y[hook(9, 1)], y[hook(9, 2)]);

  ret[hook(11, 0)] = clamp(ret[hook(11, 0)], mx, width - 1);
  ret[hook(11, 1)] = clamp(ret[hook(11, 1)], mx, width - 1);
  ret[hook(11, 2)] = clamp(ret[hook(11, 2)], my, height - 1);
  ret[hook(11, 3)] = clamp(ret[hook(11, 3)], my, height - 1);
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
  ret[hook(11, 0)] = rot(vertex_pos(&triangle->vertices[hook(12, 0)]), 0, rotation_offset);
  ret[hook(11, 1)] = rot(vertex_pos(&triangle->vertices[hook(12, 1)]), 0, rotation_offset);
  ret[hook(11, 2)] = rot(vertex_pos(&triangle->vertices[hook(12, 2)]), 0, rotation_offset);

  ret[hook(11, 0)] = rot(ret[hook(11, 0)] + offset, c_pos, c_rot);
  ret[hook(11, 1)] = rot(ret[hook(11, 1)] + offset, c_pos, c_rot);
  ret[hook(11, 2)] = rot(ret[hook(11, 2)] + offset, c_pos, c_rot);
}

void rot_3_raw(const float3 raw[3], const float3 rotation, float3 ret[3]) {
  ret[hook(11, 0)] = rot(raw[hook(13, 0)], 0, rotation);
  ret[hook(11, 1)] = rot(raw[hook(13, 1)], 0, rotation);
  ret[hook(11, 2)] = rot(raw[hook(13, 2)], 0, rotation);
}

void rot_3_pos(const float3 raw[3], const float3 pos, const float3 rotation, float3 ret[3]) {
  ret[hook(11, 0)] = rot(raw[hook(13, 0)], pos, rotation);
  ret[hook(11, 1)] = rot(raw[hook(13, 1)], pos, rotation);
  ret[hook(11, 2)] = rot(raw[hook(13, 2)], pos, rotation);
}

void depth_project(float3 rotated[3], float width, float height, float fovc, float3 ret[3]) {
  for (int i = 0; i < 3; i++) {
    float2 rxy = mad(rotated[hook(14, i)].xy, fovc / rotated[hook(14, i)].z, (float2){width / 2.f, height / 2.f});

    ret[hook(11, i)].xy = rxy;
    ret[hook(11, i)].z = rotated[hook(14, i)].z;
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
    if (points[hook(10, i)].z <= 20 || points[hook(10, i)].z > 350000.0f) {
      ids_behind[hook(15, n_behind)] = i;
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
    ret[hook(11, 0)][hook(16, 0)] = points[hook(10, 0)];
    ret[hook(11, 0)][hook(16, 1)] = points[hook(10, 1)];
    ret[hook(11, 0)][hook(16, 2)] = points[hook(10, 2)];

    *num = 1;
    return;
  }

  int g1, g2, g3;

  if (n_behind == 1) {
    int id = ids_behind[hook(15, 0)];

    g1 = id;

    g2 = (id + 1) >= 3 ? id - 2 : id + 1;
    g3 = (id + 2) >= 3 ? id - 1 : id + 2;
  }

  if (n_behind == 2) {
    g2 = ids_behind[hook(15, 0)];
    g3 = ids_behind[hook(15, 1)];
    g1 = id_valid;
  }

  p1 = points[hook(10, g2)] + native_divide((20 - points[hook(10, g2)].z) * (points[hook(10, g1)] - points[hook(10, g2)]), points[hook(10, g1)].z - points[hook(10, g2)].z);
  p2 = points[hook(10, g3)] + native_divide((20 - points[hook(10, g3)].z) * (points[hook(10, g1)] - points[hook(10, g3)]), points[hook(10, g1)].z - points[hook(10, g3)].z);

  if (n_behind == 1) {
    c1 = points[hook(10, g2)];
    c2 = points[hook(10, g3)];

    ret[hook(11, 0)][hook(16, 0)] = p1;
    ret[hook(11, 0)][hook(16, 1)] = c1;
    ret[hook(11, 0)][hook(16, 2)] = c2;

    ret[hook(11, 1)][hook(17, 0)] = p1;
    ret[hook(11, 1)][hook(17, 1)] = c2;
    ret[hook(11, 1)][hook(17, 2)] = p2;
    *num = 2;
  } else {
    c1 = points[hook(10, g1)];
    ret[hook(11, 0)][hook(16, ids_behind[0hook(15, 0))] = p1;
    ret[hook(11, 0)][hook(16, ids_behind[1hook(15, 1))] = p2;
    ret[hook(11, 0)][hook(16, id_valid)] = c1;
    *num = 1;
  }
}

void full_rotate_n_extra(float3 v1, float3 v2, float3 v3, float3 passback[2][3], int* num, const float3 c_pos, const float3 c_rot, const float3 offset, const float3 rotation_offset, const float fovc, const float width, const float height) {
  float3 tris[2][3];

  float3 pr[3];

  pr[hook(18, 0)] = rot_with_offset(v1, c_pos, c_rot, offset, rotation_offset);
  pr[hook(18, 1)] = rot_with_offset(v2, c_pos, c_rot, offset, rotation_offset);
  pr[hook(18, 2)] = rot_with_offset(v3, c_pos, c_rot, offset, rotation_offset);

  int n = 0;

  generate_new_triangles(pr, &n, tris);

  *num = n;

  if (n == 0) {
    return;
  }

  depth_project(tris[hook(19, 0)], width, height, fovc, passback[hook(20, 0)]);

  if (n == 2) {
    depth_project(tris[hook(19, 1)], width, height, fovc, passback[hook(20, 1)]);
  }
}

void full_rotate_quat(float3 v1, float3 v2, float3 v3, float3 passback[2][3], int* num, float3 c_pos, float3 c_rot, float3 offset, float4 rotation_offset, float scale, float fovc, float width, float height) {
  float3 tris[2][3];

  float3 pr[3];

  pr[hook(18, 0)] = rot_quat_with_offset(v1 * scale, c_pos, c_rot, offset, rotation_offset);
  pr[hook(18, 1)] = rot_quat_with_offset(v2 * scale, c_pos, c_rot, offset, rotation_offset);
  pr[hook(18, 2)] = rot_quat_with_offset(v3 * scale, c_pos, c_rot, offset, rotation_offset);

  int n = 0;

  generate_new_triangles(pr, &n, tris);

  *num = n;

  if (n == 0) {
    return;
  }

  depth_project(tris[hook(19, 0)], width, height, fovc, passback[hook(20, 0)]);

  if (n == 2) {
    depth_project(tris[hook(19, 1)], width, height, fovc, passback[hook(20, 1)]);
  }
}

typedef global uchar4* image_3d_write;

typedef global uchar4* image_3d_read;

void write_image_3d_hardware(int4 coord, global uchar4* array, uint4 to_write, int width, int height)

{
  array[hook(21, coord.z * width * height + mul24(coord.y, width) + coord.x)] = convert_uchar4(to_write);
}

uint4 read_image_3d_hardware(int4 coord, global uchar4* array, int width, int height)

{
  return convert_uint4(array[hook(21, coord.z * width * height + mul24(coord.y, width) + coord.x)]);
}

float4 read_tex_array(float2 coords, unsigned int tid, global unsigned int* num, global unsigned int* size, image_3d_read array) {
  int nv = num[hook(22, tid)];

  int slice = nv >> 16;

  int which = nv & 0x0000FFFF;

  const float max_tex_size = 2048;

  float width = size[hook(23, slice)];

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
  int nv = num[hook(22, tid)];

  int slice = nv >> 16;

  int which = nv & 0x0000FFFF;

  const float max_tex_size = 2048;

  float width = size[hook(23, slice)];

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

float noise(int x) {
  int n = x * 271;

  n = (n << 13) ^ n;

  int nn = (n * (n * n * 41333 + 53307781) + 1376312589) & 0x7fffffff;

  return ((1.0f - ((float)nn / 1073741824.0f)));
}

float4 return_bilinear_col(float2 coord, unsigned int tid, global unsigned int* nums, global unsigned int* sizes, image_3d_read array) {
  int compound = nums[hook(24, tid)];
  float width = sizes[hook(25, compound >> 16)];

  float2 mcoord = coord * width;

  float2 coords[4];

  float2 pos = floor(mcoord);

  coords[hook(26, 0)].x = pos.x, coords[hook(26, 0)].y = pos.y;
  coords[hook(26, 1)].x = pos.x + 1, coords[hook(26, 1)].y = pos.y;
  coords[hook(26, 2)].x = pos.x, coords[hook(26, 2)].y = pos.y + 1;
  coords[hook(26, 3)].x = pos.x + 1, coords[hook(26, 3)].y = pos.y + 1;

  float4 colours[4];

  for (int i = 0; i < 4; i++) {
    colours[hook(27, i)] = read_tex_array(coords[hook(26, i)], tid, nums, sizes, array);
  }

  float2 uvratio = mcoord - pos;

  float2 buvr = 1.f - uvratio;

  float4 result;

  result = mad(colours[hook(27, 0)], buvr.x, colours[hook(27, 1)] * uvratio.x) * buvr.y + mad(colours[hook(27, 2)], buvr.x, colours[hook(27, 3)] * uvratio.x) * uvratio.y;

  return result;
}

float4 return_bilinear_col_all_precalculated(float2 coord_absolute_coordinates, int which, int slice, float width, image_3d_read array) {
  float2 mcoord = coord_absolute_coordinates;

  float2 coords[4];

  float2 pos = floor(mcoord);

  coords[hook(26, 0)].x = pos.x, coords[hook(26, 0)].y = pos.y;
  coords[hook(26, 1)].x = pos.x + 1, coords[hook(26, 1)].y = pos.y;
  coords[hook(26, 2)].x = pos.x, coords[hook(26, 2)].y = pos.y + 1;
  coords[hook(26, 3)].x = pos.x + 1, coords[hook(26, 3)].y = pos.y + 1;

  float4 colours[4];

  for (int i = 0; i < 4; i++) {
    colours[hook(27, i)] = read_tex_array_all_precalculated(coords[hook(26, i)], which, slice, width, array);
  }

  float2 uvratio = mcoord - pos;

  float2 buvr = 1.f - uvratio;

  float4 result;

  result = mad(colours[hook(27, 0)], buvr.x, colours[hook(27, 1)] * uvratio.x) * buvr.y + mad(colours[hook(27, 2)], buvr.x, colours[hook(27, 3)] * uvratio.x) * uvratio.y;

  return result;
}

float2 texture_mod(float2 in) {
  float2 vtm = in;

  vtm.x = vtm.x >= 1 ? 1.0f - (vtm.x - floor(vtm.x)) : vtm.x;
  vtm.y = vtm.y >= 1 ? 1.0f - (vtm.y - floor(vtm.y)) : vtm.y;

  vtm.x = vtm.x < 0 ? 1.0f + fabs(vtm.x) - fabs(floor(vtm.x)) : vtm.x;
  vtm.y = vtm.y < 0 ? 1.0f + fabs(vtm.y) - fabs(floor(vtm.y)) : vtm.y;

  return vtm;
}

float4 texture_filter_direct(float2 vt, float direct_interpolating_factor, int tid2, unsigned int mip_start, global unsigned int* nums, global unsigned int* sizes, image_3d_read array) {
  int slice = nums[hook(24, tid2)] >> 16;
  int tsize = sizes[hook(25, slice)];

  float2 vtm = texture_mod(vt);

  float fmd = direct_interpolating_factor - (int)direct_interpolating_factor;

  float mip_lower = (int)direct_interpolating_factor;

  int tid_lower = mip_lower == 0 ? tid2 : mip_lower - 1 + mip_start + mul24(tid2, 4);
  int tid_higher = clamp(mip_lower, 0.f, 4 - 1.f) + mip_start + mul24(tid2, 4);

  vtm.x -= 0.5f / tsize;

  float4 col1 = return_bilinear_col(vtm, tid_lower, nums, sizes, array);
  float4 col2 = return_bilinear_col(vtm, tid_higher, nums, sizes, array);

  float4 finalcol = col1 * (1.f - fmd) + col2 * (fmd);

  return native_divide(finalcol, 255.0f);
}

float log2_approx(float val) {
  union {
    float val;
    int x;
  } u = {val};
  float log_2 = (float)(((u.x >> 23) & 255) - 128);
  u.x &= ~(255 << 23);
  u.x += 127 << 23;
  log_2 += ((-0.3358287811f) * u.val + 2.0f) * u.val - 0.65871759316667f;
  return (log_2);
}

float4 texture_filter_diff(float2 vt, float2 vtdiff, int tid2, unsigned int mip_start, global unsigned int* nums, global unsigned int* sizes, image_3d_read array) {
  int nv = nums[hook(24, tid2)];

  int slice = nv >> 16;

  int tsize = sizes[hook(25, slice)];

  float2 vtm = texture_mod(vt);

  float worst = fast_length(vtdiff * tsize);

  float worst_id_frac = log2_approx(worst);

  worst_id_frac = max(worst_id_frac, 0.f);

  float mip_lower = floor(worst_id_frac);

  mip_lower = clamp(mip_lower, 0.f, (float)4);

  float fmd = worst_id_frac - mip_lower;

  int tid_lower = mip_lower == 0 ? tid2 : mip_lower - 1 + mip_start + mul24(tid2, 4);
  int tid_higher = clamp(mip_lower, 0.f, 4 - 1.f) + mip_start + mul24(tid2, 4);
  int lower_nv = nums[hook(24, tid_lower)];
  int higher_nv = nums[hook(24, tid_higher)];

  int slice_lower = lower_nv >> 16;
  int slice_higher = higher_nv >> 16;

  int which_lower = lower_nv & 0x0000FFFF;
  int which_higher = higher_nv & 0x0000FFFF;

  float size_lower = sizes[hook(25, slice_lower)];
  float size_higher = sizes[hook(25, slice_higher)];

  float4 col1 = return_bilinear_col_all_precalculated(vtm * size_lower, which_lower, slice_lower, size_lower, array);
  float4 col2 = return_bilinear_col_all_precalculated(vtm * size_higher, which_higher, slice_higher, size_higher, array);

  float4 final_col = mix(col1, col2, fmd);

  const float i255 = 1.f / 255.f;

  return final_col * i255;
}

float4 texture_filter_diff_with_anisotropy(float2 vt, float2 vtdiff, int tid2, unsigned int mip_start, global unsigned int* nums, global unsigned int* sizes, image_3d_read array) {
  int slice = nums[hook(24, tid2)] >> 16;
  int tsize = sizes[hook(25, slice)];

  float2 vtm = vt;

  vtm.x = vtm.x >= 1 ? 1.0f - (vtm.x - floor(vtm.x)) : vtm.x;
  vtm.x = vtm.x < 0 ? 1.0f + fabs(vtm.x) - fabs(floor(vtm.x)) : vtm.x;

  vtm.y = vtm.y >= 1 ? 1.0f - (vtm.y - floor(vtm.y)) : vtm.y;
  vtm.y = vtm.y < 0 ? 1.0f + fabs(vtm.y) - fabs(floor(vtm.y)) : vtm.y;

  float2 texture_diff = fabs(vtdiff) * tsize;

  float2 worst_id_frac = native_log2(texture_diff);
  float worst_id_frac_naive = native_log2(fast_length(texture_diff));

  worst_id_frac = max(worst_id_frac, 0.f);
  worst_id_frac_naive = max(worst_id_frac_naive, 0.f);

  float2 mip_lower = floor(worst_id_frac);
  float mip_lower_naive = floor(worst_id_frac_naive);

  mip_lower = clamp(mip_lower, 0.f, (float)4);
  mip_lower_naive = clamp(mip_lower_naive, 0.f, (float)4);

  float lower_vtd_miplevel = min(mip_lower.x, mip_lower.y);
  float worst_vtd_miplevel = max(mip_lower.x, mip_lower.y);

  {
    lower_vtd_miplevel = worst_vtd_miplevel - 1;

    lower_vtd_miplevel = clamp(lower_vtd_miplevel, 0.f, (float)4);

    lower_vtd_miplevel = max(worst_vtd_miplevel, lower_vtd_miplevel);

    lower_vtd_miplevel = clamp(lower_vtd_miplevel, 0.f, (float)4);

    lower_vtd_miplevel = floor(lower_vtd_miplevel);
  }

  int tid_lower_vtd_miplevel = lower_vtd_miplevel == 0 ? tid2 : lower_vtd_miplevel - 1 + mip_start + mul24(tid2, 4);

  float2 fmd = worst_id_frac - lower_vtd_miplevel;
  float fmd_naive = worst_id_frac_naive - mip_lower_naive;

  float aniso = fabs(fmd.x - fmd.y);

  fmd = clamp(fmd, 0.f, 1.f);

  float bound = 0.2f;

  if (0)
    if (fmd.x < bound && fmd.y < bound) {
      int tid_lower = mip_lower_naive == 0 ? tid2 : mip_lower_naive - 1 + mip_start + mul24(tid2, 4);
      int tid_higher = clamp(mip_lower_naive, 0.f, 4 - 1.f) + mip_start + mul24(tid2, 4);

      float4 col1 = return_bilinear_col(vtm, tid_lower, nums, sizes, array);
      float4 col2 = return_bilinear_col(vtm, tid_higher, nums, sizes, array);

      float4 finalcol = col1 * (1.0f - fast_length(fmd_naive)) + col2 * fast_length(fmd_naive);

      return native_divide(finalcol, 255.0f);
    }

  fmd = clamp(fmd, 0.f, 1.f);

  fmd = 1.f - fmd;

  const float gauss[3][3] = {{1, 2, 1}, {2, 4, 2}, {1, 2, 1}};

  const float mgauss[3][3] = {{fmd.x * fmd.y, 2 * fmd.y, fmd.x * fmd.y}, {2 * fmd.x, 4, 2 * fmd.x}, {fmd.x * fmd.y, 2 * fmd.y, fmd.x * fmd.y}};

  float div = 0.f;

  float4 caccum = 0;

  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      float gval = mgauss[hook(29, j + 1)][hook(28, i + 1)];

      float4 col = return_bilinear_col(vtm + (float2){i, j} / tsize, tid_lower_vtd_miplevel, nums, sizes, array);

      caccum += col * gval;

      div += gval;
    }
  }

  float4 high_res_col = return_bilinear_col(vtm, tid_lower_vtd_miplevel, nums, sizes, array);

  float4 c2 = high_res_col / 255.f;

  caccum /= div;
  caccum /= 255.f;

  return caccum + (float4)(fmd.xy, 0, 0) / 4.f;
}

float4 alpha_blend(float4 fc1, float4 fc2) {
  float3 col = mad(fc1.xyz, fc1.w, fc2.xyz * (1.f - fc1.w));

  float4 acol = (float4)(col.xyz, fc1.w);

  return acol;
}
int ret_cubeface(float3 point, float3 light) {
  float3 rel = point - light;

  float3 arel = fabs(rel);

  if (arel.x >= arel.y && arel.x >= arel.z) {
    return rel.x < 0 ? 4 : 5;
  }

  if (arel.y > arel.x && arel.y >= arel.z) {
    return rel.y < 0 ? 1 : 3;
  }

  if (arel.z > arel.x && arel.z > arel.y) {
    if (rel.z < 0)
      return 2;
  }

  return 0;
}

kernel void screenspace_godrays(global unsigned int* depth_buffer, read_only image2d_t screen_in, write_only image2d_t screen_out, global unsigned int* lnum, global struct light* lights, float4 camera_pos, float4 camera_rot) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x >= 1080 || y >= 1920)
    return;

  float samples = 80.f;

  sampler_t sam = 0 | 2 | 0x20;

  global unsigned int* ft = &depth_buffer[hook(0, y * 1080 + x)];

  unsigned int my_depth = *ft;
  float4 my_col = read_imagef(screen_in, sam, (float2){x, y} - 0.25f);

  const float decay_factor = 0.97f;
  const float weight = 0.01f;

  float2 spos = {x, y};

  float max_length = 400.f;

  for (int i = 0; i < *lnum; i++) {
    float ray_intensity = lights[hook(4, i)].godray_intensity;

    if (ray_intensity <= 0) {
      continue;
    }

    float idecay = 1.f;

    float3 iter_col = 0;

    float3 lpos = lights[hook(4, i)].pos.xyz;

    float3 slpos = rot(lpos, camera_pos.xyz, camera_rot.xyz);

    slpos = depth_project_singular(slpos, 1080, 1920, 500.0f);

    float screen_distance = fast_length(slpos.xy - spos);

    screen_distance = min(screen_distance, samples);

    float3 current_pos = {x, y, idcalc((float)my_depth / 0xffffffff)};
    float3 destination_pos = slpos;

    float3 original = current_pos;

    if (slpos.z < 0) {
      destination_pos = (current_pos - destination_pos) + current_pos;
    }

    float2 vdist = current_pos.xy - destination_pos.xy;

    vdist = fabs(vdist);

    float mnum = vdist.x > vdist.y ? vdist.x : vdist.y;

    float3 dir = (destination_pos - current_pos) / mnum;

    dir *= max_length / samples;

    float3 col = lights[hook(4, i)].col.xyz;

    for (int j = 0; j < mnum && j < samples; j++) {
      if (any(current_pos.xy < 0) || any(current_pos.xy >= (float2){1080, 1920} - 1))
        continue;

      unsigned int cdepth = depth_buffer[hook(0, ((int)current_pos.y) * 1080 + (int)current_pos.x)];

      float fdepth = idcalc((float)cdepth / 0xffffffff);

      float3 val = 0;

      if (fdepth < original.z - 5 && cdepth != 0xffffffff) {
        idecay *= 0.9f;

        val = col * ray_intensity;
      }

      val = val * idecay * weight;

      iter_col += val;

      idecay *= decay_factor;

      current_pos = current_pos + dir;
    }

    my_col.xyz += iter_col.xyz;
  }

  my_col.w = 1;

  const float exposure = 0.99f;

  write_imagef(screen_out, (int2){x, y}, my_col * exposure);
}