//{"Lengths":1,"_Dict":0,"w":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void StrLenGpuKernel(global char* _Dict, global char* Lengths) {
  int dictSize = 796032;
  int x = get_global_id(0);
  global char* w = _Dict + x;
  int i = 0;
  int j = 0;
  while (w[hook(2, j)] != '\0') {
    i++;
    j += dictSize;
  }
  Lengths[hook(1, x)] = i;
}