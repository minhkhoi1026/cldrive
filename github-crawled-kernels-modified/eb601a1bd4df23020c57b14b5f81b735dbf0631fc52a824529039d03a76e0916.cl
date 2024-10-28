//{"bufElems":6,"plaq":3,"plaq_buf":0,"splaq":5,"splaq_buf":2,"tplaq":4,"tplaq_buf":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void plaquette_reduction(global float* plaq_buf, global float* tplaq_buf, global float* splaq_buf, global float* plaq, global float* tplaq, global float* splaq, const unsigned int bufElems) {
  int id = get_global_id(0);
  if (id == 0) {
    for (unsigned int i = 1; i < bufElems; i++) {
      plaq_buf[hook(0, 0)] += plaq_buf[hook(0, i)];
      tplaq_buf[hook(1, 0)] += tplaq_buf[hook(1, i)];
      splaq_buf[hook(2, 0)] += splaq_buf[hook(2, i)];
    }
    (*plaq) = plaq_buf[hook(0, 0)];
    (*tplaq) = tplaq_buf[hook(1, 0)];
    (*splaq) = splaq_buf[hook(2, 0)];
  }

  return;
}