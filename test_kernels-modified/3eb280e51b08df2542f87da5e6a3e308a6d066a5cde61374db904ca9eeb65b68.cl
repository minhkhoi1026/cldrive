//{"N":3,"ndvi":0,"ndvi_clean":2,"ndviqa":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clean_mod13a2_qa(global const float* ndvi, global const float* ndviqa, global float* ndvi_clean, global const int* N) {
  int i = get_global_id(0);
  if (i < N) {
    if (ndviqa[hook(1, i)] > 1) {
      ndvi_clean[hook(2, i)] = -28768;
    } else {
      ndvi_clean[hook(2, i)] = ndvi[hook(0, i)];
    }
  }
}