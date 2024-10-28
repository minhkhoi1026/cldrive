//{"cam_pose_inv":12,"cam_pose_inv_p":3,"counter":9,"fl":2,"height":1,"m":11,"nmap_raycast":6,"nmap_sensor":7,"tsdf":10,"vcorresp":8,"vmap_raycast":4,"vmap_sensor":5,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct TsdfParams {
  float resolution[3];
  float volume[3];
  float mu;
};
bool _isnan3(float3 v) {
  return isnan(v.x) || isnan(v.y) || isnan(v.z);
}

bool _isnan4(float4 v) {
  return isnan(v.x) || isnan(v.y) || isnan(v.z) || isnan(v.w);
}

bool _isnan2(float2 v) {
  return isnan(v.x) || isnan(v.y);
}

void pack_tsdf(float val, float weight, global short2* tsdf, int idx) {
  short2 res = {convert_short(val * convert_float(32766)), convert_short(weight) - 32766};
  tsdf[hook(10, idx)] = res;
}

float2 unpack_tsdf(short2 tsdf) {
  float2 res = {convert_float(tsdf.x) / convert_float(32766), convert_float(tsdf.y) + convert_float(32766)};
  return res;
}

float4 mul(float4 m[4], float4 v) {
  float4 res = {m[hook(11, 0)].x * v.x + m[hook(11, 1)].x * v.y + m[hook(11, 2)].x * v.z + m[hook(11, 3)].x * v.w, m[hook(11, 0)].y * v.x + m[hook(11, 1)].y * v.y + m[hook(11, 2)].y * v.z + m[hook(11, 3)].y * v.w, m[hook(11, 0)].z * v.x + m[hook(11, 1)].z * v.y + m[hook(11, 2)].z * v.z + m[hook(11, 3)].z * v.w, m[hook(11, 0)].w * v.x + m[hook(11, 1)].w * v.y + m[hook(11, 2)].w * v.z + m[hook(11, 3)].w * v.w};
  return res;
}

float3 mul_homogenize(float4 m[4], float3 v) {
  float3 res = {m[hook(11, 0)].x * v.x + m[hook(11, 1)].x * v.y + m[hook(11, 2)].x * v.z + m[hook(11, 3)].x * 1.0f, m[hook(11, 0)].y * v.x + m[hook(11, 1)].y * v.y + m[hook(11, 2)].y * v.z + m[hook(11, 3)].y * 1.0f, m[hook(11, 0)].z * v.x + m[hook(11, 1)].z * v.y + m[hook(11, 2)].z * v.z + m[hook(11, 3)].z * 1.0f};
  return res;
}

float4 getVoxelGlobal(float voxel_x, float voxel_y, float voxel_z, float3 cellsize) {
  float4 voxel = {(voxel_x + 0.5f) * cellsize.x, (voxel_y + 0.5f) * cellsize.y, (voxel_z + 0.5f) * cellsize.z, 1.0f};
  return voxel;
}

bool isNull(float3 v) {
  return v.x == 0 && v.y == 0 && v.z == 0;
}
kernel void find_correspondences(global const int* width, global const int* height, global const float* fl, global const float4* cam_pose_inv_p, global const float3* vmap_raycast, global const float3* vmap_sensor, global const float3* nmap_raycast, global const float3* nmap_sensor, global float2* vcorresp, global unsigned int* counter) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  int w = *width;
  int h = *height;
  float focal_length = *fl;

  int idx = w * y + x;

  float3 v_tmp = vmap_raycast[hook(4, idx)];
  float4 v_prev = {v_tmp.x, v_tmp.y, v_tmp.z, 0.0f};

  if (!_isnan4(v_prev)) {
    float4 cam_pose_inv[4] = {cam_pose_inv_p[hook(3, 0)], cam_pose_inv_p[hook(3, 1)], cam_pose_inv_p[hook(3, 2)], cam_pose_inv_p[hook(3, 3)]};

    float4 v_prev_cs = v_prev + cam_pose_inv[hook(12, 3)];
    v_prev_cs.w = 0.0f;
    v_prev_cs = mul(cam_pose_inv, v_prev_cs);

    float2 p = {focal_length * v_prev_cs.x / v_prev_cs.z + convert_float(w) / 2.0f, focal_length * v_prev_cs.y / v_prev_cs.z + convert_float(h) / 2.0f};

    int px = round(p.x);
    int py = round(p.y);

    if (px >= 0.0f && py >= 0.0f && px < w && py < h) {
      float3 v_corresp_tmp = vmap_sensor[hook(5, w * py + px)];

      if (!_isnan3(v_corresp_tmp)) {
        float4 v_corresp_cs = {v_corresp_tmp.x, v_corresp_tmp.y, v_corresp_tmp.z, 1.0f};

        float4 diff = v_corresp_cs - v_prev_cs;
        float dist = sqrt(diff.x * diff.x + diff.y * diff.y + diff.z * diff.z);

        float3 norm_rc = nmap_raycast[hook(6, idx)];
        float4 norm_rc_4 = {norm_rc.x, norm_rc.y, norm_rc.z, 0.0f};
        float4 rot_norm_4 = mul(cam_pose_inv, norm_rc_4);
        float3 rot_norm = {rot_norm_4.x, rot_norm_4.y, rot_norm_4.z};
        float3 norm_s = nmap_sensor[hook(7, w * py + px)];

        if (dist < 10.0f && fabs((float)dot(normalize(rot_norm), norm_s)) > 0.006092310f) {
          vcorresp[hook(8, idx)].x = px;
          vcorresp[hook(8, idx)].y = py;

          return;
        }
      }
    }
  }
  vcorresp[hook(8, idx)].x = __builtin_astype((2147483647), float);
  vcorresp[hook(8, idx)].y = __builtin_astype((2147483647), float);
}