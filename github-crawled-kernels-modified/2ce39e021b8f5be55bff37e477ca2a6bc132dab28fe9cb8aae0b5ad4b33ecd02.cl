//{"height":3,"in":0,"out":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Stencil2(global float* in, global float* out, int width, int height) {
  int2 globalID = (int2)(get_global_id(0), get_global_id(1));

  int pos = globalID.x + 1 + (globalID.y + 1) * width;
  out[hook(1, pos)] = (in[hook(0, pos - 1)] + in[hook(0, pos + 1)] + in[hook(0, pos - width)] + in[hook(0, pos + width)]) / 4;
}