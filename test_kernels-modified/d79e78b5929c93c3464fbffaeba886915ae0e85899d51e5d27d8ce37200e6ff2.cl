//{"dst":2,"src0":0,"src1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_overflow_uchar4_add(global uchar4* src0, global uchar4* src1, global uchar4* dst) {
  global uchar4* A = &src0[hook(0, get_global_id(0))];
  global uchar4* B = &src1[hook(1, get_global_id(0))];
  global uchar4* C = &dst[hook(2, get_global_id(0))];
  *C = *A + *B;
  uchar4 carry = -convert_uchar4(*C < *B);
  (*C).y += carry.x;
  carry.y += ((*C).y < carry.x);
  (*C).z += carry.y;
  carry.z += ((*C).z < carry.y);
  (*C).w += carry.z;
  carry.w += ((*C).w < carry.z);
}