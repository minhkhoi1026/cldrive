//{"corners":0,"count":1,"passOfStage":3,"stage":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sortCorners_bitonicSort(global float2* corners, const int count, const int stage, const int passOfStage) {
  const int threadId = get_global_id(0);
  if (threadId >= count / 2) {
    return;
  }

  const int sortOrder = (((threadId / (1 << stage)) % 2)) == 1 ? 1 : 0;

  const int pairDistance = 1 << (stage - passOfStage);
  const int blockWidth = 2 * pairDistance;

  const int leftId = min((threadId % pairDistance) + (threadId / pairDistance) * blockWidth, count);

  const int rightId = min(leftId + pairDistance, count);

  const float2 leftPt = corners[hook(0, leftId)];
  const float2 rightPt = corners[hook(0, rightId)];

  const float leftVal = leftPt.x;
  const float rightVal = rightPt.x;

  const bool compareResult = leftVal > rightVal;

  float2 greater = compareResult ? leftPt : rightPt;
  float2 lesser = compareResult ? rightPt : leftPt;

  corners[hook(0, leftId)] = sortOrder ? lesser : greater;
  corners[hook(0, rightId)] = sortOrder ? greater : lesser;
}