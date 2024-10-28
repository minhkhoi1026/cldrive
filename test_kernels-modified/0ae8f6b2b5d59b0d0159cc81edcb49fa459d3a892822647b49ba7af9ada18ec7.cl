//{"axGlob":11,"ayGlob":12,"azGlob":13,"charge":3,"cosTheta":8,"kx":5,"ky":6,"kz":7,"mass":4,"nPtcls":10,"sinTheta":9,"xGlob":0,"yGlob":1,"zGlob":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_trap_acceleration(const global float* xGlob, const global float* yGlob, const global float* zGlob, const global float* charge, const global float* mass, float kx, float ky, float kz, float cosTheta, float sinTheta, int nPtcls, global float* axGlob, global float* ayGlob, global float* azGlob) {
 private
  int n = get_global_id(0);
  if (n < nPtcls) {
   private
    float x = xGlob[hook(0, n)];
   private
    float y = yGlob[hook(1, n)];
   private
    float z = zGlob[hook(2, n)];

   private
    float chargeOverMass = charge[hook(3, n)] / mass[hook(4, n)];

   private
    float ax = (-kx * pown(cosTheta, 2) - ky * pown(sinTheta, 2)) * x + cosTheta * sinTheta * (ky - kx) * y;
   private
    float ay = cosTheta * sinTheta * (-kx + ky) * x + (-kx * pown(sinTheta, 2) - ky * pown(cosTheta, 2)) * y;
   private
    float az = -kz * z;

    ax *= chargeOverMass;
    ay *= chargeOverMass;
    az *= chargeOverMass;

    axGlob[hook(11, n)] += ax;
    ayGlob[hook(12, n)] += ay;
    azGlob[hook(13, n)] += az;
  }
}