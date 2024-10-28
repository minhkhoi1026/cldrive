//{"bucket":4,"elementsPerWorkItem_global":2,"n":1,"output":3,"vector":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
size_t __attribute__((overloadable)) digit(float value, size_t index) {
  size_t mantissa = (size_t)(fabs(((float)((size_t)value)) - value) * 10000);

  return (size_t)((size_t)(mantissa / pow(10.0, (double)index)) % 10);
}

size_t __attribute__((overloadable)) digit(int value, size_t index) {
  return ((int)(value / pow(10.0, (double)index))) % 10;
}

kernel void sort(global volatile float* vector, constant size_t* n, constant size_t* elementsPerWorkItem_global, global volatile float* output) {
 private
  int minElement = 0;
 private
  size_t currentDigit = 0;
 private
  size_t bucketIndex = 0;
 private
  size_t elementsPerWorkItem = *elementsPerWorkItem_global;

 private
  size_t inputThreadIndex = get_global_id(0) * elementsPerWorkItem;

 private
  size_t bucket[10];

  for (size_t digitIndex = 0; digitIndex < 4; digitIndex++) {
    for (size_t i = 0; i < 10; i++)
      bucket[hook(4, i)] = 0;

    for (size_t i = 0; i < elementsPerWorkItem; i++) {
      currentDigit = digit(vector[hook(0, inputThreadIndex + i)], digitIndex);
      bucket[hook(4, currentDigit)]++;
    }

    for (size_t j = 1; j < 10; j++)
      bucket[hook(4, j)] += bucket[hook(4, j - 1)];

    for (int i = elementsPerWorkItem - 1; i >= 0; i--) {
      bucketIndex = digit(vector[hook(0, inputThreadIndex + i)], digitIndex);

      output[hook(3, inputThreadIndex + bucket[bhook(4, bucketIndex) - 1)] = vector[hook(0, inputThreadIndex + i)];
      bucket[hook(4, bucketIndex)]--;
    }

    for (size_t i = 0; i < elementsPerWorkItem; i++)
      vector[hook(0, inputThreadIndex + i)] = output[hook(3, inputThreadIndex + i)];
  }

  for (int digitIndex = 0; digitIndex < 4; digitIndex++) {
    for (size_t i = 0; i < 10; i++)
      bucket[hook(4, i)] = 0;

    for (size_t i = 0; i < elementsPerWorkItem; i++) {
      currentDigit = digit(((int)vector[hook(0, inputThreadIndex + i)]) + minElement, digitIndex);
      bucket[hook(4, currentDigit)]++;
    }

    for (size_t j = 1; j < 10; j++)
      bucket[hook(4, j)] += bucket[hook(4, j - 1)];

    for (int i = elementsPerWorkItem - 1; i >= 0; i--) {
      bucketIndex = digit(((int)vector[hook(0, inputThreadIndex + i)]) + minElement, digitIndex);

      output[hook(3, inputThreadIndex + bucket[bhook(4, bucketIndex) - 1)] = vector[hook(0, inputThreadIndex + i)];
      bucket[hook(4, bucketIndex)]--;
    }

    for (size_t i = 0; i < elementsPerWorkItem; i++)
      vector[hook(0, inputThreadIndex + i)] = output[hook(3, inputThreadIndex + i)];
  }
}