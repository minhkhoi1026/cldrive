//{"a":0,"direction":3,"passOfStage":2,"stage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitonicSort(global int* a, unsigned stage, unsigned passOfStage, unsigned direction) {
  unsigned sortIncreasing = direction;
  unsigned index = get_global_id(0);

  unsigned pairDistance = 1 << (stage - passOfStage);
  unsigned blockWidth = 2 * pairDistance;

  unsigned leftIndex = (index % pairDistance) + (index / pairDistance) * blockWidth;

  unsigned rightIndex = leftIndex + pairDistance;

  int leftElement = a[hook(0, leftIndex)];
  int rightElement = a[hook(0, rightIndex)];

  unsigned sameDirectionBlockWidth = 1 << stage;

  if ((index / sameDirectionBlockWidth) % 2 == 1)
    sortIncreasing = 1 - sortIncreasing;

  int greater, lesser;
  unsigned leftBigger = leftElement > rightElement;
  greater = leftBigger ? leftElement : rightElement;
  lesser = leftBigger ? rightElement : leftElement;

  leftElement = sortIncreasing ? lesser : greater;
  rightElement = sortIncreasing ? greater : lesser;

  a[hook(0, leftIndex)] = leftElement;
  a[hook(0, rightIndex)] = rightElement;
}