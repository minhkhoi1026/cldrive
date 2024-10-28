//{"a":1,"c":2,"ySize":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void RunAutomata(const int ySize, global int* a, global int* c) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int my_id = i + ySize * j;
  int sum = 0;

  unsigned int my_offset_id = 0;
  unsigned int tSize = ySize * ySize;

  int xoff = 0;
  int yoff = 0;

  xoff = 0;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 1;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 1;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 1;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 0;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -1;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -1;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -1;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }
  int finalSum = a[hook(1, my_id)];
  if (sum != 0 && (sum >= -5 && sum <= 5)) {
    if (a[hook(1, my_id)] == -1 && (sum == -5 || sum == -3 || sum == 2 || sum == 3)) {
      finalSum = a[hook(1, my_id)] * -1;
    }
    if (a[hook(1, my_id)] == 1 && (sum == 5 || sum == 3 || sum == -2 || sum == -3)) {
      finalSum = a[hook(1, my_id)] * -1;
    }
    if (a[hook(1, my_id)] == 0) {
      finalSum = 0;
      if (sum == -3) {
        finalSum = -1;
      }
      if (sum == 3) {
        finalSum = 1;
      }
    }
  } else {
    finalSum = 0;
  }

  c[hook(2, my_id)] = finalSum;
}