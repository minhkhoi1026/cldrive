//{"P":2,"TEMP":3,"U":0,"UI":6,"V":1,"VI":7,"imax":4,"jmax":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct float4 {
  float x;
  float y;
  struct float4* next;
};

struct particleline {
  int length;
  struct float4* Particles;
};

struct float4* partalloc(float x, float y);
kernel void SETSPECBCOND_kernel(global float* U, global float* V, global float* P, global float* TEMP, int imax, int jmax, float UI, float VI) {
  imax = imax + 2;
  jmax = jmax + 2;

  int i = get_global_id(1);
  int j = get_global_id(0);
  if ((i >= 0 && i <= imax - 2)) {
    U[hook(0, i * jmax + (jmax - 1))] = 2.0 - U[hook(0, i * jmax + (jmax - 2))];
  }
}