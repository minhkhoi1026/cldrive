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
  unsigned int count = 0;

  unsigned int my_offset_id = 0;
  unsigned int tSize = ySize * ySize;

  int xoff = 0;
  int yoff = 0;

  int upper = 1;
  int birth = 1;

  xoff = -10;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -7;
  yoff = -7;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -7;
  yoff = -3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -7;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -7;
  yoff = 3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -7;
  yoff = 7;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -5;
  yoff = -5;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -5;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -5;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -5;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -5;
  yoff = 5;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -4;
  yoff = -3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -4;
  yoff = -2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -4;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -4;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -4;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -4;
  yoff = 2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -4;
  yoff = 3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -3;
  yoff = -7;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -3;
  yoff = -4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -3;
  yoff = -3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -3;
  yoff = -2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -3;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -3;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -3;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -3;
  yoff = 2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -3;
  yoff = 3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -3;
  yoff = 4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -3;
  yoff = 7;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -2;
  yoff = -4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -2;
  yoff = -3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -2;
  yoff = -2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -2;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -2;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -2;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -2;
  yoff = 2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -2;
  yoff = 3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -2;
  yoff = 4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -1;
  yoff = -5;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -1;
  yoff = -4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -1;
  yoff = -3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -1;
  yoff = -2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -1;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -1;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -1;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -1;
  yoff = 2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -1;
  yoff = 3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -1;
  yoff = 4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = -1;
  yoff = 5;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = -10;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = -7;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = -5;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = -4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = -3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = -2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = 2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = 3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = 4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = 5;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = 7;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 0;
  yoff = 10;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 1;
  yoff = -5;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 1;
  yoff = -4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 1;
  yoff = -3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 1;
  yoff = -2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 1;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 1;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 1;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 1;
  yoff = 2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 1;
  yoff = 3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 1;
  yoff = 4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 1;
  yoff = 5;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 2;
  yoff = -4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 2;
  yoff = -3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 2;
  yoff = -2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 2;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 2;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 2;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 2;
  yoff = 2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 2;
  yoff = 3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 2;
  yoff = 4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 3;
  yoff = -7;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 3;
  yoff = -4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 3;
  yoff = -3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 3;
  yoff = -2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 3;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 3;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 3;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 3;
  yoff = 2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 3;
  yoff = 3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 3;
  yoff = 4;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 3;
  yoff = 7;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 4;
  yoff = -3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 4;
  yoff = -2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 4;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 4;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 4;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 4;
  yoff = 2;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 4;
  yoff = 3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 5;
  yoff = -5;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 5;
  yoff = -1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 5;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 5;
  yoff = 1;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 5;
  yoff = 5;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 7;
  yoff = -7;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 7;
  yoff = -3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 7;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 7;
  yoff = 3;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 7;
  yoff = 7;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }

  xoff = 10;
  yoff = 0;
  my_offset_id = ((my_id + xoff) & (ySize - 1)) + ((j * ySize + ySize * yoff) & (tSize - 1));
  if (a[hook(1, my_offset_id)] != 0) {
    count += 1;
  }
  int c_out = a[hook(1, my_id)];

  if (count >= 24 && count <= 33) {
    c_out = 0;
  }
  if (count >= 27 && count <= 28) {
    c_out = a[hook(1, my_id)] + 1;
  }
  if (count >= 36 && count <= 42) {
    c_out = a[hook(1, my_id)] + 1;
  }
  if (count >= 52 && count <= 59) {
    c_out = a[hook(1, my_id)] + 1;
  }
  if (count >= 41 && count <= 55) {
    c_out = 0;
  }

  c[hook(2, my_id)] = c_out;
}