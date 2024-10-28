//{"N":0,"dt":1,"fx":9,"fy":10,"fz":11,"m":2,"px":3,"py":4,"pz":5,"vx":6,"vy":7,"vz":8,"xmax":15,"xmin":12,"ymax":16,"ymin":13,"zmax":17,"zmin":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_positions(const unsigned int N, const float dt, global float* m, global float* px, global float* py, global float* pz, global float* vx, global float* vy, global float* vz, global float* fx, global float* fy, global float* fz, const float xmin, const float ymin, const float zmin, const float xmax, const float ymax, const float zmax) {
  const int globalid = get_global_id(0);
  if (globalid >= N)
    return;

  px[hook(3, globalid)] += vx[hook(6, globalid)] * dt + 0.5 * fx[hook(9, globalid)] * dt * dt / m[hook(2, globalid)];
  py[hook(4, globalid)] += vy[hook(7, globalid)] * dt + 0.5 * fy[hook(10, globalid)] * dt * dt / m[hook(2, globalid)];
  pz[hook(5, globalid)] += vz[hook(8, globalid)] * dt + 0.5 * fz[hook(11, globalid)] * dt * dt / m[hook(2, globalid)];

  if (px[hook(3, globalid)] >= xmax)
    px[hook(3, globalid)] = xmin + px[hook(3, globalid)] - xmax;
  if (py[hook(4, globalid)] >= ymax)
    py[hook(4, globalid)] = ymin + py[hook(4, globalid)] - ymax;
  if (pz[hook(5, globalid)] >= zmax)
    pz[hook(5, globalid)] = zmin + pz[hook(5, globalid)] - zmax;

  if (px[hook(3, globalid)] <= xmin)
    px[hook(3, globalid)] = xmax - xmin + px[hook(3, globalid)];
  if (py[hook(4, globalid)] <= ymin)
    py[hook(4, globalid)] = ymax - ymin + py[hook(4, globalid)];
  if (pz[hook(5, globalid)] <= zmin)
    pz[hook(5, globalid)] = zmax - zmin + pz[hook(5, globalid)];
}