//{"charge":6,"eToTheMinusKappaDt":8,"mass":7,"nPtcls":9,"vxGlob":3,"vyGlob":4,"vzGlob":5,"xGlob":0,"yGlob":1,"zGlob":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void advance_ptcls_axial_damping(global float* xGlob, global float* yGlob, global float* zGlob, global float* vxGlob, global float* vyGlob, global float* vzGlob, const global float* charge, const global float* mass, float eToTheMinusKappaDt, int nPtcls) {
 private
  int n = get_global_id(0);
  if (n < nPtcls) {
    vzGlob[hook(5, n)] *= eToTheMinusKappaDt;
  }
}