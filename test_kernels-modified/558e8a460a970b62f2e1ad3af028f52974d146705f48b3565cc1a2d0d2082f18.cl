//{"newMatrix":1,"originalMatrix":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy(global const float* originalMatrix, global float* newMatrix) {
  int id = get_global_id(0);
  newMatrix[hook(1, id)] = originalMatrix[hook(0, id)];
}