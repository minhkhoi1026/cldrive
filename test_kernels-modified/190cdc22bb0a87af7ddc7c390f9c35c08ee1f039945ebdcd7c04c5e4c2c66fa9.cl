//{"filterOrder":1,"outputLen":2,"posBuff":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void incrementPosBuff(global int* posBuff, int filterOrder, int outputLen) {
  posBuff[hook(0, 0)] = (posBuff[hook(0, 0)] + 1) % filterOrder;
  posBuff[hook(0, 1)] = (posBuff[hook(0, 1)] + 1) % outputLen;
}