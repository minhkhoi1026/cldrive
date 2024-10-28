//{"N":3,"lai":0,"lai_clean":2,"laiqa":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clean_mcd15a3_qa(global const float* lai, global const int* laiqa, global float* lai_clean, global const int* N) {
  int i = get_global_id(0);
  if (i < N) {
    if (laiqa[hook(1, i)] & 0x01) {
      lai_clean[hook(2, i)] = -28768;
    } else {
      lai_clean[hook(2, i)] = lai[hook(0, i)];
    }
  }
}