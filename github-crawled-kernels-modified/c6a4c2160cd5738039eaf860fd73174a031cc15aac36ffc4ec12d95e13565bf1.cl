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

  int NMax = 8;
  int modSize = ySize / NMax;

  int modx = i / modSize;
  int mody = j / modSize;

  int upper = modx % NMax;
  int birth = mody % NMax;
  int lower = 1;

  xoff = 0;
  yoff = -1;
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

  xoff = 0;
  yoff = 1;
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
  yoff = 0;
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

  int c_out = a[hook(1, my_id)];
  if (count <= lower) {
    c_out = 0;
  }
  if (count >= birth && count <= birth + 1) {
    c_out = a[hook(1, my_id)] + 1;
  }
  if (count >= upper) {
    c_out = 0;
  }

  c[hook(2, my_id)] = c_out;
}