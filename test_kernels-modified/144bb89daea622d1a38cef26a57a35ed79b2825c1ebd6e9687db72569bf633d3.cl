//{"bufElems":2,"rect":1,"rect_buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rectangles_reduction(global float* rect_buf, global float* rect, const unsigned int bufElems) {
  int id = get_global_id(0);
  if (id == 0) {
    for (unsigned int i = 1; i < bufElems; i++) {
      rect_buf[hook(0, 0)] += rect_buf[hook(0, i)];
    }
    (*rect) = rect_buf[hook(0, 0)];
  }

  return;
}