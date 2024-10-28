//{"numNodes":1,"pass":2,"pathDistanceBuffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void floydWarshallPass(global int* pathDistanceBuffer, const unsigned int numNodes, const unsigned int pass) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int k = pass;

  int temp = (pathDistanceBuffer[hook(0, y * numNodes + k)] + pathDistanceBuffer[hook(0, k * numNodes + x)]);

  if (temp < pathDistanceBuffer[hook(0, y * numNodes + x)]) {
    pathDistanceBuffer[hook(0, y * numNodes + x)] = temp;
  }
}