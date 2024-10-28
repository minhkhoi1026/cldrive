//{"Bz":8,"charge":6,"dt":9,"mass":7,"nPtcls":10,"vxGlob":3,"vyGlob":4,"vzGlob":5,"xGlob":0,"yGlob":1,"zGlob":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void advance_ptcls_cycl(global float* xGlob, global float* yGlob, global float* zGlob, global float* vxGlob, global float* vyGlob, global float* vzGlob, const global float* charge, const global float* mass, float Bz, float dt, int nPtcls) {
 private
  int n = get_global_id(0);
  if (n < nPtcls) {
   private
    float omegaB = Bz * charge[hook(6, n)] / mass[hook(7, n)];
   private
    float vx = vxGlob[hook(3, n)];
   private
    float vy = vyGlob[hook(4, n)];
   private
    float vz = vzGlob[hook(5, n)];
   private
    float x = xGlob[hook(0, n)];
   private
    float y = yGlob[hook(1, n)];

   private
    float sinOmegaDt = sin(omegaB * dt);
   private
    float cosOmegaDt = cos(omegaB * dt);

    vxGlob[hook(3, n)] = cosOmegaDt * vx - sinOmegaDt * vy;
    vyGlob[hook(4, n)] = sinOmegaDt * vx + cosOmegaDt * vy;
    xGlob[hook(0, n)] = x + (sinOmegaDt * vx + (cosOmegaDt - 1.0) * vy) / omegaB;
    yGlob[hook(1, n)] = y + (-(cosOmegaDt - 1.0) * vx + sinOmegaDt * vy) / omegaB;
    zGlob[hook(2, n)] += dt * vz;
  }
}