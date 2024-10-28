//{"a":2,"depth":6,"div":3,"field":0,"height":5,"source":1,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void diffuse3D(global float* field, global float* source, float a, float div, int width, int height, int depth) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = get_global_id(2);
  int wh = width * height;
  int vindex = x + y * width + z * wh;

  for (int i = 0; i < 3; ++i) {
    int index = 3 * vindex + i;
    float val = (source[hook(1, index)] + a * (field[hook(0, 3 * (vindex - 1) + i)] + field[hook(0, 3 * (vindex + 1) + i)] + field[hook(0, 3 * (vindex - width) + i)] + field[hook(0, 3 * (vindex + width) + i)] + field[hook(0, 3 * (vindex - wh) + i)] + field[hook(0, 3 * (vindex + wh) + i)])) / div;
    field[hook(0, index)] = val;
  }
}