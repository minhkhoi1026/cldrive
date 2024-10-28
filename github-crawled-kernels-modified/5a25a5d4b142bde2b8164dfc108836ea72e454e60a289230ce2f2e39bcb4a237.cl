//{"charge":6,"eToTheMinusKappaDT":8,"mass":7,"minRadius":10,"nPtcls":11,"omega":9,"vxGlob":3,"vyGlob":4,"vzGlob":5,"xGlob":0,"yGlob":1,"zGlob":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void advance_ptcls_angular_damping(global float* xGlob, global float* yGlob, global float* zGlob, global float* vxGlob, global float* vyGlob, global float* vzGlob, const global float* charge, const global float* mass, float eToTheMinusKappaDT, float omega, float minRadius, int nPtcls) {
 private
  int n = get_global_id(0);
  if (n < nPtcls) {
   private
    float2 v = (float2)(vxGlob[hook(3, n)], vyGlob[hook(4, n)]);
   private
    float2 r = (float2)(xGlob[hook(0, n)], yGlob[hook(1, n)]);
   private
    float radius = length(r);

    if (radius > minRadius) {
     private
      float2 vHat = normalize((float2)(-r.y, r.x));
     private
      float2 vPar = vHat * dot(vHat, v);
     private
      float2 targetVelocity = omega * radius * vHat;
     private
      float2 vPerp = v - vPar;

      v = vPerp + targetVelocity + (vPar - targetVelocity) * eToTheMinusKappaDT;
      vxGlob[hook(3, n)] = v.x;
      vyGlob[hook(4, n)] = v.y;
    }
  }
}