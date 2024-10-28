//{"trianglesCount":1,"vertices":0,"volumes":2,"workSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float det(const float ax, const float ay, const float az, const float bx, const float by, const float bz, const float cx, const float cy, const float cz);
kernel void calc(global float* vertices, global int* trianglesCount, global float* volumes, const int workSize) {
  int gid = get_global_id(0);
  if (gid >= workSize) {
    gid = 0;
  }
  int offset = 0;
  for (int i = 0; i < gid; i++) {
    offset = offset + trianglesCount[hook(1, i)] * 9;
  }
  float sum = 0;
  for (int i = offset; i < offset + trianglesCount[hook(1, gid)] * 9; i += 9) {
    float d = det(vertices[hook(0, i + 0)], vertices[hook(0, i + 1)], vertices[hook(0, i + 2)], vertices[hook(0, i + 3)], vertices[hook(0, i + 4)], vertices[hook(0, i + 5)], vertices[hook(0, i + 6)], vertices[hook(0, i + 7)], vertices[hook(0, i + 8)]);
    sum += d;
  }
  volumes[hook(2, gid)] = sum / 6;
  if (volumes[hook(2, gid)] < 0) {
    volumes[hook(2, gid)] = volumes[hook(2, gid)] * (-1);
  }
}