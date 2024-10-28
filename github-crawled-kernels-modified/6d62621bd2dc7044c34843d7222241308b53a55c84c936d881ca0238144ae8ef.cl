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

  xoff = -20;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -20;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -20;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -20;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -20;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -19;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -19;
  yoff = -4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -19;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -19;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -19;
  yoff = 4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -19;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -18;
  yoff = -8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -18;
  yoff = -7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -18;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -18;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -18;
  yoff = 7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -18;
  yoff = 8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -17;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -17;
  yoff = -9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -17;
  yoff = 9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -17;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -16;
  yoff = -12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -16;
  yoff = -11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -16;
  yoff = 11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -16;
  yoff = 12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -15;
  yoff = -13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -15;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -15;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -15;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -15;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -15;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -15;
  yoff = 13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -14;
  yoff = -14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -14;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -14;
  yoff = -4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -14;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -14;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -14;
  yoff = 4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -14;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -14;
  yoff = 14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -13;
  yoff = -15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -13;
  yoff = -7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -13;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -13;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -13;
  yoff = 7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -13;
  yoff = 15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -12;
  yoff = -16;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -12;
  yoff = -9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -12;
  yoff = -8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -12;
  yoff = 8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -12;
  yoff = 9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -12;
  yoff = 16;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -11;
  yoff = -16;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -11;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -11;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -11;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -11;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -11;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -11;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -11;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -11;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -11;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -11;
  yoff = 16;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = -17;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = -11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = -4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = 4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = 11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -10;
  yoff = 17;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -9;
  yoff = -17;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -9;
  yoff = -12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -9;
  yoff = -7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -9;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -9;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -9;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -9;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -9;
  yoff = 7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -9;
  yoff = 12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -9;
  yoff = 17;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -8;
  yoff = -18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -8;
  yoff = -12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -8;
  yoff = -8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -8;
  yoff = -7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -8;
  yoff = 7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -8;
  yoff = 8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -8;
  yoff = 12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -8;
  yoff = 18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -7;
  yoff = -18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -7;
  yoff = -13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -7;
  yoff = -9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -7;
  yoff = -8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -7;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -7;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -7;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -7;
  yoff = 8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -7;
  yoff = 9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -7;
  yoff = 13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -7;
  yoff = 18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = -18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = -13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = -9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = 9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = 13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -6;
  yoff = 18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = -19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = -14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = -9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = -4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = 4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = 9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = 14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -5;
  yoff = 19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -4;
  yoff = -19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -4;
  yoff = -14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -4;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -4;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -4;
  yoff = -4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -4;
  yoff = 4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -4;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -4;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -4;
  yoff = 14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -4;
  yoff = 19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = -19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = -14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = -11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = 11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = 14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -3;
  yoff = 19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = -20;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = -15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = -11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = 11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = 15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -2;
  yoff = 20;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = -20;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = -15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = -11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = -7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = 7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = 11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = 15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = -1;
  yoff = 20;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = -20;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = -15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = -11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = -7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = 7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = 11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = 15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 0;
  yoff = 20;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = -20;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = -15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = -11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = -7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = 7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = 11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = 15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 1;
  yoff = 20;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = -20;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = -15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = -11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = 11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = 15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 2;
  yoff = 20;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = -19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = -14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = -11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = 11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = 14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 3;
  yoff = 19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 4;
  yoff = -19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 4;
  yoff = -14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 4;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 4;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 4;
  yoff = -4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 4;
  yoff = 4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 4;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 4;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 4;
  yoff = 14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 4;
  yoff = 19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = -19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = -14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = -9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = -4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = 4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = 9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = 14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 5;
  yoff = 19;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = -18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = -13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = -9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = 9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = 13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 6;
  yoff = 18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 7;
  yoff = -18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 7;
  yoff = -13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 7;
  yoff = -9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 7;
  yoff = -8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 7;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 7;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 7;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 7;
  yoff = 8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 7;
  yoff = 9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 7;
  yoff = 13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 7;
  yoff = 18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 8;
  yoff = -18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 8;
  yoff = -12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 8;
  yoff = -8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 8;
  yoff = -7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 8;
  yoff = 7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 8;
  yoff = 8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 8;
  yoff = 12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 8;
  yoff = 18;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 9;
  yoff = -17;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 9;
  yoff = -12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 9;
  yoff = -7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 9;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 9;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 9;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 9;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 9;
  yoff = 7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 9;
  yoff = 12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 9;
  yoff = 17;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = -17;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = -11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = -4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = 4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = 11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 10;
  yoff = 17;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 11;
  yoff = -16;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 11;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 11;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 11;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 11;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 11;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 11;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 11;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 11;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 11;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 11;
  yoff = 16;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 12;
  yoff = -16;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 12;
  yoff = -9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 12;
  yoff = -8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 12;
  yoff = 8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 12;
  yoff = 9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 12;
  yoff = 16;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 13;
  yoff = -15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 13;
  yoff = -7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 13;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 13;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 13;
  yoff = 7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 13;
  yoff = 15;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 14;
  yoff = -14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 14;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 14;
  yoff = -4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 14;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 14;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 14;
  yoff = 4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 14;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 14;
  yoff = 14;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 15;
  yoff = -13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 15;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 15;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 15;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 15;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 15;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 15;
  yoff = 13;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 16;
  yoff = -12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 16;
  yoff = -11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 16;
  yoff = 11;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 16;
  yoff = 12;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 17;
  yoff = -10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 17;
  yoff = -9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 17;
  yoff = 9;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 17;
  yoff = 10;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 18;
  yoff = -8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 18;
  yoff = -7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 18;
  yoff = -6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 18;
  yoff = 6;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 18;
  yoff = 7;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 18;
  yoff = 8;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 19;
  yoff = -5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 19;
  yoff = -4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 19;
  yoff = -3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 19;
  yoff = 3;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 19;
  yoff = 4;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 19;
  yoff = 5;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 20;
  yoff = -2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 20;
  yoff = -1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 20;
  yoff = 0;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 20;
  yoff = 1;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }

  xoff = 20;
  yoff = 2;
  my_offset_id = ((my_id + xoff % ySize) % ySize + j * ySize + ySize * yoff) % tSize;
  if (a[hook(1, my_offset_id)] == 1) {
    count += 1;
  }
  int c_out = 0;

  if (count >= 188 && count <= 289) {
    c_out = 1;
  }
  if (count >= 124 && count <= 146) {
    c_out = 1;
  }
  if (count >= 50 && count <= 55) {
    c_out = 1;
  }
  if (count == 19) {
    c_out = 1;
  }

  c[hook(2, my_id)] = c_out;
}