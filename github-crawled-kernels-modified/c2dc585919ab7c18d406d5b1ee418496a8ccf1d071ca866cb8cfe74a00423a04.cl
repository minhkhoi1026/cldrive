//{"dest":1,"height":3,"mask":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mask(global float* mask, global float* dest, int width, int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x < width && y < height) {
    const int idx = y * width + x;
    const float value = mask[hook(0, idx)];
    if (value) {
      dest[hook(1, idx)] = value;
    }
  }
}