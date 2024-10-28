//{"height":3,"in":0,"out":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Stencil4(global float* in, global float* out, int width, int height) {
  int globalIDx = get_global_id(0);
  int localIDx = get_local_id(0);
  int localIDy = get_local_id(1);
  int group = get_group_id(0);
  int pos = 0;
  int from = (((height - 2) * localIDy) / 4) + 1;

  for (int line = from; line < height - 1; line++) {
    pos = globalIDx + 1 + (width * line);
    out[hook(1, pos)] = (in[hook(0, pos - 1)] + in[hook(0, pos + 1)] + in[hook(0, pos - width)] + in[hook(0, pos + width)]) / 4;
  }
}