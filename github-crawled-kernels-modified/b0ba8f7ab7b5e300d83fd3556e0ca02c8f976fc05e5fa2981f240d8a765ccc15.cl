//{"field":0,"height":2,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void resetBuffer3D(global float* field, int width, int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = get_global_id(2);
  int index = x + y * width + z * width * height;
  for (int i = 0; i < 3; ++i) {
    field[hook(0, 3 * index + i)] = 0.0f;
  }
}