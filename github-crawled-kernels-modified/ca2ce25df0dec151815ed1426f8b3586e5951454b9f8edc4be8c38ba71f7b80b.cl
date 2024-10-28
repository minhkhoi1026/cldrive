//{"huge":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void use_huge_lds() {
  volatile local int huge[120000];
  huge[hook(0, 0)] = 2;
}