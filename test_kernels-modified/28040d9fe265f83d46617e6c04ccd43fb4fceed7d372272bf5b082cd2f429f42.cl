//{"N":0,"dt":1,"fx":11,"fy":12,"fz":13,"px":5,"py":6,"pz":7,"reflect_x":2,"reflect_y":3,"reflect_z":4,"vx":8,"vy":9,"vz":10,"xmax":17,"xmin":14,"ymax":18,"ymin":15,"zmax":19,"zmin":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_positions(const unsigned N, const float dt, int reflect_x, int reflect_y, int reflect_z, global float* px, global float* py, global float* pz, global float* vx, global float* vy, global float* vz, global float* fx, global float* fy, global float* fz, float xmin, float ymin, float zmin, float xmax, float ymax, float zmax) {
  size_t gid = get_global_id(0);
  if (gid >= N)
    return;

  float dt2 = 0.5 * dt * dt;

  px[hook(5, gid)] += dt * vx[hook(8, gid)] + dt2 * fx[hook(11, gid)];
  py[hook(6, gid)] += dt * vy[hook(9, gid)] + dt2 * fy[hook(12, gid)];
  pz[hook(7, gid)] += dt * vz[hook(10, gid)] + dt2 * fz[hook(13, gid)];

  if (px[hook(5, gid)] < xmin) {
    px[hook(5, gid)] = 2.0f * xmin - px[hook(5, gid)];
    vx[hook(8, gid)] *= -0.5;
  }

  if (px[hook(5, gid)] > xmax) {
    px[hook(5, gid)] = 2.0f * xmax - px[hook(5, gid)];
    vx[hook(8, gid)] *= -0.5;
  }

  if (py[hook(6, gid)] < ymin) {
    py[hook(6, gid)] = 2.0f * ymin - py[hook(6, gid)];
    vy[hook(9, gid)] *= -0.5;
  }

  if (py[hook(6, gid)] > ymax) {
    py[hook(6, gid)] = 2.0f * ymax - py[hook(6, gid)];
    vy[hook(9, gid)] *= -0.5;
  }

  if (pz[hook(7, gid)] < zmin) {
    pz[hook(7, gid)] = 2.0f * zmin - pz[hook(7, gid)];
    vz[hook(10, gid)] *= -0.5;
  }

  if (pz[hook(7, gid)] > zmax) {
    pz[hook(7, gid)] = 2.0f * zmax - pz[hook(7, gid)];
    vz[hook(10, gid)] *= -0.5;
  }
}