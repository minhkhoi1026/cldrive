//{"lowerLimit":1,"matrix":0,"seed":3,"upperLimit":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rand(global float* matrix, float lowerLimit, float upperLimit, int seed) {
  int iGID = get_global_id(0);
  seed = (seed * iGID) % 10000;
  int times = (66941 * seed + 92655) % 10;
  for (int i = 0; i < times; i++) {
    seed = (66941 * seed + 92655) % 10000;
  }
  matrix[hook(0, iGID)] = (upperLimit - lowerLimit) / 10000 * seed + lowerLimit;
}