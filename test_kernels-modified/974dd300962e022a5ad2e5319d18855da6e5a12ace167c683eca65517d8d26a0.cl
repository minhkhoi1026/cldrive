//{"localPattern":7,"maxSearchLength":6,"pattern":2,"patternLength":3,"resultBuffer":4,"resultCountPerWG":5,"stack1":8,"text":0,"textLength":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int compare(global const uchar* text, local const uchar* pattern, unsigned int length) {
  for (unsigned int l = 0; l < length; ++l) {
    if ((('A' <= (text[hook(0, l)]) && (text[hook(0, l)]) <= 'Z') ? ((text[hook(0, l)] - 'A') + 'a') : (text[hook(0, l)])) != pattern[hook(2, l)])
      return 0;
  }
  return 1;
}
kernel void StringSearchLoadBalance(global uchar* text, const unsigned int textLength, global const uchar* pattern, const unsigned int patternLength, global int* resultBuffer, global int* resultCountPerWG, const unsigned int maxSearchLength, local uchar* localPattern, local int* stack1

) {
  int localIdx = get_local_id(0);
  int localSize = get_local_size(0);
  int groupIdx = get_group_id(0);

  local unsigned int stack1Counter;
  local unsigned int stack2Counter;
  local unsigned int groupSuccessCounter;

  if (localIdx == 0) {
    groupSuccessCounter = 0;
    stack1Counter = 0;
    stack2Counter = 0;
  }

  unsigned int lastSearchIdx = textLength - patternLength + 1;
  unsigned int stackSize = 0;

  unsigned int beginSearchIdx = groupIdx * maxSearchLength;
  unsigned int endSearchIdx = beginSearchIdx + maxSearchLength;
  if (beginSearchIdx > lastSearchIdx)
    return;
  if (endSearchIdx > lastSearchIdx)
    endSearchIdx = lastSearchIdx;
  unsigned int searchLength = endSearchIdx - beginSearchIdx;

  for (unsigned int idx = localIdx; idx < patternLength; idx += localSize) {
    localPattern[hook(7, idx)] = (('A' <= (pattern[hook(2, idx)]) && (pattern[hook(2, idx)]) <= 'Z') ? ((pattern[hook(2, idx)] - 'A') + 'a') : (pattern[hook(2, idx)]));
  }

  barrier(0x01);

  uchar first = localPattern[hook(7, 0)];
  uchar second = localPattern[hook(7, 1)];
  int stringPos = localIdx;
  int stackPos = 0;
  int revStackPos = 0;

  while (true) {
    if (stringPos < searchLength) {
      if ((first == (('A' <= (text[hook(0, beginSearchIdx + stringPos)]) && (text[hook(0, beginSearchIdx + stringPos)]) <= 'Z') ? ((text[hook(0, beginSearchIdx + stringPos)] - 'A') + 'a') : (text[hook(0, beginSearchIdx + stringPos)]))) && (second == (('A' <= (text[hook(0, beginSearchIdx + stringPos + 1)]) && (text[hook(0, beginSearchIdx + stringPos + 1)]) <= 'Z') ? ((text[hook(0, beginSearchIdx + stringPos + 1)] - 'A') + 'a') : (text[hook(0, beginSearchIdx + stringPos + 1)]))))

      {
        stackPos = atomic_inc(&stack1Counter);
        stack1[hook(8, stackPos)] = stringPos;
      }
    }

    stringPos += localSize;

    barrier(0x01);
    stackSize = stack1Counter;
    barrier(0x01);

    if ((stackSize < localSize) && ((((stringPos) / localSize) * localSize) < searchLength))
      continue;
    if (localIdx < stackSize) {
      revStackPos = atomic_dec(&stack1Counter);
      int pos = stack1[hook(8, --revStackPos)];
      if (compare(text + beginSearchIdx + pos + 2, localPattern + 2, patternLength - 2) == 1)

      {
        int count = atomic_inc(&groupSuccessCounter);
        resultBuffer[hook(4, beginSearchIdx + count)] = beginSearchIdx + pos;
      }
    }

    barrier(0x01);
    if ((((stringPos / localSize) * localSize) >= searchLength) && (stack1Counter <= 0) && (stack2Counter <= 0))
      break;
  }

  if (localIdx == 0)
    resultCountPerWG[hook(5, groupIdx)] = groupSuccessCounter;
}