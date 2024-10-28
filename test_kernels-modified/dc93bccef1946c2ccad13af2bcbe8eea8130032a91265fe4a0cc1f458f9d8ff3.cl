//{"dt":1,"nBody":0,"px":2,"py":3,"pz":4,"vx":5,"vy":6,"vz":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void integrateBodies(const int nBody, const float dt, global float* px, global float* py, global float* pz, global float* vx, global float* vy, global float* vz) {
  int i = get_global_id(0);
  if (i < nBody) {
    px[hook(2, i)] += dt * vx[hook(5, i)];
    py[hook(3, i)] += dt * vy[hook(6, i)];
    pz[hook(4, i)] += dt * vz[hook(7, i)];
  }
}