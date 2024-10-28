//{"height":3,"in":0,"one":4,"out":1,"prefetchSpace":7,"three":6,"two":5,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Stencil4_1(global float* in, global float* out, int width, int height, local float* one, local float* two, local float* three, local float* prefetchSpace) {
  int localWidth = get_local_size(0) + 2;
  int globalIDx = get_global_id(0);
  int localIDx = get_local_id(0) + 1;

  int group = get_group_id(0);
  int pos = globalIDx + 1 + width;

  event_t event;
  int helper;
  async_work_group_copy(one, in + group * (localWidth - 2), localWidth, event);
  async_work_group_copy(two, in + width + group * (localWidth - 2), localWidth, event);
  async_work_group_copy(three, in + width * 2 + group * (localWidth - 2), localWidth, event);

  for (int line = 1; line < height - 1; line++) {
    async_work_group_copy(prefetchSpace, in + (width * (line + 2)) + group * (localWidth - 2), localWidth, event);

    pos = globalIDx + 1 + (width * line);

    out[hook(1, pos)] = (two[hook(5, localIDx - 1)] + two[hook(5, localIDx + 1)] + one[hook(4, localIDx)] + three[hook(6, localIDx)]) / 4;

    helper = one;
    one = two;
    two = three;
    three = prefetchSpace;
    prefetchSpace = helper;
  }
}