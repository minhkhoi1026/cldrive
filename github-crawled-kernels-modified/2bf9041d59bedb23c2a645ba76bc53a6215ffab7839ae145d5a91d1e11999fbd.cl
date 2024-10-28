//{"FLAG":2,"P":0,"RHS":1,"delx":5,"dely":6,"imax":3,"jmax":4,"res":7}
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
kernel void POISSON_1_comp_res_kernel(global float* P, global float* RHS, global int* FLAG, int imax, int jmax, float delx, float dely, global float* res) {
}