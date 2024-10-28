//{"F":0,"cam_pos_inv":3,"cam_pos_inv_l":12,"dmap":4,"fl":6,"height":2,"k":5,"l_params.resolution":10,"l_params.volume":11,"m":9,"params":7,"tsdf":8,"width":1}
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
  tsdf[hook(8, idx)] = res;
}

float2 unpack_tsdf(short2 tsdf) {
  float2 res = {convert_float(tsdf.x) / convert_float(32766), convert_float(tsdf.y) + convert_float(32766)};
  return res;
}

float4 mul(float4 m[4], float4 v) {
  float4 res = {m[hook(9, 0)].x * v.x + m[hook(9, 1)].x * v.y + m[hook(9, 2)].x * v.z + m[hook(9, 3)].x * v.w, m[hook(9, 0)].y * v.x + m[hook(9, 1)].y * v.y + m[hook(9, 2)].y * v.z + m[hook(9, 3)].y * v.w, m[hook(9, 0)].z * v.x + m[hook(9, 1)].z * v.y + m[hook(9, 2)].z * v.z + m[hook(9, 3)].z * v.w, m[hook(9, 0)].w * v.x + m[hook(9, 1)].w * v.y + m[hook(9, 2)].w * v.z + m[hook(9, 3)].w * v.w};
  return res;
}

float3 mul_homogenize(float4 m[4], float3 v) {
  float3 res = {m[hook(9, 0)].x * v.x + m[hook(9, 1)].x * v.y + m[hook(9, 2)].x * v.z + m[hook(9, 3)].x * 1.0f, m[hook(9, 0)].y * v.x + m[hook(9, 1)].y * v.y + m[hook(9, 2)].y * v.z + m[hook(9, 3)].y * 1.0f, m[hook(9, 0)].z * v.x + m[hook(9, 1)].z * v.y + m[hook(9, 2)].z * v.z + m[hook(9, 3)].z * 1.0f};
  return res;
}

float4 getVoxelGlobal(float voxel_x, float voxel_y, float voxel_z, float3 cellsize) {
  float4 voxel = {(voxel_x + 0.5f) * cellsize.x, (voxel_y + 0.5f) * cellsize.y, (voxel_z + 0.5f) * cellsize.z, 1.0f};
  return voxel;
}

bool isNull(float3 v) {
  return v.x == 0 && v.y == 0 && v.z == 0;
}
kernel void TSDF(global short2* F, global const int* width, global const int* height,

                 global float4* cam_pos_inv, global ushort* dmap, global ulong* k, global const float* fl, constant struct TsdfParams* params) {
  const int voxel_x = get_global_id(0);
  const int voxel_y = get_global_id(1);
  float focal_length = *fl;

  float4 cam_pos_inv_l[4] = {cam_pos_inv[hook(3, 0)], cam_pos_inv[hook(3, 1)], cam_pos_inv[hook(3, 2)], cam_pos_inv[hook(3, 3)]};
  int w = *width;
  int h = *height;

  struct TsdfParams l_params = *params;

  int3 resolution = {convert_int(l_params.resolution[hook(10, 0)]), convert_int(l_params.resolution[hook(10, 1)]), convert_int(l_params.resolution[hook(10, 2)])};
  float mu = l_params.mu;

  float3 cellsize = {l_params.volume[hook(11, 0)] / l_params.resolution[hook(10, 0)], l_params.volume[hook(11, 1)] / l_params.resolution[hook(10, 1)], l_params.volume[hook(11, 2)] / l_params.resolution[hook(10, 2)]};

  int xyIdx = voxel_x * resolution.z + voxel_y * resolution.x * resolution.z;

  float4 voxel0 = getVoxelGlobal(convert_float(voxel_x), convert_float(voxel_y), 0.0f, cellsize);
  voxel0.x -= l_params.volume[hook(11, 0)] / 2.0f;
  voxel0.y -= l_params.volume[hook(11, 1)] / 2.0f;
  voxel0.w = 0.0f;

  float4 baseVoxel = voxel0 + cam_pos_inv_l[hook(12, 3)];
  baseVoxel.z = 0.0f;
  baseVoxel.w = 0.0f;
  baseVoxel = mul(cam_pos_inv_l, baseVoxel);

  for (int voxel_z = 0; voxel_z < resolution.z; voxel_z++) {
    float voxel_z_g = (convert_float(voxel_z) + 0.5f) * cellsize.z;

    float4 voxel_c = {baseVoxel.x + cam_pos_inv_l[hook(12, 2)].x * (voxel_z_g + cam_pos_inv_l[hook(12, 3)].z), baseVoxel.y + cam_pos_inv_l[hook(12, 2)].y * (voxel_z_g + cam_pos_inv_l[hook(12, 3)].z), baseVoxel.z + cam_pos_inv_l[hook(12, 2)].z * (voxel_z_g + cam_pos_inv_l[hook(12, 3)].z), baseVoxel.w + cam_pos_inv_l[hook(12, 2)].w * (voxel_z_g + cam_pos_inv_l[hook(12, 3)].z)};

    int2 pix = {convert_int((voxel_c.x / voxel_c.z) * focal_length + convert_float(w) / 2.0f), convert_int((voxel_c.y / voxel_c.z) * focal_length + convert_float(h) / 2.0f)};
    int idx = voxel_z + xyIdx;

    if (pix.x >= 0 && pix.y >= 0 && pix.x < w && pix.y < h && idx >= 0 && idx < resolution.x * resolution.y * resolution.z) {
      ushort depth = dmap[hook(4, pix.y * w + pix.x)];

      if (depth != 0) {
        float x = (convert_float(pix.x) - convert_float(w) / 2.0f) / focal_length;
        float y = (convert_float(pix.y) - convert_float(h) / 2.0f) / focal_length;
        float lambda_inv = sqrt(x * x + y * y + 1.0f);

        float3 voxel3_c = {voxel_c.x, voxel_c.y, voxel_c.z};

        float dist = sqrt(voxel3_c.x * voxel3_c.x + voxel3_c.y * voxel3_c.y + voxel3_c.z * voxel3_c.z);
        float arg = convert_float(depth) - dist / lambda_inv;

        if (arg >= -mu) {
          float F_Rk = arg / mu;
          F_Rk = max(-1.0f, min(1.0f, F_Rk));

          float2 cur_val = unpack_tsdf(F[hook(0, idx)]);
          float weight = cur_val.y;
          if (weight < convert_float(32766 * 2)) {
            float val = ((weight * cur_val.x) + F_Rk) / (weight + 1.0f);
            pack_tsdf(max(-1.0f, min(1.0f, val)), weight + 1.0f, F, idx);
          }
        }
      }
    }
  }
}