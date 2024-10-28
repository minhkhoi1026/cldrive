//{"S":11,"delta0":10,"dt":12,"gamma":9,"kx":6,"ky":7,"kz":8,"nPtcls":13,"nbar":14,"vxGlob":3,"vyGlob":4,"vzGlob":5,"xGlob":0,"yGlob":1,"zGlob":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float lineShape(float gamma, float delta, float S);
float peakScatteringRate(float3 k, float3 v, float gamma, float delta, float S);
float gaussianBeamProfile(float3 k, float3 r0, float sigma, float3 r);
kernel void compute_mean_scattered_photons_homogeneous_beam(global float* xGlob, global float* yGlob, global float* zGlob, global float* vxGlob, global float* vyGlob, global float* vzGlob, float kx, float ky, float kz, float gamma, float delta0, float S, float dt, int nPtcls, global float* nbar) {
  int i = get_global_id(0);
  if (i < nPtcls) {
    float3 v = (float3)(vxGlob[hook(3, i)], vyGlob[hook(4, i)], vzGlob[hook(5, i)]);
    float3 k = (float3)(kx, ky, kz);

    nbar[hook(14, i)] = dt * peakScatteringRate(k, v, gamma, delta0, S);
  }
}