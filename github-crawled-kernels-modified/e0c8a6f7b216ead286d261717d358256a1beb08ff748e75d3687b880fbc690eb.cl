//{"delta_time":3,"mmm0":6,"mmm1":7,"positions":0,"start_positions":1,"temp0":4,"temp1":5,"time":2,"xNoisePotentialDerivatives":10,"yNoisePotentialDerivatives":9,"zNoisePotentialDerivatives":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 mod289f4(float4 x) {
  float4 t = x;
  return t - floor(t * (1.0f / 289.0f)) * 289.0f;
}

float mod289(float x) {
  return x - floor(x * (1.0f / 289.0f)) * 289.0f;
}

float4 permutef4(float4 x) {
  return mod289f4(((x * 34.0f) + 1.0f) * x);
}

float permute(float x) {
  return mod289(((x * 34.0f) + 1.0f) * x);
}

float4 taylorInvSqrtf4(float4 r) {
  return 1.79284291400159f - 0.85373472095314f * r;
}

float taylorInvSqrt(float r) {
  return 1.79284291400159f - 0.85373472095314f * r;
}

float4 grad4(float j, float4 ip) {
  const float4 ones = (float4)(1.0, 1.0, 1.0, -1.0);
  float4 p, s;
  float3 fr;
  p.xyz = floor(fract((float3)(j)*ip.xyz, &fr) * 7.0f) * ip.z - 1.0f;
  p.w = 1.5f - dot(fabs(p.xyz), ones.xyz);
  s = (float4)(p.x < 0.f, p.y < 0., p.z < 0.f, p.w < 0.);
  p.xyz = p.xyz + (s.xyz * 2.0f - 1.0f) * s.www;
  return p;
}

