//{"b":2,"len":0,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int reduce_int(int v) {
  return v;
}
int reduce_int2(int2 v) {
  return v.x + v.y;
}
int reduce_int4(int4 v) {
  return v.x + v.y + v.z + v.w;
}

int init_val_int(int i) {
  return i;
}
int2 init_val_int2(int i) {
  return (int2)(i, i);
}
int4 init_val_int4(int i) {
  return (int4)(i, i, i, i);
}

int first_element_int(int v) {
  return v;
}
int first_element_int2(int2 v) {
  return v.x;
}
int first_element_int4(int4 v) {
  return v.x;
}

int assign_element_int(int4 v) {
  return v.x;
}
int2 assign_element_int2(int4 v) {
  return (int2)(v.x, v.y);
}
int4 assign_element_int4(int4 v) {
  return (int4)(v.x, v.y, v.z, v.w);
}

unsigned int displacement_int(int v, unsigned int offset) {
  return v + offset;
}
unsigned int displacement_int2(int2 v, unsigned int offset) {
  return v.x + v.y + offset;
}
unsigned int displacement_int4(int4 v, unsigned int offset) {
  return v.x + v.y + v.z + v.w + offset;
}
kernel void fill_buffer(unsigned int len, unsigned int v, global unsigned int* b) {
  int gid = get_global_id(0);
  while (gid < len) {
    b[hook(2, gid)] = v;
    gid += get_global_size(0);
  }
}