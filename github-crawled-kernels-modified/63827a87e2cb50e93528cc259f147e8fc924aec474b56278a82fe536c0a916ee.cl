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
;
;
kernel void builtin_convert_long_to_uint_sat(global long* src, global unsigned int* dst) {
  int i = get_global_id(0);
  dst[hook(1, i)] = convert_uint_sat(src[hook(0, i)]);
}