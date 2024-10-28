//{"p":0,"pesos":1}
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

kernel void calc_num_particulas(global const struct float4* restrict p, global int* restrict pesos) {
  int base = get_global_id(0);
  pesos[hook(1, base)] = round(p[hook(0, base)].w * get_global_size(0));
}