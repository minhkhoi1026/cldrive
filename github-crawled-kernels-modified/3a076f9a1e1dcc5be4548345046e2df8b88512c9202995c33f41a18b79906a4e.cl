//{"IMPACTFACT":7,"charge":3,"k":6,"nPtcls":5,"potEnergy":4,"x":0,"y":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float Vij(float3 r1, float q1, float3 r2, float q2, float k, float IMPACTFACT);
kernel void calc_potential_energy(global float* x, global float* y, global float* z, global float* charge, global float* potEnergy, int nPtcls, float k, float IMPACTFACT) {
  int tid = get_global_id(0) + get_global_id(1) * get_global_size(0);

  float energy = 0;
  if (tid < nPtcls) {
    float3 r1 = (float3)(x[hook(0, tid)], y[hook(1, tid)], z[hook(2, tid)]);
    float q1 = k * charge[hook(3, tid)];
    for (int i = 0; i < nPtcls; ++i) {
      if (tid != i) {
        float3 r2 = (float3)(x[hook(0, i)], y[hook(1, i)], z[hook(2, i)]);
        float q2 = charge[hook(3, i)];
        energy += Vij(r1, q1, r2, q2, k, IMPACTFACT);
      }
    }
    potEnergy[hook(4, tid)] = energy / (float)2;
  }
}