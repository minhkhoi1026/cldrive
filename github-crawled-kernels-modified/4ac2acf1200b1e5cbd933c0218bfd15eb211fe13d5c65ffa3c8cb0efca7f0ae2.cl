//{"charge":7,"dt":13,"mass":8,"nPtcls":14,"offset":11,"peakCoolingRate":9,"peakDiffusionConstant":10,"randNumbers":6,"vxGlob":3,"vyGlob":4,"vzGlob":5,"width":12,"xGlob":0,"yGlob":1,"zGlob":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void advance_ptcls_cooling_along_x(global float* xGlob, global float* yGlob, global float* zGlob, global float* vxGlob, global float* vyGlob, global float* vzGlob, global float* randNumbers, const global float* charge, const global float* mass, float peakCoolingRate, float peakDiffusionConstant, float offset, float width, float dt, int nPtcls) {
 private
  int n = get_global_id(0);
  if (n < nPtcls) {
   private
    float vx = vxGlob[hook(3, n)];
   private
    float vy = vyGlob[hook(4, n)];
   private
    float vz = vzGlob[hook(5, n)];
   private
    float y = yGlob[hook(1, n)];

    float profileFactor = exp(-pown((y - offset) / width, 2));

    vx *= exp(-peakCoolingRate * profileFactor * dt);

    float diffusionFactor = peakDiffusionConstant * sqrt(profileFactor * dt) / 3.0;
    vx += diffusionFactor * randNumbers[hook(6, n + 0 * nPtcls)];
    vy += diffusionFactor * randNumbers[hook(6, n + 1 * nPtcls)];
    vz += diffusionFactor * randNumbers[hook(6, n + 2 * nPtcls)];

    vxGlob[hook(3, n)] = vx;
    vyGlob[hook(4, n)] = vy;
    vzGlob[hook(5, n)] = vz;
  }
}