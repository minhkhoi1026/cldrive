//{"end":2,"numbers":0,"primes":4,"results":3,"start":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void return_largest_prime(global const int* numbers, global const int* start, global const int* end, global int* results) {
  int index = get_global_id(0);

  int partsSize = end[hook(2, index)] - start[hook(1, index)];

  int primes[1024];
  int primesSize = 0;

  for (int i = start[hook(1, index)]; i < end[hook(2, index)]; ++i) {
    int currentNum = numbers[hook(0, i)];
    int isFinished = 0;

    if (currentNum <= 1) {
      isFinished = 1;
      continue;
    }
    if (currentNum % 2 == 0 && currentNum > 2) {
      isFinished = 1;
      continue;
    }
    for (int j = 3; j < currentNum / 2; j += 2) {
      if (currentNum % j == 0) {
        isFinished = 1;
        break;
      }
    }
    if (isFinished == 0) {
      primes[hook(4, primesSize++)] = numbers[hook(0, i)];
    }
  }

  int max = primes[hook(4, 0)];

  for (int k = 1; k < primesSize; k++) {
    if (primes[hook(4, k)] > max) {
      max = primes[hook(4, k)];
    }
  }

  results[hook(3, index)] = max;
}