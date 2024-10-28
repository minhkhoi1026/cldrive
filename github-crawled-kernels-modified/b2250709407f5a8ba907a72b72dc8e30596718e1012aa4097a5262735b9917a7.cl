//{"cols":1,"rows":0,"subMat":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void applyRulesOCL(const int rows, const int cols, global int* subMat) {
  int elements = rows * cols;
  int wrkID = get_group_id(0);
  int locID = get_local_id(0);
  int wrkSize = get_local_size(0);
  int subIndex = wrkSize * wrkID + locID;

  if (subIndex < elements) {
    subMat[hook(2, subIndex)] += 1;
  }
}