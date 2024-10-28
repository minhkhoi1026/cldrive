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
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 1;
  yoff = -1;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 1;
  yoff = 0;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 1;
  yoff = 1;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 0;
  yoff = 1;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -1;
  yoff = 1;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -1;
  yoff = 0;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -1;
  yoff = -1;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 0;
  yoff = -2;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 1;
  yoff = -2;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 2;
  yoff = -2;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 2;
  yoff = -1;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 2;
  yoff = 0;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 2;
  yoff = 1;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 2;
  yoff = 2;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 1;
  yoff = 2;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = 0;
  yoff = 2;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -1;
  yoff = 2;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -2;
  yoff = 2;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -2;
  yoff = 1;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -2;
  yoff = 0;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -2;
  yoff = -1;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -2;
  yoff = -2;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  xoff = -1;
  yoff = -2;
  my_offset_id = (my_id + xoff) % ySize + (j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] != 0) {
    sum += a[hook(1, my_offset_id)];
  }

  int finalSum = a[hook(1, my_id)];
  if (sum >= 7 || sum <= -7) {
    if (a[hook(1, my_id)] == -1 && ((sum >= -13 && sum <= -12) || (sum >= 7 && sum <= 8) || sum >= 16)) {
      finalSum = a[hook(1, my_id)] * -1;
    }
    if (a[hook(1, my_id)] == 1 && (sum <= -16 || (sum >= -8 && sum <= -7) || (sum >= 12 && sum <= 13))) {
      finalSum = a[hook(1, my_id)] * -1;
    }
    if (a[hook(1, my_id)] == 0 && sum < 0) {
      finalSum = -1;
    }
    if (a[hook(1, my_id)] == 0 && sum > 0) {
      finalSum = 1;
    }
  } else {
    finalSum = 0;
  }
  c[hook(2, my_id)] = finalSum;
}