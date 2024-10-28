//{"actualNs":1,"ax":9,"ay":10,"az":11,"dirs":3,"dt":8,"kx0":4,"ky0":5,"kz0":6,"mass":0,"nMax":2,"nPtcls":12,"recoilMomentum":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float lineShape(float gamma, float delta, float S);
float peakScatteringRate(float3 k, float3 v, float gamma, float delta, float S);
float gaussianBeamProfile(float3 k, float3 r0, float sigma, float3 r);
kernel void computeKicks(global float* mass, global int* actualNs, int nMax, global float* dirs, float kx0, float ky0, float kz0, float recoilMomentum, float dt, global float* ax, global float* ay, global float* az, int nPtcls) {
  int i = get_global_id(0);
  if (i < nPtcls) {
    float m = mass[hook(0, i)];
    float recoilVelocity = recoilMomentum / m;
    int myNumPhotons = actualNs[hook(1, i)];
    int totNumPhotons = nMax * nPtcls;
    float3 vRecoil = myNumPhotons * recoilVelocity * normalize((float3)(kx0, ky0, kz0));

    dirs += i * nMax;
    for (int j = 0; j < myNumPhotons; ++j) {
      float3 dir;
      dir.x = dirs[hook(3, 0 * totNumPhotons + j)];
      dir.y = dirs[hook(3, 1 * totNumPhotons + j)];
      dir.z = dirs[hook(3, 2 * totNumPhotons + j)];
      vRecoil += recoilVelocity * normalize(dir);
    }
    ax[hook(9, i)] += vRecoil.x / dt;
    ay[hook(10, i)] += vRecoil.y / dt;
    az[hook(11, i)] += vRecoil.z / dt;
  }
}