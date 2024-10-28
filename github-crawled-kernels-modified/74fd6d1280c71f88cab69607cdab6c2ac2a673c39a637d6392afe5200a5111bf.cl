//{"dst":2,"src0":0,"src1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_overflow_ushort4_add(global ushort4* src0, global ushort4* src1, global ushort4* dst) {
  global ushort4* A = &src0[hook(0, get_global_id(0))];
  global ushort4* B = &src1[hook(1, get_global_id(0))];
  global ushort4* C = &dst[hook(2, get_global_id(0))];
  *C = *A + *B;
  ushort4 carry = -convert_ushort4(*C < *B);
  (*C).y += carry.x;
  carry.y += ((*C).y < carry.x);
  (*C).z += carry.y;
  carry.z += ((*C).z < carry.y);
  (*C).w += carry.z;
  carry.w += ((*C).w < carry.z);
}