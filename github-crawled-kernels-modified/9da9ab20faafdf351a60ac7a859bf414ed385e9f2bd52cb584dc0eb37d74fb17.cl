//{"alpha":4,"force":7,"mass":6,"massSources":3,"numPart":0,"numPoint":1,"pointSources":2,"pos":5,"scale":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct GridParams {
  float4 grid_size;
  float4 grid_min;
  float4 grid_max;
  float4 bnd_min;
  float4 bnd_max;

  float4 grid_res;
  float4 grid_delta;

  int nb_cells;
};

kernel void gravityForce(int numPart, int numPoint, global float4* pointSources, global float* massSources, global float* alpha, global float4* pos, global float* mass, global float4* force, float scale) {
  unsigned int index = get_global_id(0);
  if (index >= numPart)
    return;
  for (int i = 0; i < numPoint; i++) {
    float4 vect = scale * (pointSources[hook(2, i)] - pos[hook(5, index)]);
    vect.w = 0.0f;
    float4 direction = fast_normalize(vect);
    float dist2 = dot(vect, vect);
    float mag = alpha[hook(4, i)] * massSources[hook(3, i)];
    float cutoff = 0.5f * scale;
    cutoff *= cutoff;
    if (dist2 < cutoff)
      mag /= -cutoff;
    else
      mag /= dist2;
    force[hook(7, index)] += (mag * direction.xyzw) * mass[hook(6, index)];
  }
}