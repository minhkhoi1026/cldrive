//{"N":2,"inArray":0,"offset":3,"outArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Scan_Naive(const global unsigned int* inArray, global unsigned int* outArray, unsigned int N, unsigned int offset) {
  int id = get_global_id(0);

  unsigned int sum;

  if (id < N) {
    sum = inArray[hook(0, id)];
  }

  if (id >= offset) {
    sum += inArray[hook(0, id - offset)];
  }

  outArray[hook(1, id)] = sum;
}