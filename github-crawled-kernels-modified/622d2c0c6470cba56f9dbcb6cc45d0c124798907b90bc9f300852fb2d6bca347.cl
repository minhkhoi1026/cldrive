//{"downSize":12,"nUpRow0":15,"nUpRow1":16,"n_offset":5,"n_step":4,"ndown_offset":11,"ndown_step":10,"ndownptr":9,"nptr":3,"nrm":18,"pUpRow0":13,"pUpRow1":14,"p_offset":2,"p_step":1,"pdown_offset":8,"pdown_step":7,"pdownptr":6,"pptr":0,"pts":17}
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

kernel void pyrDownPointsNormals(global const char* pptr, int p_step, int p_offset, global const char* nptr, int n_step, int n_offset, global char* pdownptr, int pdown_step, int pdown_offset, global char* ndownptr, int ndown_step, int ndown_offset, const int2 downSize) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x >= downSize.x || y >= downSize.y)
    return;

  float3 point = nan((unsigned int)0), normal = nan((unsigned int)0);

  global const float4* pUpRow0 = (global const float4*)(pptr + p_offset + (2 * y) * p_step);
  global const float4* pUpRow1 = (global const float4*)(pptr + p_offset + (2 * y + 1) * p_step);

  float3 d00 = pUpRow0[hook(13, 2 * x)].xyz;
  float3 d01 = pUpRow0[hook(13, 2 * x + 1)].xyz;
  float3 d10 = pUpRow1[hook(14, 2 * x)].xyz;
  float3 d11 = pUpRow1[hook(14, 2 * x + 1)].xyz;

  if (!(any(isnan(d00)) || any(isnan(d01)) || any(isnan(d10)) || any(isnan(d11)))) {
    point = (d00 + d01 + d10 + d11) * 0.25f;

    global const float4* nUpRow0 = (global const float4*)(nptr + n_offset + (2 * y) * n_step);
    global const float4* nUpRow1 = (global const float4*)(nptr + n_offset + (2 * y + 1) * n_step);

    float3 n00 = nUpRow0[hook(15, 2 * x)].xyz;
    float3 n01 = nUpRow0[hook(15, 2 * x + 1)].xyz;
    float3 n10 = nUpRow1[hook(16, 2 * x)].xyz;
    float3 n11 = nUpRow1[hook(16, 2 * x + 1)].xyz;

    normal = (n00 + n01 + n10 + n11) * 0.25f;
  }

  global float4* pts = (global float4*)(pdownptr + pdown_offset + y * pdown_step);
  global float4* nrm = (global float4*)(ndownptr + ndown_offset + y * ndown_step);
  pts[hook(17, x)] = (float4)(point, 0);
  nrm[hook(18, x)] = (float4)(normal, 0);
}