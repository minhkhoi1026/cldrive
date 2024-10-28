//{"g_angle":2,"g_magn":1,"height":4,"img":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void atomic_add_local(volatile local float* source, const float operand) {
  union {
    unsigned int vint;
    float vfloat;
  } newval;

  union {
    unsigned int vint;
    float vfloat;
  } prevval;

  do {
    prevval.vfloat = *source;
    newval.vfloat = prevval.vfloat + operand;
  } while (atom_cmpxchg((volatile local unsigned int*)source, prevval.vint, newval.vint) != prevval.vint);
}

kernel void compute_gradient(global uchar* img, global float* g_magn, global float* g_angle, int width, int height) {
  int global_x = (int)get_global_id(0);
  int global_y = (int)get_global_id(1);

  if (global_x >= width || global_y >= height) {
    return;
  }

  if (global_x == 0 || global_y == 0 || global_x == width - 1 || global_y == height - 1) {
    g_magn[hook(1, global_x + global_y * width)] = 0;
    g_angle[hook(2, global_x + global_y * width)] = 0;
    return;
  }

  float vert = img[hook(0, (global_x + 1) + global_y * width)] - img[hook(0, (global_x - 1) + global_y * width)];
  float horiz = img[hook(0, global_x + (global_y + 1) * width)] - img[hook(0, global_x + (global_y - 1) * width)];

  g_magn[hook(1, global_x + global_y * width)] = sqrt(vert * vert + horiz * horiz);

  float angle = (horiz != 0) ? atan(vert / horiz) * 180.0 / 3.14159265358979323846f : 0;
  g_angle[hook(2, global_x + global_y * width)] = (angle < 0) ? angle + 180 : angle;
}