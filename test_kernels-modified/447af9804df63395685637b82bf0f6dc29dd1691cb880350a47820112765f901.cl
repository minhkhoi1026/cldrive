//{"a":0,"passOfStage":2,"stage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sort2(global int* a, int stage, int passOfStage) {
  unsigned int sortIncreasing = 1;
  unsigned int gid = get_global_id(0);

  unsigned int pairDistance = 1 << (stage - passOfStage);
  unsigned int blockWidth = 2 * pairDistance;

  unsigned int leftId = (gid % pairDistance) + (gid / pairDistance) * blockWidth;
  unsigned int rightId = leftId + pairDistance;

  int leftElement = a[hook(0, leftId)];
  int rightElement = a[hook(0, rightId)];

  unsigned int sameDirectionBlockWidth = 1 << stage;

  sortIncreasing = ((gid / sameDirectionBlockWidth) % 2 == 1) ? (1 - sortIncreasing) : sortIncreasing;

  unsigned int leftKey = a[hook(0, leftId)];
  unsigned int rightKey = a[hook(0, rightId)];

  int greater = leftKey > rightKey ? leftElement : rightElement;
  int lesser = leftKey > rightKey ? rightElement : leftElement;

  a[hook(0, leftId)] = sortIncreasing ? lesser : greater;
  a[hook(0, rightId)] = sortIncreasing ? greater : lesser;
}