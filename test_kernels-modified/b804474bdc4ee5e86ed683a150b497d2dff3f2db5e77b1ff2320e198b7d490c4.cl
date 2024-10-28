//{"hitNormal":3,"hitPos":2,"max_depth":4,"ray0":1,"rayDir":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sceneDistFunction(float3 pos) {
  float dist = 1e+8;

  return dist;
}

float castRay(float3 rd, float3 ro, float tmax) {
  float t = 0.0f;
  for (int i = 0; i < 256; i++) {
    float dist = sceneDistFunction(ro + rd * t);
    if (dist < (0.0001 * t))
      break;
    if (t > tmax)
      return 1e+8;
    t += dist;
  }

  return t;
}

float3 calcNormal(float3 pos) {
  float2 e = (float2)(0.0f, 0.001f);
  float3 nor = (float3)(sceneDistFunction(pos + e.yxx) - sceneDistFunction(pos - e.yxx), sceneDistFunction(pos + e.xyx) - sceneDistFunction(pos - e.xyx), sceneDistFunction(pos + e.xxy) - sceneDistFunction(pos - e.xxy));
  return normalize(nor);
}

kernel void rayTrace_basic(global float4* rayDir, global float4* ray0, global float4* hitPos, global float4* hitNormal, float max_depth) {
  float3 rd = rayDir[hook(0, get_global_id(0))].xyz;
  float3 ro = ray0[hook(1, get_global_id(0))].xyz;

  float sum = 1.0f;
  float t = 0.0f;
  for (int i = 0; i < 256; i++) {
    float dist = sceneDistFunction(ro + rd * t);

    sum += 1.0f / (1.0f + 80.0f * dist * dist);
    if (dist < (0.0001 * t))
      break;
    if (t > max_depth) {
      t = 1e+8;
      break;
    };
    t += dist;
  }

  float3 pos = ro + t * rd;
  float3 nor = 0.0f;
  if (t < 1e+7) {
    nor = calcNormal(pos);
  };
  hitPos[hook(2, get_global_id(0))] = (float4)(pos, t);
  hitNormal[hook(3, get_global_id(0))] = (float4)(nor, sum);
}