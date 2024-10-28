//{"data_size":2,"inputData":0,"outputData":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square(global float* inputData, global float* outputData, const int data_size) {
  int id = get_global_id(0);
  outputData[hook(1, id)] = inputData[hook(0, id)] * inputData[hook(0, id)];
}