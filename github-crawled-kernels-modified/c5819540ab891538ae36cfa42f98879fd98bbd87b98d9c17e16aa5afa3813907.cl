//{"localPattern":7,"maxSearchLength":6,"pattern":2,"patternLength":3,"resultBuffer":4,"resultCountPerWG":5,"text":0,"textLength":1}
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
kernel void StringSearchNaive(global uchar* text, const unsigned int textLength, global const uchar* pattern, const unsigned int patternLength, global int* resultBuffer, global int* resultCountPerWG, const unsigned int maxSearchLength, local uchar* localPattern) {
  local volatile unsigned int groupSuccessCounter;

  int localIdx = get_local_id(0);
  int localSize = get_local_size(0);
  int groupIdx = get_group_id(0);

  unsigned int lastSearchIdx = textLength - patternLength + 1;

  unsigned int beginSearchIdx = groupIdx * maxSearchLength;
  unsigned int endSearchIdx = beginSearchIdx + maxSearchLength;
  if (beginSearchIdx > lastSearchIdx)
    return;
  if (endSearchIdx > lastSearchIdx)
    endSearchIdx = lastSearchIdx;

  for (int idx = localIdx; idx < patternLength; idx += localSize) {
    localPattern[hook(7, idx)] = (('A' <= (pattern[hook(2, idx)]) && (pattern[hook(2, idx)]) <= 'Z') ? ((pattern[hook(2, idx)] - 'A') + 'a') : (pattern[hook(2, idx)]));
  }

  if (localIdx == 0)
    groupSuccessCounter = 0;
  barrier(0x01);

  for (unsigned int stringPos = beginSearchIdx + localIdx; stringPos < endSearchIdx; stringPos += localSize) {
    if (compare(text + stringPos, localPattern, patternLength) == 1) {
      int count = atomic_inc(&groupSuccessCounter);
      resultBuffer[hook(4, beginSearchIdx + count)] = stringPos;
    }
  }

  barrier(0x01);
  if (localIdx == 0)
    resultCountPerWG[hook(5, groupIdx)] = groupSuccessCounter;
}