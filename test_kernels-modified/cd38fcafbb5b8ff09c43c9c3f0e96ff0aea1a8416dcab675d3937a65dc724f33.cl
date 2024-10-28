//{"aux":2,"n":0,"p":1}
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

kernel void devolver_particulas(int n, global struct float4* p, global const struct float4* aux) {
  int base = get_global_id(0);
  int tam = get_global_size(0);

  for (int i = base; i < n; i += tam)
    p[hook(1, i)] = aux[hook(2, i)];
}