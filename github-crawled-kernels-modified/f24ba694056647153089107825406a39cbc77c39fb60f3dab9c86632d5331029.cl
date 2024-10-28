//{"FEs":5,"PLQs":3,"dinvA":7,"dinvB":8,"dinvC":9,"imgElec":2,"imgLondon":1,"imgPauli":0,"pos0":6,"poss":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler_1 = 0 | 6 | 0x20;
constant sampler_t sampler_2 = 0 | 6 | 0x10;
inline float4 read_imagef_trilin(read_only image3d_t imgIn, float4 coord) {
  float4 icoord;
  float4 fc = fract(coord, &icoord);
  float4 mc = (float4)(1.0, 1.0, 1.0, 1.0) - fc;
  return ((read_imagef(imgIn, sampler_2, icoord + (float4)(0.0, 0.0, 0.0, 0.0)) * mc.x + read_imagef(imgIn, sampler_2, icoord + (float4)(1.0, 0.0, 0.0, 0.0)) * fc.x) * mc.y + (read_imagef(imgIn, sampler_2, icoord + (float4)(0.0, 1.0, 0.0, 0.0)) * mc.x + read_imagef(imgIn, sampler_2, icoord + (float4)(1.0, 1.0, 0.0, 0.0)) * fc.x) * fc.y) * mc.z + ((read_imagef(imgIn, sampler_2, icoord + (float4)(0.0, 0.0, 1.0, 0.0)) * mc.x + read_imagef(imgIn, sampler_2, icoord + (float4)(1.0, 0.0, 1.0, 0.0)) * fc.x) * mc.y + (read_imagef(imgIn, sampler_2, icoord + (float4)(0.0, 1.0, 1.0, 0.0)) * mc.x + read_imagef(imgIn, sampler_2, icoord + (float4)(1.0, 1.0, 1.0, 0.0)) * fc.x) * fc.y) * fc.z;
};

inline float3 rotMat(float3 v, float3 a, float3 b, float3 c) {
  return (float3)(dot(v, a), dot(v, b), dot(v, c));
}
inline float3 rotMatT(float3 v, float3 a, float3 b, float3 c) {
  return a * v.x + b * v.y + c * v.z;
}

inline float3 rotQuat(float4 q, float3 v) {
  float3 t = 2 * cross(q.xyz, v);
  return v + t * q.w + cross(q.xyz, t);
}

inline float4 drotQuat_exact(float4 q, float4 tq) {
  float r = length(tq);
  float a = r * 0.5;

  tq.xyz *= sin(a) / (r + 1.0e-8f);
  return q * cos(a) + (float4){
                          tq.x * q.w + tq.y * q.z - tq.z * q.y,
                          -tq.x * q.z + tq.y * q.w + tq.z * q.x,
                          tq.x * q.y - tq.y * q.x + tq.z * q.w,
                          -tq.x * q.x - tq.y * q.y - tq.z * q.z,

                      };
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

kernel void getFEgrid(read_only image3d_t imgPauli, read_only image3d_t imgLondon, read_only image3d_t imgElec, global float4* PLQs, global float4* poss, global float4* FEs, float4 pos0, float4 dinvA, float4 dinvB, float4 dinvC) {
  const float3 pos = poss[hook(4, get_global_id(0))].xyz + pos0.xyz;
  const float3 PLQ = PLQs[hook(3, get_global_id(0))].xyz;
  float4 coord = (float4)(dot(pos, dinvA.xyz), dot(pos, dinvB.xyz), dot(pos, dinvC.xyz), 0.0f);
  float4 fe;

  coord += (float4)(-0.5, -0.5, -0.5, 0.0);
  fe = PLQ.x * read_imagef_trilin(imgPauli, coord);
  fe += PLQ.y * read_imagef_trilin(imgLondon, coord);
  fe += PLQ.z * read_imagef_trilin(imgElec, coord);

  FEs[hook(5, get_global_id(0))] = fe;
}