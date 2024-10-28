//{"a":1,"c":2,"ySize":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ConwayTorus(const int ySize, global int* a, global int* c) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int my_id = i + ySize * j;
  unsigned int count = 0;
  unsigned int my_offset_id = 0;
  unsigned int tSize = ySize * ySize;

  int xoff = 0;
  int yoff = 0;

  xoff = 0;
  yoff = -1;
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

  xoff = 0;
  yoff = 1;
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
  yoff = 0;
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

  c[hook(2, my_id)] = (count == 3) || (count == 2) && (a[hook(1, my_id)] != 0);
}