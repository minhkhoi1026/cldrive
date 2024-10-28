//{"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct Thing {
  float x;
  float y;
};
struct Thing a(float y) {
  struct Thing x;
  x.x = y + 42.0f;
  x.y = y + 2.0f;
  return x;
}
float b(float y) {
  return a(y).x * a(y).y;
}

kernel void __attribute__((reqd_work_group_size(42, 13, 2))) foo(global float* x, float y) {
  *x = b(y);
}