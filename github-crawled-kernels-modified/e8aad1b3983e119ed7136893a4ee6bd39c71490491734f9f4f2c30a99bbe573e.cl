//{"density_field":5,"particleCount":0,"preCheck":6,"px":2,"py":3,"pz":4,"radius":1,"xcount":7,"xmax":13,"xmin":10,"ycount":8,"ymax":14,"ymin":11,"zcount":9,"zmax":15,"zmin":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float default_kernel(const float dx, const float dy, const float dz, const float h, const float invh6) {
  float cudiff = h * h - (dx * dx + dy * dy + dz * dz);
  if (cudiff < 0)
    return 0.0;
  return invh6 * cudiff * cudiff * cudiff;
}

kernel void density_field(const unsigned particleCount, float radius, global float* px, global float* py, global float* pz, global float* density_field, local unsigned int* preCheck, unsigned int xcount, unsigned int ycount, unsigned int zcount, float xmin, float ymin, float zmin, float xmax, float ymax, float zmax) {
  radius *= 0.5;

  size_t gidx = get_global_id(0);
  size_t gidy = get_global_id(1);
  size_t gidz = get_global_id(2);

  size_t lidx = get_local_id(0);
  size_t lidy = get_local_id(1);
  size_t lidz = get_local_id(2);

  size_t lxsize = get_local_size(0);
  size_t lysize = get_local_size(1);
  size_t lzsize = get_local_size(2);
  size_t totalLocalSize = lxsize * lysize * lzsize;

  size_t localid = lidx + lidy * lxsize + lidz * lxsize * lysize;
  size_t globalid = (gidz * xcount * ycount + gidy * xcount + gidx);

  if (gidx >= xcount || gidy >= ycount || gidz >= zcount)
    return;

  density_field[hook(5, globalid)] = 0;

  const float invh6 = 35.0f / 32.0f * native_recip(pown(radius, 6));

  float cellx = xmin + (float)gidx / xcount * (xmax - xmin);
  float celly = ymin + (float)gidy / ycount * (ymax - ymin);
  float cellz = zmin + (float)gidz / zcount * (zmax - zmin);

  density_field[hook(5, globalid)] = 0.0f;

  for (unsigned int i = 0; i < particleCount; i++) {
    float dx = px[hook(2, i)] - cellx;
    float dy = py[hook(3, i)] - celly;
    float dz = pz[hook(4, i)] - cellz;

    density_field[hook(5, globalid)] += default_kernel(dx, dy, dz, radius, invh6);
  }
}