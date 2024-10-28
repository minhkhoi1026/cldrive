//{"height":3,"in":0,"numberPoints":6,"out":1,"positions":4,"weights":5,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dynamicStencil1_Copy_kernel(global float* in, global float* out, int width, int height, global int* positions, global float* weights, int numberPoints) {
  int2 globalID = (int2)(get_global_id(0), get_global_id(1));

  int pos = globalID.x + 1 + (globalID.y + 1) * width;
  out[hook(1, pos)] = in[hook(0, pos)];
}