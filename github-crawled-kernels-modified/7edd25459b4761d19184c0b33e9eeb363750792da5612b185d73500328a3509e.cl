//{"Fin":0,"iso":3,"nz":2,"zMap":1}
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

kernel void izoZ(global float4* Fin, global float* zMap, int nz, float iso) {
  int ioffi = get_global_id(0) * nz;
  float4 ofe = Fin[hook(0, ioffi)];
  for (int iz = 1; iz < nz; iz++) {
    float4 fe = Fin[hook(0, ioffi + iz)];

    if (fe.z > iso) {
      float t = (iso - ofe.z) / (fe.z - ofe.z);
      zMap[hook(1, get_global_id(0))] = iz + t;
      return;
    }
    ofe = fe;
  }
  zMap[hook(1, get_global_id(0))] = -1;
}