//{"diagonal":2,"eigenIntervals":1,"numEigenIntervals":0,"offDiagonal":3,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float calNumEigenValuesLessThan(global float* diagonal, global float* offDiagonal, const unsigned int width, const float x) {
  unsigned int count = 0;

  float prev_diff = (diagonal[hook(2, 0)] - x);
  count += (prev_diff < 0) ? 1 : 0;
  for (unsigned int i = 1; i < width; i += 1) {
    float diff = (diagonal[hook(2, i)] - x) - ((offDiagonal[hook(3, i - 1)] * offDiagonal[hook(3, i - 1)]) / prev_diff);

    count += (diff < 0) ? 1 : 0;
    prev_diff = diff;
  }
  return count;
}

kernel void calNumEigenValueInterval(global unsigned int* numEigenIntervals, global float* eigenIntervals, global float* diagonal, global float* offDiagonal, const unsigned int width) {
  unsigned int threadId = get_global_id(0);

  unsigned int lowerId = 2 * threadId;
  unsigned int upperId = lowerId + 1;

  float lowerLimit = eigenIntervals[hook(1, lowerId)];
  float upperLimit = eigenIntervals[hook(1, upperId)];

  unsigned int numEigenValuesLessThanLowerLimit = calNumEigenValuesLessThan(diagonal, offDiagonal, width, lowerLimit);
  unsigned int numEigenValuesLessThanUpperLimit = calNumEigenValuesLessThan(diagonal, offDiagonal, width, upperLimit);

  numEigenIntervals[hook(0, threadId)] = numEigenValuesLessThanUpperLimit - numEigenValuesLessThanLowerLimit;
}