//{"out":3,"span":1,"src":0,"threshold":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void turnpoints(global float* src, unsigned int span, float threshold, global float* out) {
  unsigned int i = get_global_id(0);
  unsigned int s = i + span;
  out[hook(3, i)] = 0;
  unsigned int count = 0;
  for (unsigned int j = 1; j <= span; j++) {
    if (src[hook(0, s)] > src[hook(0, s + j)] && src[hook(0, s)] > src[hook(0, s - j)])
      count++;
    else
      break;
  }
  if (count == span)
    out[hook(3, i)] = 1;
  else {
    count = 0;
    for (unsigned int j = 1; j <= span; j++) {
      if (src[hook(0, s)] < src[hook(0, s + j)] && src[hook(0, s)] < src[hook(0, s - j)])
        count++;
      else
        break;
    }
    if (count == span)
      out[hook(3, i)] = -1;
  }
}