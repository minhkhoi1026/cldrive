//{"N":0,"cells":14,"dt":1,"epsilon":2,"fx":11,"fy":12,"fz":13,"links":15,"m":4,"nx":22,"ny":23,"nz":24,"px":5,"py":6,"pz":7,"r_cut":25,"sigma":3,"vx":8,"vy":9,"vz":10,"xmax":19,"xmin":16,"ymax":20,"ymin":17,"zmax":21,"zmin":18}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_velocities(const unsigned int N, const float dt, const float epsilon, const float sigma, global float* m, global float* px, global float* py, global float* pz, global float* vx, global float* vy, global float* vz, global float* fx, global float* fy, global float* fz, global int* cells, global int* links, const float xmin, const float ymin, const float zmin, const float xmax, const float ymax, const float zmax, const unsigned int nx, const unsigned int ny, const unsigned int nz, const float r_cut) {
  const int globalid = get_global_id(0);
  if (globalid >= N)
    return;

  float new_force_x = 0.0;
  float new_force_y = 0.0;
  float new_force_z = 0.0;

  const int xindex = (px[hook(5, globalid)] - xmin) / (xmax - xmin) * nx;
  const int yindex = (py[hook(6, globalid)] - ymin) / (ymax - ymin) * ny;
  const int zindex = (pz[hook(7, globalid)] - zmin) / (zmax - zmin) * nz;

  for (int iz = -1; iz <= 1; iz++) {
    for (int iy = -1; iy <= 1; iy++) {
      for (int ix = -1; ix <= 1; ix++) {
        int xlocal = xindex + ix;
        int ylocal = yindex + iy;
        int zlocal = zindex + iz;

        bool xwrapover = false;
        bool ywrapover = false;
        bool zwrapover = false;

        if (xlocal >= nx || xlocal < 0)
          xwrapover = true;
        if (ylocal >= ny || ylocal < 0)
          ywrapover = true;
        if (zlocal >= nz || zlocal < 0)
          zwrapover = true;

        xlocal %= nx;
        ylocal %= ny;
        zlocal %= nz;

        const int cellindex = zlocal * nx * ny + ylocal * nx + xlocal;
        int index = cells[hook(14, cellindex)];

        while (index != -1) {
          if (index != globalid) {
            float dx = px[hook(5, globalid)] - px[hook(5, index)];
            float dy = py[hook(6, globalid)] - py[hook(6, index)];
            float dz = pz[hook(7, globalid)] - pz[hook(7, index)];

            if (xwrapover)
              dx = (xmax - xmin) - dx;
            if (ywrapover)
              dy = (ymax - ymin) - dy;
            if (zwrapover)
              dz = (zmax - zmin) - dz;

            float sqlength = (dx * dx + dy * dy + dz * dz);
            if (sqlength <= r_cut * r_cut) {
              float sigma6 = sigma * sigma * sigma * sigma * sigma * sigma;

              float factor = 24.0 * epsilon / sqlength * sigma6 / (sqlength * sqlength * sqlength) * (2.0 * sigma6 / (sqlength * sqlength * sqlength) - 1.0);

              new_force_x += factor * dx;
              new_force_y += factor * dy;
              new_force_z += factor * dz;
            }
          }
          index = links[hook(15, index)];
        }
      }
    }
  }

  vx[hook(8, globalid)] += (fx[hook(11, globalid)] + new_force_x) * dt * 0.5 / m[hook(4, globalid)];
  vy[hook(9, globalid)] += (fy[hook(12, globalid)] + new_force_y) * dt * 0.5 / m[hook(4, globalid)];
  vz[hook(10, globalid)] += (fz[hook(13, globalid)] + new_force_z) * dt * 0.5 / m[hook(4, globalid)];

  fx[hook(11, globalid)] = new_force_x;
  fy[hook(12, globalid)] = new_force_y;
  fz[hook(13, globalid)] = new_force_z;
}