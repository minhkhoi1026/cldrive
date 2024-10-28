//{"direction":8,"height":6,"image":4,"origin":7,"particleCount":0,"px":1,"py":2,"pz":3,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void render(const unsigned particleCount, global float* px, global float* py, global float* pz, global float* image, unsigned int width, unsigned int height, float4 origin, float4 direction) {
  size_t gidx = get_global_id(0);
  size_t gidy = get_global_id(1);
  size_t globalid = (gidy * width + gidx) * 3;
  if (gidx >= width || gidy >= height)
    return;

  float4 dir = {(float)gidx / width * 2.0 - 1.0, (float)gidy / height * 2.0 - 1.0, -1.0, 0.0};
  dir = normalize(dir);

  image[hook(4, globalid + 0)] = 0;
  image[hook(4, globalid + 1)] = 0;
  image[hook(4, globalid + 2)] = 0;

  for (unsigned int i = 0; i < 32; i++) {
    float t = (px[hook(1, i)] - origin.x) * dir.x + (py[hook(2, i)] - origin.y) * dir.y + (pz[hook(3, i)] - origin.z) * dir.z;

    float tx = origin.x + t * dir.x;
    float ty = origin.y + t * dir.y;
    float tz = origin.z + t * dir.z;

    float sum = 0;
    for (unsigned int n = i; n < 32; n++) {
      float dx = px[hook(1, n)] - tx;
      float dy = py[hook(2, n)] - ty;
      float dz = pz[hook(3, n)] - tz;

      float r2 = (dx * dx + dy * dy + dz * dz);
      sum += 1.0 / r2;

      if (sum > 100) {
        image[hook(4, globalid + 0)] = t / 2.0;
        image[hook(4, globalid + 1)] = t / 4.0;
        image[hook(4, globalid + 2)] = t / 8.0;
        break;
      }
    }
  }
}