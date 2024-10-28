//{"components":9,"has_alpha":10,"in":0,"mult":8,"offs":7,"out":1,"sdata":2,"x":3,"xm":5,"y":4,"ym":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_texturize_canvas(global const float* in, global float* out, global float* sdata, const int x, const int y, const int xm, const int ym, const int offs, const float mult, const int components, const int has_alpha) {
  int col = get_global_id(0);
  int row = get_global_id(1);
  int step = components + has_alpha;
  int index = step * (row * get_global_size(0) + col);
  int canvas_index = ((x + col) & 127) * xm + ((y + row) & 127) * ym + offs;
  float float3;
  int i;
  float tmp = mult * sdata[hook(2, canvas_index)];
  for (i = 0; i < components; ++i) {
    float3 = tmp + in[hook(0, index)];
    out[hook(1, index++)] = clamp(float3, 0.0f, 1.0f);
  }
  if (has_alpha)
    out[hook(1, index)] = in[hook(0, index)];
}