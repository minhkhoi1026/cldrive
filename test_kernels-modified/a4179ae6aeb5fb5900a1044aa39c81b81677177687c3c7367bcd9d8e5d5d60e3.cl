//{"N":0,"cells":1,"links":2,"nx":12,"ny":13,"nz":14,"px":3,"py":4,"pz":5,"xmax":9,"xmin":6,"ymax":10,"ymin":7,"zmax":11,"zmin":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_cells(const unsigned int N, global int* cells, global int* links, global float* px, global float* py, global float* pz, const float xmin, const float ymin, const float zmin, const float xmax, const float ymax, const float zmax, const unsigned int nx, const unsigned int ny, const unsigned int nz) {
  const int globalid = get_global_id(0);
  if (globalid >= N)
    return;

  const int xindex = (px[hook(3, globalid)] - xmin) / (xmax - xmin) * nx;
  const int yindex = (py[hook(4, globalid)] - ymin) / (ymax - ymin) * ny;
  const int zindex = (pz[hook(5, globalid)] - zmin) / (zmax - zmin) * nz;

  if (xindex < 0 || xindex >= nx || yindex < 0 || yindex >= ny || zindex < 0 || zindex >= nz)
    return;

  size_t cellindex = zindex * nx * ny + yindex * nx + xindex;

  links[hook(2, globalid)] = atomic_xchg(cells + cellindex, links[hook(2, globalid)]);
}