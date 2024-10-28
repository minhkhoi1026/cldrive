//{"dimx":1,"dimy":2,"positions":0,"seed":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float rand(int x) {
  x = (x << 13) ^ x;
  return (1.0 - ((x * (x * x * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0);
}

kernel void random(global float* positions, int const dimx, int const dimy, unsigned int const seed) {
  int id = get_global_id(0);
  positions[hook(0, 2 * id + 0)] = rand(seed * id);
  positions[hook(0, 2 * id + 1)] = rand(seed ^ id);
}