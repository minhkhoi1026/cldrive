//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void oclLucas(global char* data) {
  data[hook(0, 0)] = 'H';
  data[hook(0, 1)] = 'e';
  data[hook(0, 2)] = 'l';
  data[hook(0, 3)] = 'l';
  data[hook(0, 4)] = 'o';
  data[hook(0, 5)] = '!';
}