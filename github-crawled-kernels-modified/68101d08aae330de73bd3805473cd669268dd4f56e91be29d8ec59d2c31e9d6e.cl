//{"N":0,"dt":1,"fx":6,"fy":7,"fz":8,"ofx":9,"ofy":10,"ofz":11,"particle_mass":2,"vx":3,"vy":4,"vz":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_velocities(const unsigned int N, const float dt, const float particle_mass, global float* vx, global float* vy, global float* vz, global float* fx, global float* fy, global float* fz, global float* ofx, global float* ofy, global float* ofz) {
  const int globalid = get_global_id(0);
  if (globalid >= N)
    return;

  vx[hook(3, globalid)] += (fx[hook(6, globalid)] + ofx[hook(9, globalid)]) * dt * 0.5 / particle_mass;
  vy[hook(4, globalid)] += (fy[hook(7, globalid)] + ofy[hook(10, globalid)]) * dt * 0.5 / particle_mass;
  vz[hook(5, globalid)] += (fz[hook(8, globalid)] + ofz[hook(11, globalid)]) * dt * 0.5 / particle_mass;
}