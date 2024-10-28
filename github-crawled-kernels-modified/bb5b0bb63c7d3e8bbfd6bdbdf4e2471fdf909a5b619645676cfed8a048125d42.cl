//{"memsize":1,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel0_global_write(global char* ptr, unsigned long memsize) {
  global unsigned int* p = (global unsigned int*)ptr;
  global unsigned int* end_p = (global unsigned int*)(ptr + memsize);

  unsigned int pattern = 1;
  unsigned int mask = 4;

  *p = pattern;
  pattern = (pattern << 1);

  while (p < end_p) {
    global unsigned int* myp = (global unsigned int*)(((unsigned int)ptr) | mask);

    if (myp == ptr) {
      mask = (mask << 1);
      if (mask == 0) {
        break;
      }
      continue;
    }

    if (myp >= end_p) {
      break;
    }

    *myp = pattern;
    pattern = pattern << 1;
    mask = (mask << 1);
    if (mask == 0) {
      break;
    }
  }

  return;
}