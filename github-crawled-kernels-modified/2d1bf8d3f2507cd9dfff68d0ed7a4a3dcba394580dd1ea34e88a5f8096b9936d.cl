//{"buffer":4,"gridResolution":0,"inputDensityBuffer":2,"outputDensityBuffer":3,"velocityBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float dt = 0.1f;
float2 getBil(float2 p, int gridResolution, global float2* buffer) {
  p = clamp(p, (float2)(0.0f), (float2)(gridResolution));

  float2 p00 = buffer[hook(4, (int)(p.x) + (int)(p.y) * gridResolution)];
  float2 p10 = buffer[hook(4, (int)(p.x) + 1 + (int)(p.y) * gridResolution)];
  float2 p11 = buffer[hook(4, (int)(p.x) + 1 + (int)(p.y + 1.F) * gridResolution)];
  float2 p01 = buffer[hook(4, (int)(p.x) + (int)(p.y + 1.F) * gridResolution)];

 private
  float flr;
  float t0 = fract(p.x, &flr);
  float t1 = fract(p.y, &flr);

  float2 v0 = mix(p00, p10, t0);
  float2 v1 = mix(p01, p11, t0);

  return mix(v0, v1, t1);
}

float4 getBil4(float2 p, int gridResolution, global float4* buffer) {
  p = clamp(p, (float2)(0.0f), (float2)(gridResolution));

  float4 p00 = buffer[hook(4, (int)(p.x) + (int)(p.y) * gridResolution)];
  float4 p10 = buffer[hook(4, (int)(p.x) + 1 + (int)(p.y) * gridResolution)];
  float4 p11 = buffer[hook(4, (int)(p.x) + 1 + (int)(p.y + 1.F) * gridResolution)];
  float4 p01 = buffer[hook(4, (int)(p.x) + (int)(p.y + 1.F) * gridResolution)];

 private
  float flr;
  float t0 = fract(p.x, &flr);
  float t1 = fract(p.y, &flr);

  float4 v0 = mix(p00, p10, t0);
  float4 v1 = mix(p01, p11, t0);

  return mix(v0, v1, t1);
}

kernel void advectionDensity(const int gridResolution, global float2* velocityBuffer, global float4* inputDensityBuffer, global float4* outputDensityBuffer) {
  int2 id = (int2)(get_global_id(0), get_global_id(1));

  if (id.x > 0 && id.x < gridResolution - 1 && id.y > 0 && id.y < gridResolution - 1) {
    float2 velocity = velocityBuffer[hook(1, id.x + id.y * gridResolution)];

    float2 p = (float2)((float)id.x - dt * velocity.x, (float)id.y - dt * velocity.y);

    outputDensityBuffer[hook(3, id.x + id.y * gridResolution)] = getBil4(p, gridResolution, inputDensityBuffer);
  } else {
    outputDensityBuffer[hook(3, id.x + id.y * gridResolution)] = 0.0f;
  }
}