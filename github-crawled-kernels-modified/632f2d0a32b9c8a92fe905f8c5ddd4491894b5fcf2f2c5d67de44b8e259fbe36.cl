//{"dst":1,"src":0}
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
;
;
;
;
;
;
;
kernel void builtin_convert_float_to_int_sat(global float* src, global int* dst) {
  int i = get_global_id(0);
  dst[hook(1, i)] = convert_int_sat(src[hook(0, i)]);
}