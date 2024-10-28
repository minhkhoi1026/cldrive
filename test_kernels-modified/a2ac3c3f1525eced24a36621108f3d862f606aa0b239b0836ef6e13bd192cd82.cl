//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void HelloWorld(global char* data) {
  data[hook(0, 0)] = 'H';
  data[hook(0, 1)] = 'e';
  data[hook(0, 2)] = 'l';
  data[hook(0, 3)] = 'l';
  data[hook(0, 4)] = 'o';
  data[hook(0, 5)] = ' ';
  data[hook(0, 6)] = 'W';
  data[hook(0, 7)] = 'o';
  data[hook(0, 8)] = 'r';
  data[hook(0, 9)] = 'l';
  data[hook(0, 10)] = 'd';
  data[hook(0, 11)] = '!';
  data[hook(0, 12)] = '\n';
}