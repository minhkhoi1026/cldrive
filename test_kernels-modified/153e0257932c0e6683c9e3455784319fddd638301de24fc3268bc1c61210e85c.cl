//{"pass":3,"pathBuffer":1,"pathDistanceBuffer":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int uintMin(unsigned int a, unsigned int b) {
  return (b < a) ? b : a;
}
kernel void floydWarshallPass(global unsigned int* pathDistanceBuffer, global unsigned int* pathBuffer, const unsigned int width, const unsigned int pass) {
  unsigned int x = get_local_id(0);
  unsigned int y = get_group_id(0);

  unsigned int k = pass;
  unsigned int yXwidth = y * width;

  unsigned int distanceYtoX = pathDistanceBuffer[hook(0, yXwidth + x)];

  unsigned int distanceYtoK = pathDistanceBuffer[hook(0, yXwidth + k)];
  unsigned int distanceKtoX = pathDistanceBuffer[hook(0, k * width + x)];

  unsigned int indirectDistance = distanceYtoK + distanceKtoX;

  if (indirectDistance < distanceYtoX) {
    pathDistanceBuffer[hook(0, yXwidth + x)] = indirectDistance;
    pathBuffer[hook(1, yXwidth + x)] = k;
  }
  pathDistanceBuffer[hook(0, yXwidth + x)] = uintMin(pathDistanceBuffer[hook(0, yXwidth + x)], pathDistanceBuffer[hook(0, yXwidth + k)] + pathDistanceBuffer[hook(0, k * width + x)]);
}