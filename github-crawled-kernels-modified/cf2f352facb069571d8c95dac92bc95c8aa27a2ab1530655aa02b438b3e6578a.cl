//{"a":2,"depth":6,"dest":0,"div":3,"height":5,"source":1,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void diffuse(global float* dest, global float* source, float a, float div, int width, int height, int depth) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = get_global_id(2);
  int wh = width * height;
  int index = x + y * width + z * wh;

  float val = (source[hook(1, index)] + a * (dest[hook(0, index - 1)] + dest[hook(0, index + 1)] + dest[hook(0, index - width)] + dest[hook(0, index + width)] + dest[hook(0, index - wh)] + dest[hook(0, index + wh)])) / div;
  dest[hook(0, index)] = val;
}