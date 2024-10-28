//{"diagonal":3,"eigenIntervals":1,"newEigenIntervals":0,"numEigenIntervals":2,"offDiagonal":4,"tolerance":6,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float calNumEigenValuesLessThan(global float* diagonal, global float* offDiagonal, const unsigned int width, const float x) {
  unsigned int count = 0;

  float prev_diff = (diagonal[hook(3, 0)] - x);
  count += (prev_diff < 0) ? 1 : 0;
  for (unsigned int i = 1; i < width; i += 1) {
    float diff = (diagonal[hook(3, i)] - x) - ((offDiagonal[hook(4, i - 1)] * offDiagonal[hook(4, i - 1)]) / prev_diff);

    count += (diff < 0) ? 1 : 0;
    prev_diff = diff;
  }
  return count;
}

kernel void recalculateEigenIntervals(global float* newEigenIntervals, global float* eigenIntervals, global unsigned int* numEigenIntervals, global float* diagonal, global float* offDiagonal, const unsigned int width, const float tolerance) {
  unsigned int threadId = get_global_id(0);
  unsigned int currentIndex = threadId;

  unsigned int lowerId = 2 * threadId;
  unsigned int upperId = lowerId + 1;

  unsigned int index = 0;
  while (currentIndex >= numEigenIntervals[hook(2, index)]) {
    currentIndex -= numEigenIntervals[hook(2, index)];
    ++index;
  }

  unsigned int lId = 2 * index;
  unsigned int uId = lId + 1;

  if (numEigenIntervals[hook(2, index)] == 1) {
    float midValue = (eigenIntervals[hook(1, uId)] + eigenIntervals[hook(1, lId)]) / 2;
    float n = calNumEigenValuesLessThan(diagonal, offDiagonal, width, midValue) - calNumEigenValuesLessThan(diagonal, offDiagonal, width, eigenIntervals[hook(1, lId)]);

    if (eigenIntervals[hook(1, uId)] - eigenIntervals[hook(1, lId)] < tolerance) {
      newEigenIntervals[hook(0, lowerId)] = eigenIntervals[hook(1, lId)];
      newEigenIntervals[hook(0, upperId)] = eigenIntervals[hook(1, uId)];
    } else if (n == 0) {
      newEigenIntervals[hook(0, lowerId)] = midValue;
      newEigenIntervals[hook(0, upperId)] = eigenIntervals[hook(1, uId)];
    } else {
      newEigenIntervals[hook(0, lowerId)] = eigenIntervals[hook(1, lId)];
      newEigenIntervals[hook(0, upperId)] = midValue;
    }
  }

  else {
    float divisionWidth = (eigenIntervals[hook(1, uId)] - eigenIntervals[hook(1, lId)]) / numEigenIntervals[hook(2, index)];
    newEigenIntervals[hook(0, lowerId)] = eigenIntervals[hook(1, lId)] + divisionWidth * currentIndex;
    newEigenIntervals[hook(0, upperId)] = newEigenIntervals[hook(0, lowerId)] + divisionWidth;
  }
}