float4 simplexNoiseDerivatives(float4 v) {
  const float4 C = (float4)(0.138196601125011, 0.276393202250021, 0.414589803375032, -0.447213595499958);

  float4 i = floor(v + dot(v, (float4)(0.309016994374947451)));
  float4 x0 = v - i + dot(i, C.xxxx);

  float4 i0;
  float3 isX = step(x0.yzw, x0.xxx);
  float3 isYZ = step(x0.zww, x0.yyz);
  i0.x = isX.x + isX.y + isX.z;
  i0.yzw = 1.0f - isX;
  i0.y += isYZ.x + isYZ.y;
  i0.zw += 1.0f - isYZ.xy;
  i0.z += isYZ.z;
  i0.w += 1.0f - isYZ.z;

  float4 i3 = clamp(i0, 0.0f, 1.0f);
  float4 i2 = clamp(i0 - 1.0f, 0.0f, 1.0f);
  float4 i1 = clamp(i0 - 2.0f, 0.0f, 1.0f);

  float4 x1 = x0 - i1 + C.xxxx;
  float4 x2 = x0 - i2 + C.yyyy;
  float4 x3 = x0 - i3 + C.zzzz;
  float4 x4 = x0 + C.wwww;

  i = mod289f4(i);
  float j0 = permute(permute(permute(permute(i.w) + i.z) + i.y) + i.x);
  float4 j1 = permutef4(permutef4(permutef4(permutef4(i.w + (float4)(i1.w, i2.w, i3.w, 1.0f)) + i.z + (float4)(i1.z, i2.z, i3.z, 1.0f)) + i.y + (float4)(i1.y, i2.y, i3.y, 1.0f)) + i.x + (float4)(i1.x, i2.x, i3.x, 1.0f));

  float4 ip = (float4)(1.0f / 294.0f, 1.0f / 49.0f, 1.0f / 7.0f, 0.0f);

  float4 p0 = grad4(j0, ip);
  float4 p1 = grad4(j1.x, ip);
  float4 p2 = grad4(j1.y, ip);
  float4 p3 = grad4(j1.z, ip);
  float4 p4 = grad4(j1.w, ip);

  float4 norm = taylorInvSqrtf4((float4)(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;
  p4 *= taylorInvSqrtf4(dot(p4, p4));

  float3 values0 = (float3)(dot(p0, x0), dot(p1, x1), dot(p2, x2));
  float2 values1 = (float2)(dot(p3, x3), dot(p4, x4));

  float3 m0 = max(0.5f - (float3)(dot(x0, x0), dot(x1, x1), dot(x2, x2)), 0.0f);
  float2 m1 = max(0.5f - (float2)(dot(x3, x3), dot(x4, x4)), 0.0f);

  float3 temp0 = -6.0f * m0 * m0 * values0;
  float2 temp1 = -6.0f * m1 * m1 * values1;

  float3 mmm0 = m0 * m0 * m0;
  float2 mmm1 = m1 * m1 * m1;

  float dx = temp0[hook(4, 0)] * x0.x + temp0[hook(4, 1)] * x1.x + temp0[hook(4, 2)] * x2.x + temp1[hook(5, 0)] * x3.x + temp1[hook(5, 1)] * x4.x + mmm0[hook(6, 0)] * p0.x + mmm0[hook(6, 1)] * p1.x + mmm0[hook(6, 2)] * p2.x + mmm1[hook(7, 0)] * p3.x + mmm1[hook(7, 1)] * p4.x;
  float dy = temp0[hook(4, 0)] * x0.y + temp0[hook(4, 1)] * x1.y + temp0[hook(4, 2)] * x2.y + temp1[hook(5, 0)] * x3.y + temp1[hook(5, 1)] * x4.y + mmm0[hook(6, 0)] * p0.y + mmm0[hook(6, 1)] * p1.y + mmm0[hook(6, 2)] * p2.y + mmm1[hook(7, 0)] * p3.y + mmm1[hook(7, 1)] * p4.y;
  float dz = temp0[hook(4, 0)] * x0.z + temp0[hook(4, 1)] * x1.z + temp0[hook(4, 2)] * x2.z + temp1[hook(5, 0)] * x3.z + temp1[hook(5, 1)] * x4.z + mmm0[hook(6, 0)] * p0.z + mmm0[hook(6, 1)] * p1.z + mmm0[hook(6, 2)] * p2.z + mmm1[hook(7, 0)] * p3.z + mmm1[hook(7, 1)] * p4.z;
  float dw = temp0[hook(4, 0)] * x0.w + temp0[hook(4, 1)] * x1.w + temp0[hook(4, 2)] * x2.w + temp1[hook(5, 0)] * x3.w + temp1[hook(5, 1)] * x4.w + mmm0[hook(6, 0)] * p0.w + mmm0[hook(6, 1)] * p1.w + mmm0[hook(6, 2)] * p2.w + mmm1[hook(7, 0)] * p3.w + mmm1[hook(7, 1)] * p4.w;

  return (float4)(dx, dy, dz, dw) * 49.0f;
}

kernel void particle_update(global float4* positions, global float4* start_positions, const float time, const float delta_time) {
  const int ind = get_global_id(0);

  float4 data = positions[hook(0, ind)];

  float3 oldPosition = data.xyz;

  float3 noisePosition = oldPosition * 1.5f;

  float noiseTime = time;

  float4 xNoisePotentialDerivatives = (float4)(0.0f);
  float4 yNoisePotentialDerivatives = (float4)(0.0f);
  float4 zNoisePotentialDerivatives = (float4)(0.0f);

  float persistence = .4f;

  for (int i = 0; i < 3; ++i) {
    float scale = (1.0f / 2.0f) * pow(2.0f, (float)(i));

    float noiseScale = pow(persistence, (float)(i));

    if (persistence == 0.0f && i == 0) {
      noiseScale = 1.0f;
    }

    xNoisePotentialDerivatives += simplexNoiseDerivatives((float4)(noisePosition * pow(2.0f, (float)(i)), noiseTime)) * noiseScale * scale;
    yNoisePotentialDerivatives += simplexNoiseDerivatives((float4)((noisePosition + (float3)(123.4f, 129845.6f, -1239.1f)) * pow(2.0f, (float)(i)), noiseTime)) * noiseScale * scale;
    zNoisePotentialDerivatives += simplexNoiseDerivatives((float4)((noisePosition + (float3)(-9519.0f, 9051.0f, -123.0f)) * pow(2.0f, (float)(i)), noiseTime)) * noiseScale * scale;
  }

  float3 noiseVelocity = (float3)(zNoisePotentialDerivatives[hook(8, 1)] - yNoisePotentialDerivatives[hook(9, 2)], xNoisePotentialDerivatives[hook(10, 2)] - zNoisePotentialDerivatives[hook(8, 0)], yNoisePotentialDerivatives[hook(9, 0)] - xNoisePotentialDerivatives[hook(10, 1)]) * .095f;

  float3 velocity = (float3)(1.f, 0.0f, 0.0f);
  float3 totalVelocity = velocity + noiseVelocity;

  float3 newPosition = oldPosition + totalVelocity * delta_time;

  float oldLifetime = data.a;
  float newLifetime = oldLifetime - delta_time;

  if (newLifetime < 0.0f) {
    float4 sp = start_positions[hook(1, ind)];
    newPosition = sp.xyz;
    newLifetime = sp.w + newLifetime;
  }

  positions[hook(0, ind)].xyz = newPosition;
  positions[hook(0, ind)].w = newLifetime;
}