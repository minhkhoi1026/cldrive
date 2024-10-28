//{"count":2,"keys":0,"passOfStage":4,"stage":3,"vals":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitonicSort(global float* keys, global float* vals, int count, int stage, int passOfStage) {
  const int threadId = get_global_id(0);
  if (threadId >= count / 2) {
    return;
  }
  const int pairDistance = 1 << (stage - passOfStage);
  const int blockWidth = 2 * pairDistance;

  int leftId = min((threadId % pairDistance) + (threadId / pairDistance) * blockWidth, count);

  int rightId = min(leftId + pairDistance, count);

  int temp;

  const float lval = vals[hook(1, leftId)];
  const float rval = vals[hook(1, rightId)];

  const float lkey = keys[hook(0, leftId)];
  const float rkey = keys[hook(0, rightId)];

  int sameDirectionBlockWidth = 1 << stage;

  if ((threadId / sameDirectionBlockWidth) % 2 == 1) {
    temp = rightId;
    rightId = leftId;
    leftId = temp;
  }

  const bool compareResult = ((lkey) < (rkey));

  if (compareResult) {
    keys[hook(0, rightId)] = rkey;
    keys[hook(0, leftId)] = lkey;
    vals[hook(1, rightId)] = rval;
    vals[hook(1, leftId)] = lval;
  } else {
    keys[hook(0, rightId)] = lkey;
    keys[hook(0, leftId)] = rkey;
    vals[hook(1, rightId)] = lval;
    vals[hook(1, leftId)] = rval;
  }
}