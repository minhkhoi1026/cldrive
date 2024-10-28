//{"dst":2,"src0":0,"src1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_overflow_uint4_add(global uint4* src0, global uint4* src1, global uint4* dst) {
  global uint4* A = &src0[hook(0, get_global_id(0))];
  global uint4* B = &src1[hook(1, get_global_id(0))];
  global uint4* C = &dst[hook(2, get_global_id(0))];
  *C = *A + *B;
  uint4 carry = -convert_uint4(*C < *B);
  (*C).y += carry.x;
  carry.y += ((*C).y < carry.x);
  (*C).z += carry.y;
  carry.z += ((*C).z < carry.y);
  (*C).w += carry.z;
  carry.w += ((*C).w < carry.z);
}