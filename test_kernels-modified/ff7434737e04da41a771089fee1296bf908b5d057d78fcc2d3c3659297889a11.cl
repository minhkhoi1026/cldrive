//{"eggs":1,"spam":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swap(global float* spam, global float* eggs) {
  unsigned int i = get_global_id(0);
  float swap = spam[hook(0, i)];
  spam[hook(0, i)] = eggs[hook(1, i)];
  eggs[hook(1, i)] = swap;
}