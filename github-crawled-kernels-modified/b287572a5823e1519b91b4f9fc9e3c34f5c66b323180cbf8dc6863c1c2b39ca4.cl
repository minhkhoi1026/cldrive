//{"mic":2,"p":0,"pos":1,"time":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mic(global float* p, constant int* pos, global float* mic, const unsigned time) {
  const int ix = get_global_id(0);

  const int x = pos[hook(1, ((ix) * 3 + (0)))];
  const int y = pos[hook(1, ((ix) * 3 + (1)))];
  const int z = pos[hook(1, ((ix) * 3 + (2)))];

  mic[hook(2, ((ix) * 1 + (time)))] = p[hook(0, ((z) * 128 * 256 + (y) * 256 + (x)))];
}