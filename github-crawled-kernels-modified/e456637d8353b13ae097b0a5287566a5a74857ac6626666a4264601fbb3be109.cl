//{"vecA":0,"vecB":1,"vecC":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectoradd(global const float* vecA, global const float* vecB, global float* vecC) {
  int idx = get_global_id(0);

  vecC[hook(2, idx)] = vecA[hook(0, idx)] + vecB[hook(1, idx)];
}