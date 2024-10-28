//{"colors":2,"input":0,"output":1,"priv_hist":4,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void HIST(global unsigned int* input, global volatile unsigned int* output, unsigned int colors, unsigned int size) {
  unsigned int tid = get_global_id(0);
  unsigned int gsize = get_global_size(0);

  if (tid >= size) {
    return;
  }
  unsigned int priv_hist[256];
  unsigned int i = 0;

  for (i = 0; i < colors; i++) {
    priv_hist[hook(4, i)] = 0;
  }

  unsigned int index = tid;
  while (index < size) {
    unsigned int float3 = input[hook(0, index)];
    priv_hist[hook(4, float3)]++;
    index += gsize;
  }

  mem_fence(0x02);

  for (i = 0; i < colors; i++) {
    if (priv_hist[hook(4, i)] > 0) {
      atom_add(&output[hook(1, i)], priv_hist[hook(4, i)]);
    }
  }
}