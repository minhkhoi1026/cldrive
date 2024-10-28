//{"newMatrix":1,"newMatrixN":3,"offsetErrorM":4,"offsetErrorN":5,"offsetM":6,"offsetN":7,"originalMatrix":0,"originalMatrixN":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy2D(global const float* originalMatrix, global float* newMatrix, const int originalMatrixN, const int newMatrixN, const int offsetErrorM, const int offsetErrorN, const int offsetM, const int offsetN) {
  int mIdO = get_global_id(0) + offsetM;
  int nIdO = get_global_id(1) + offsetN;
  int mIdN = mIdO + offsetErrorM;
  int nIdN = nIdO + offsetErrorN;
  newMatrix[hook(1, mIdN * newMatrixN + nIdN)] = originalMatrix[hook(0, mIdO * originalMatrixN + nIdO)];
}