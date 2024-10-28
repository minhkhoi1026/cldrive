//{"frameDelta":2,"particleCount":5,"positions":1,"positionsBuffer":4,"positionsBufferSize":6,"spawnerCount":8,"spawners":7,"threshold":3,"timers":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int wang_hash(int seed) {
  seed = (seed ^ 61) ^ (seed >> 16);
  seed *= 9;
  seed = seed ^ (seed >> 4);
  seed *= 0x27d4eb2d;
  seed = seed ^ (seed >> 15);
  return abs(seed);
}

float randf(int seed) {
  return (((wang_hash(seed) % 100) - 50) / 100.0f);
}

kernel void timers(global float* timers, global float* positions, const float frameDelta, const float threshold, global float* positionsBuffer, const unsigned particleCount, const unsigned positionsBufferSize, global float* spawners, const unsigned spawnerCount) {
  int id = get_global_id(0);
  if (timers[hook(0, id)] >= threshold) {
    timers[hook(0, id)] = frameDelta * randf(threshold * frameDelta + id + particleCount);
    int spawner = wang_hash(id * spawnerCount + threshold) % spawnerCount;

    float xo = spawners[hook(7, spawner * 6 + 3)] / 2.0f;
    float yo = spawners[hook(7, spawner * 6 + 4)] / 2.0f;
    float zo = spawners[hook(7, spawner * 6 + 5)] / 2.0f;

    float x = spawners[hook(7, spawner * 6 + 0)] + (xo * (randf(id * id)));
    float y = spawners[hook(7, spawner * 6 + 1)] + (yo * (randf(threshold * id)));
    float z = spawners[hook(7, spawner * 6 + 2)] + (zo * (randf(particleCount * id)));

    positions[hook(1, (id * 3) + 0)] = x;
    positions[hook(1, (id * 3) + 1)] = y;
    positions[hook(1, (id * 3) + 2)] = z;

    for (int i = 0; i < positionsBufferSize; i++) {
      positionsBuffer[hook(4, i * particleCount * 3 + 3 * id + 0)] = x;
      positionsBuffer[hook(4, i * particleCount * 3 + 3 * id + 1)] = y;
      positionsBuffer[hook(4, i * particleCount * 3 + 3 * id + 2)] = z;
    }
  }
  timers[hook(0, id)] += frameDelta;
}