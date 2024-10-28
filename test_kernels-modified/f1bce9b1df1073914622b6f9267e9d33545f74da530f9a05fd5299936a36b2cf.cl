//{"colors":5,"mAmplitude":3,"numNodes":4,"pBodyTimes":1,"posOrnColors":0,"timeStepPos":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sineWaveKernel(global float4* posOrnColors, global float* pBodyTimes, float timeStepPos, float mAmplitude, const int numNodes) {
  int nodeID = get_global_id(0);
  if (nodeID < numNodes) {
    pBodyTimes[hook(1, nodeID)] += timeStepPos;
    float4 position = posOrnColors[hook(0, nodeID)];
    position.x = native_cos(pBodyTimes[hook(1, nodeID)] * 2.17f) * mAmplitude + native_sin(pBodyTimes[hook(1, nodeID)]) * mAmplitude * 0.5f;
    position.y = native_cos(pBodyTimes[hook(1, nodeID)] * 1.38f) * mAmplitude + native_sin(pBodyTimes[hook(1, nodeID)] * mAmplitude);
    position.z = native_cos(pBodyTimes[hook(1, nodeID)] * 2.17f) * mAmplitude + native_sin(pBodyTimes[hook(1, nodeID)] * 0.777f) * mAmplitude;

    posOrnColors[hook(0, nodeID)] = position;
    global float4* colors = &posOrnColors[hook(0, numNodes * 2)];
    colors[hook(5, nodeID)] = (float4)(0, 0, 1, 1);
  }
}