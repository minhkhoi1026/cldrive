//{"aux":1,"p":0}
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

kernel void devolver_particulas(global struct float4* restrict p, global const struct float4* restrict aux) {
  int base = get_global_id(0);
  p[hook(0, base)] = aux[hook(1, base)];
}