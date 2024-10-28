//{"dt":1,"nBody":0,"px":2,"py":3,"pz":4,"vx":5,"vy":6,"vz":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bodyForces(const int nBody, const float dt, global float* px, global float* py, global float* pz, global float* vx, global float* vy, global float* vz) {
  int i = get_global_id(0);
  if (i < nBody) {
    float Fx = 0.0f;
    float Fy = 0.0f;
    float Fz = 0.0f;

    for (int j = 0; j < nBody; j++) {
      float dx = px[hook(2, j)] - px[hook(2, i)];
      float dy = py[hook(3, j)] - py[hook(3, i)];
      float dz = pz[hook(4, j)] - pz[hook(4, i)];

      float distSqr = dx * dx + dy * dy + dz * dz + 1e-9f;
      float invDist = rsqrt(distSqr);
      float invDist3 = invDist * invDist * invDist;

      Fx += dx * invDist3;
      Fy += dy * invDist3;
      Fz += dz * invDist3;
    }

    vx[hook(5, i)] += dt * Fx;
    vy[hook(6, i)] += dt * Fy;
    vz[hook(7, i)] += dt * Fz;
  }
}