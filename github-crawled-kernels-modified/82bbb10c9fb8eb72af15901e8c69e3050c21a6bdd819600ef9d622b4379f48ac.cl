//{"n":1,"p":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct float4 {
  float x;
  float y;
  float s;
  float xp;
  float yp;
  float sp;
  float x0;
  float y0;
  int width;
  int height;
  float w;
};
kernel void asigParticula(global struct float4* p, int n) {
  int base = get_global_id(0);
  int tam = get_global_size(0);

  for (int index = base; index < n; index += tam) {
    p[hook(0, index)].x = (float)index;
    p[hook(0, index)].y = (float)index;
    p[hook(0, index)].s = (float)index;
    p[hook(0, index)].xp = (float)index;
    p[hook(0, index)].yp = (float)index;
    p[hook(0, index)].sp = (float)index;
    p[hook(0, index)].x0 = (float)index;
    p[hook(0, index)].y0 = (float)index;
    p[hook(0, index)].width = index;
    p[hook(0, index)].height = index;
    p[hook(0, index)].w = (float)index;
  }
}