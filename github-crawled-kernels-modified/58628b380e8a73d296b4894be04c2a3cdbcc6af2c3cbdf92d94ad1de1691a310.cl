//{"S":15,"delta0":14,"dt":16,"gamma":13,"kx":6,"ky":7,"kz":8,"nPtcls":17,"nbar":18,"sigma":12,"vxGlob":3,"vyGlob":4,"vzGlob":5,"x0":9,"xGlob":0,"y0":10,"yGlob":1,"z0":11,"zGlob":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float lineShape(float gamma, float delta, float S);
float peakScatteringRate(float3 k, float3 v, float gamma, float delta, float S);
float gaussianBeamProfile(float3 k, float3 r0, float sigma, float3 r);
kernel void compute_mean_scattered_photons_gaussian_beam(global float* xGlob, global float* yGlob, global float* zGlob, global float* vxGlob, global float* vyGlob, global float* vzGlob, float kx, float ky, float kz, float x0, float y0, float z0, float sigma, float gamma, float delta0, float S, float dt, int nPtcls, global float* nbar) {
  int i = get_global_id(0);
  if (i < nPtcls) {
    float3 v = (float3)(vxGlob[hook(3, i)], vyGlob[hook(4, i)], vzGlob[hook(5, i)]);
    float3 r = (float3)(xGlob[hook(0, i)], yGlob[hook(1, i)], zGlob[hook(2, i)]);
    float3 k = (float3)(kx, ky, kz);
    float3 r0 = (float3)(x0, y0, z0);

    float nPeak = peakScatteringRate(k, v, gamma, delta0, S);
    float geomFact = gaussianBeamProfile(k, r0, sigma, r);
    nbar[hook(18, i)] = dt * geomFact * nPeak;
  }
}