//{"add_x":4,"add_y":5,"field":0,"height":8,"px":1,"py":2,"pz":3,"radius":6,"width":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addSource3D(global float* field, int px, int py, int pz, float add_x, float add_y, float radius, int width, int height) {
  const int xpos = get_global_id(0);
  const int ypos = get_global_id(1);
  const int zpos = get_global_id(2);
  const float dx = (float)xpos - px;
  const float dy = (float)ypos - py;
  const float dz = (float)zpos - pz;
  const float d_sq = dx * dx + dy * dy;
  if (d_sq <= radius * radius) {
    float3 value = (float3)(add_x, add_y, 0);
    int index = xpos + ypos * width + zpos * width * height;
    field[hook(0, 3 * index)] += value.x;
    field[hook(0, 3 * index + 1)] += value.y;
    field[hook(0, 3 * index + 2)] = 0;
  }
}