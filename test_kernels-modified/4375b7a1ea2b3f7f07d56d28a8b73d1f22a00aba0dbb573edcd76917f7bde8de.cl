//{"adims":10,"bdims":11,"cdims":12,"conv1":3,"conv1dims":2,"conv2":5,"conv2dims":4,"ddims":13,"ddims2":14,"edims":15,"fc1":7,"fc1dims":6,"fc2":9,"fc2dims":8,"fdims":16,"out":17,"x":1,"xdims":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initialized(constant int* xdims, global float* x, constant int* conv1dims, constant float* conv1, constant int* conv2dims, constant float* conv2, constant int* fc1dims, constant float* fc1, constant int* fc2dims, constant float* fc2, constant int* adims, constant int* bdims, constant int* cdims, constant int* ddims, constant int* ddims2, constant int* edims, constant int* fdims, global unsigned char* out) {
  out[hook(17, 0)] = 0;
}