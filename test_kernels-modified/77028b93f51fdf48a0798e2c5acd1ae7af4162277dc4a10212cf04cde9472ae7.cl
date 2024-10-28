//{"FEs":2,"dTip":6,"dinvA":3,"dinvB":4,"dinvC":5,"dpos0":8,"imgIn":0,"nz":10,"points":1,"relax_params":9,"stiffness":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler_1 = 1 | 6 | 0x20;
inline float3 rotMat(float3 v, float3 a, float3 b, float3 c) {
  return (float3)(dot(v, a), dot(v, b), dot(v, c));
}
inline float3 rotMatT(float3 v, float3 a, float3 b, float3 c) {
  return a * v.x + b * v.y + c * v.z;
}

float3 tipForce(float3 dpos, float4 stiffness, float4 dpos0) {
  float r = sqrt(dot(dpos, dpos));
  return (dpos - dpos0.xyz) * stiffness.xyz + dpos * (stiffness.w * (r - dpos0.w) / r);
}

float4 interpFE(float3 pos, float3 dinvA, float3 dinvB, float3 dinvC, read_only image3d_t imgIn) {
  const float4 coord = (float4)(dot(pos, dinvA), dot(pos, dinvB), dot(pos, dinvC), 0.0f);
  return read_imagef(imgIn, sampler_1, coord);
}

void move_LeapFrog(float3 f, float3 p, float3 v, float2 RP) {
  v = f * RP.x + v * RP.y;
  p += v * RP.x;
}
void move_FIRE(float3 f, float3 p, float3 v, float2 RP, float4 RP0) {
  float ff = dot(f, f);
  float vv = dot(v, v);
  float vf = dot(v, f);
  if (vf < 0) {
    v = 0.0f;
    RP.x = max(RP.x * 0.5f, RP0.z);
    RP.y = RP0.y;
  } else {
    v = v * (1 - RP.y) + f * RP.y * sqrt(vv / ff);
    RP.x = min(RP.x * 1.1f, RP0.w);
    RP.y *= 0.99f;
  }

  v += f * RP.x;
  p += v * RP.x;
}

kernel void relaxStrokes(read_only image3d_t imgIn, global float4* points, global float4* FEs, float4 dinvA, float4 dinvB, float4 dinvC, float4 dTip, float4 stiffness, float4 dpos0, float4 relax_params, int nz) {
  float3 tipPos = points[hook(1, get_global_id(0))].xyz;
  float3 pos = tipPos.xyz + dpos0.xyz;

  for (int iz = 0; iz < nz; iz++) {
    float4 fe;
    float3 vel = 0.0f;
    for (int i = 0; i < 64; i++) {
      fe = interpFE(pos, dinvA.xyz, dinvB.xyz, dinvC.xyz, imgIn);
      float3 f = fe.xyz;
      f += tipForce(pos - tipPos, stiffness, dpos0);
      vel *= relax_params.y;
      vel += f * relax_params.y;
      pos.xyz += vel * relax_params.x;
      if (dot(f, f) < 1e-8)
        break;
    }

    FEs[hook(2, get_global_id(0) * nz + iz)].xyz = pos;
    tipPos += dTip.xyz;
    pos += dTip.xyz;
  }
}