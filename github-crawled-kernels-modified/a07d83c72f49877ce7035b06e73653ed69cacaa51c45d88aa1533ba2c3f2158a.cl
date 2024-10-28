//{"mA":1,"mB":2,"mO":0,"widthA":3,"widthB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multMatrixSimple(global float* mO, global float* mA, global float* mB, unsigned int widthA, unsigned int widthB) {
  int globalIdx = get_global_id(0);
  int globalIdy = get_global_id(1);

  float sum = 0;

  for (int i = 0; i < widthA; i++) {
    float tempA = mA[hook(1, globalIdy * widthA + i)];
    float tempB = mB[hook(2, i * widthB + globalIdx)];
    sum += tempA * tempB;
  }

  mO[hook(0, globalIdy * widthA + globalIdx)] = sum;
}