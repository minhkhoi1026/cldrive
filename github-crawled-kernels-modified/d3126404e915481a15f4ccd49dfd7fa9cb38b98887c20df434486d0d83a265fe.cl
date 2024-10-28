//{"abVector":5,"deltaTime":3,"mass":2,"positionVectors":0,"vectorCount":4,"velocityVectors":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void affect(global float* positionVectors, global float* velocityVectors, global float* mass, float deltaTime, int vectorCount) {
  int id = get_global_id(0);
  int vectorNumber = id * 3;

  for (int j = 0; j < vectorCount; j++) {
    int otherVectorNumber = j * 3;

    if (vectorNumber != otherVectorNumber) {
      float abVector[3];

      for (int k = 0; k < 3; k++)
        abVector[hook(5, k)] = positionVectors[hook(0, otherVectorNumber + k)] - positionVectors[hook(0, vectorNumber + k)];

      float magnitude = sqrt(pown(abVector[hook(5, 0)], 2) + pown(abVector[hook(5, 1)], 2) + pown(abVector[hook(5, 2)], 2));
      float force = (0.00000000006674f * (mass[hook(2, id)] * mass[hook(2, j)]) / (magnitude * magnitude)) * deltaTime;

      for (int l = 0; l < 3; l++)
        velocityVectors[hook(1, vectorNumber + l)] = velocityVectors[hook(1, vectorNumber + l)] + ((abVector[hook(5, l)] / magnitude) * force);
    }
  }
}