//{"data":0,"image":2,"region":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float3 ps5_cross(float3 a, float3 b) {
  float3 c;
  c.x = a.y * b.z - a.z * b.y;
  c.y = a.z * b.x - a.x * b.z;
  c.z = a.x * b.y - a.y * b.x;

  return c;
}

float3 ps5_normalize(float3 v) {
  float l = sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
  v.x /= l;
  v.y /= l;
  v.z /= l;

  return v;
}

float3 ps5_add(float3 a, float3 b) {
  a.x += b.x;
  a.y += b.y;
  a.z += b.z;

  return a;
}

float3 ps5_scale(float3 a, float b) {
  a.x *= b;
  a.y *= b;
  a.z *= b;

  return a;
}

int ps5_index(int z, int y, int x) {
  return z * 512 * 512 + y * 512 + x;
}

int ps5_inside(float3 pos) {
  int x = (pos.x >= 0 && pos.x < 512 - 1);
  int y = (pos.y >= 0 && pos.y < 512 - 1);
  int z = (pos.z >= 0 && pos.z < 512 - 1);

  return x && y && z;
}

float ps5_value_at(float3 pos, unsigned char* data) {
  if (!ps5_inside(pos)) {
    return 0;
  }

  int x = floor(pos.x);
  int y = floor(pos.y);
  int z = floor(pos.z);

  int x_u = ceil(pos.x);
  int y_u = ceil(pos.y);
  int z_u = ceil(pos.z);

  float rx = pos.x - x;
  float ry = pos.y - y;
  float rz = pos.z - z;

  float a0 = rx * data[hook(0, ps5_index(z, y, x))] + (1 - rx) * data[hook(0, ps5_index(z, y, x_u))];
  float a1 = rx * data[hook(0, ps5_index(z, y_u, x))] + (1 - rx) * data[hook(0, ps5_index(z, y_u, x_u))];
  float a2 = rx * data[hook(0, ps5_index(z_u, y, x))] + (1 - rx) * data[hook(0, ps5_index(z_u, y, x_u))];
  float a3 = rx * data[hook(0, ps5_index(z_u, y_u, x))] + (1 - rx) * data[hook(0, ps5_index(z_u, y_u, x_u))];

  float b0 = ry * a0 + (1 - ry) * a1;
  float b1 = ry * a2 + (1 - ry) * a3;

  float c0 = rz * b0 + (1 - rz) * b1;

  return c0;
}

kernel void raycast(global unsigned char* data, global unsigned char* region, global unsigned char* image) {
  int id = get_global_id(0);

  float3 camera;
  camera.x = 1000;
  camera.y = 1000;
  camera.z = 1000;
  float3 forward;
  forward.x = -1;
  forward.y = -1;
  forward.z = -1;
  float3 z_axis;
  z_axis.x = 0;
  z_axis.y = 0;
  z_axis.z = 1;

  float3 right = ps5_cross(forward, z_axis);
  float3 up = ps5_cross(right, forward);

  forward = ps5_normalize(forward);
  right = ps5_normalize(right);
  up = ps5_normalize(up);

  float fov = 3.14 / 4;
  float pixel_width = tan(fov / 2.0) / (64 / 2);
  float step_size = 0.5;

  int x = -64 / 2 + id % 64;
  int y = -64 / 2 + id / 64;

  float3 screen_center = ps5_add(camera, forward);
  float3 ray = ps5_add(ps5_add(screen_center, ps5_scale(right, x * pixel_width)), ps5_scale(up, y * pixel_width));
  ray = ps5_add(ray, ps5_scale(camera, -1));
  ray = ps5_normalize(ray);
  float3 pos = camera;

  int i = 0;
  float float3 = 0;
  while (float3 < 255 && i < 5000) {
    i++;
    pos = ps5_add(pos, ps5_scale(ray, step_size));
    int r = ps5_value_at(pos, *region);
    float3 += ps5_value_at(pos, *data) * (0.01 + r);
  }

  image[hook(2, (y + (64 / 2)) * 64 + (x + (64 / 2)))] = float3 > 255 ? 255 : float3;
}