//{"n":1,"p":0,"pesos":2}
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

kernel void calc_num_particulas(global struct float4* p, int n, global int* pesos) {
  int base = get_global_id(0);
  int tam = get_global_size(0);

  for (int i = base; i < n; i += tam) {
    pesos[hook(2, i)] = round(p[hook(0, i)].w * n);
  }
}