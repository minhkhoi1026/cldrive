//{"add":4,"field":0,"height":7,"px":1,"py":2,"pz":3,"radius":5,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addSource(global float* field, int px, int py, int pz, float add, float radius, int width, int height) {
  const int xpos = get_global_id(0);
  const int ypos = get_global_id(1);
  const int zpos = get_global_id(2);
  const float dx = (float)xpos - px;
  const float dy = (float)ypos - py;
  const float dz = (float)zpos - pz;
  const float d_sq = dx * dx + dy * dy;
  if (d_sq <= radius * radius) {
    float value = add;
    int index = xpos + ypos * width + zpos * width * height;
    field[hook(0, index)] += value;
  }
}