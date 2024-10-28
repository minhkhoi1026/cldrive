//{"buffer":0,"dummyBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void aligned_nonsequential(global float* buffer, global float* dummyBuffer) {
  int idx = get_local_id(0);

  if (idx == 3)
    idx = 4;
  else if (idx == 4)
    idx = 3;
  else if (idx == 25)
    idx = 26;
  else if (idx == 26)
    idx = 25;

  *dummyBuffer = buffer[hook(0, idx)];
}