//{"dst":2,"src0":0,"src1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
;
;
;
;
;
;
;
;
;
;
;
;
kernel void compiler_half_math_fmax(global float4* src0, global float4* src1, global float4* dst) {
  int i = get_global_id(0);
  dst[hook(2, i)] = fmax(src0[hook(0, i)], src1[hook(1, i)]);
}