//{"N":3,"lst":0,"lst_clean":2,"lstqa":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clean_mod11a1_qa(global const int* lst, global const int* lstqa, global int* lst_clean, global const int* N) {
  int i = get_global_id(0);
  if (i < N)
    lst_clean[hook(2, i)] = lst[hook(0, i)];
  if ((lstqa[hook(1, i)] & 0x03) > 1)
    lst_clean[hook(2, i)] = -28768;
}