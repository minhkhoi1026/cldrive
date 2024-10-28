//{"numbers":0,"sortedNumbers":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sort(global int* numbers, global int* sortedNumbers) {
  int actPos = get_global_id(0);
  int size = get_global_size(0);

  int newPos = actPos;

  for (int i = 0; i < size; i++) {
    if (i < actPos && numbers[hook(0, i)] > numbers[hook(0, actPos)]) {
      newPos--;
    } else if (i > actPos && numbers[hook(0, i)] < numbers[hook(0, actPos)]) {
      newPos++;
    }
  }

  sortedNumbers[hook(1, newPos)] = numbers[hook(0, actPos)];
}