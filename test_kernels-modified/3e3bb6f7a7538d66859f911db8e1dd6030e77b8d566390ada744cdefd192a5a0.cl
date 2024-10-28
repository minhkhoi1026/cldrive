//{"N":0,"gradWeights":4,"lastUpdate":3,"learningRate":1,"momentum":2,"weights":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void updateWeights(const int N, const float learningRate, const float momentum, global float* lastUpdate, global const float* gradWeights, global float* weights) {
  const int globalId = get_global_id(0);
  if (globalId >= N) {
    return;
  }

  lastUpdate[hook(3, globalId)] = momentum * lastUpdate[hook(3, globalId)] - learningRate * gradWeights[hook(4, globalId)];

  weights[hook(5, globalId)] += lastUpdate[hook(3, globalId)];
}