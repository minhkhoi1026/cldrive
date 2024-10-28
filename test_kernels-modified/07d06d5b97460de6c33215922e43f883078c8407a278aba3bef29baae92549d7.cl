//{"p":0,"pos":1,"source":2,"time":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void source(global float* p, constant int* pos, global float* source, const unsigned time) {
  const int ix = get_global_id(0);
  const int x = pos[hook(1, ((ix) * 3 + (0)))];
  const int y = pos[hook(1, ((ix) * 3 + (1)))];
  const int z = pos[hook(1, ((ix) * 3 + (2)))];

  p[hook(0, ((z) * 128 * 256 + (y) * 256 + (x)))] += source[hook(2, ((ix) * 3200 + (time)))];
}