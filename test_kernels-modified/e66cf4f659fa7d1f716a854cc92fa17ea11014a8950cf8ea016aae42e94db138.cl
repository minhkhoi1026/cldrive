//{"uiVectorWidth":3,"vectorIn1":0,"vectorIn2":1,"vectorOut":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ckVectorAdd(global unsigned int* vectorIn1, global unsigned int* vectorIn2, global unsigned int* vectorOut, unsigned int uiVectorWidth) {
  unsigned int x = get_global_id(0);
  if (x >= (uiVectorWidth)) {
    return;
  }

  vectorOut[hook(2, x)] = vectorIn1[hook(0, x)] + vectorIn2[hook(1, x)];
}