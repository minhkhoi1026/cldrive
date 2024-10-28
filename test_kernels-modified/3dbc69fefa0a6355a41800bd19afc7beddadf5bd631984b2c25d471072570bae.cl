//{"axGlob":8,"ayGlob":9,"azGlob":10,"charge":6,"dt":11,"mass":7,"nPtcls":12,"vxGlob":3,"vyGlob":4,"vzGlob":5,"xGlob":0,"yGlob":1,"zGlob":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void advance_ptcls_velocity_kick(global float* xGlob, global float* yGlob, global float* zGlob, global float* vxGlob, global float* vyGlob, global float* vzGlob, const global float* charge, const global float* mass, global float* axGlob, global float* ayGlob, global float* azGlob, float dt, int nPtcls) {
 private
  int n = get_global_id(0);
  if (n < nPtcls) {
    vxGlob[hook(3, n)] += dt * axGlob[hook(8, n)];
    vyGlob[hook(4, n)] += dt * ayGlob[hook(9, n)];
    vzGlob[hook(5, n)] += dt * azGlob[hook(10, n)];
  }
}