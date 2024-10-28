//{"size":3,"vecA":1,"vecB":2,"vecC":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addVec(global int* vecC, const global int* vecA, const global int* vecB, const unsigned int size) {
  unsigned int w = get_global_id(0);
  if (w >= size)
    return;
  vecC[hook(0, w)] = vecA[hook(1, w)] + vecB[hook(2, w)];
}