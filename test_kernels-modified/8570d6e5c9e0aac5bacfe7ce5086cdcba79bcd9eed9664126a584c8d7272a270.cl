//{"check":2,"position":0,"result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void regionDensityKernel(const global double2* position, global unsigned int* result, const double4 check) {
  size_t index = get_global_id(0);
  double2 privPos = position[hook(0, index)];
  result[hook(1, index)] = ((privPos.x >= check.x) && (privPos.x <= check.y) && (privPos.y >= check.z) && (privPos.y <= check.w)) ? 1 : 0;
}