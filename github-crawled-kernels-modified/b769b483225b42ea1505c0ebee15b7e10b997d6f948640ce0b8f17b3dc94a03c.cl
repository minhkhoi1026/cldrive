//{"decimals":1,"index":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void piDecimalCalc(global const int* index, global float* decimals) {
  const int id = get_global_id(0);
}