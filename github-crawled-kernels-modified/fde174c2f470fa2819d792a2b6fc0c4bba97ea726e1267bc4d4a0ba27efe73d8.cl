//{"cxy":12,"depth_cols":10,"depth_offset":8,"depth_rows":9,"depth_step":7,"depthptr":6,"dfac":13,"fxyinv":11,"normals_offset":5,"normals_step":4,"normalsptr":3,"points_offset":2,"points_step":1,"pointsptr":0,"row0":14,"row1":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float3 reproject(float3 p, float2 fxyinv, float2 cxy) {
  float2 pp = p.z * (p.xy - cxy) * fxyinv;
  return (float3)(pp, p.z);
}

typedef float4 float4;

kernel void computePointsNormals(global char* pointsptr, int points_step, int points_offset, global char* normalsptr, int normals_step, int normals_offset, global const char* depthptr, int depth_step, int depth_offset, int depth_rows, int depth_cols, const float2 fxyinv, const float2 cxy, const float dfac) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x >= depth_cols || y >= depth_rows)
    return;

  global const float* row0 = (global const float*)(depthptr + depth_offset + (y + 0) * depth_step);
  global const float* row1 = (global const float*)(depthptr + depth_offset + (y + 1) * depth_step);

  float d00 = row0[hook(14, x)];
  float z00 = d00 * dfac;
  float3 p00 = (float3)(convert_float2((int2)(x, y)), z00);
  float3 v00 = reproject(p00, fxyinv, cxy);

  float3 p = nan((unsigned int)0), n = nan((unsigned int)0);

  if (x < depth_cols - 1 && y < depth_rows - 1) {
    float d01 = row0[hook(14, x + 1)];
    float d10 = row1[hook(15, x)];

    float z01 = d01 * dfac;
    float z10 = d10 * dfac;

    if (z00 != 0 && z01 != 0 && z10 != 0) {
      float3 p01 = (float3)(convert_float2((int2)(x + 1, y + 0)), z01);
      float3 p10 = (float3)(convert_float2((int2)(x + 0, y + 1)), z10);
      float3 v01 = reproject(p01, fxyinv, cxy);
      float3 v10 = reproject(p10, fxyinv, cxy);

      float3 vec = cross(v01 - v00, v10 - v00);
      n = -normalize(vec);
      p = v00;
    }
  }

  global float* pts = (global float*)(pointsptr + points_offset + y * points_step + x * sizeof(float4));
  global float* nrm = (global float*)(normalsptr + normals_offset + y * normals_step + x * sizeof(float4));
  vstore4((float4)(p, 0), 0, pts);
  vstore4((float4)(n, 0), 0, nrm);
}