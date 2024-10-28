//{"d":2,"f":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_wrappers(global char* output, global float* f, global double* d) {
  local int offset;

  offset = 0;

  vload2(offset, f);

  vload4(offset, f);

  vload8(offset, f);

  vload16(offset, f);
  vstore2((float2)(0, 0), offset, f);

  vstore4((float4)(0, 0, 0, 0), offset, f);

  vstore8((float8)(0, 0, 0, 0, 0, 0, 0, 0), offset, f);

  vstore16((float16)(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), offset, f);
  vload2(offset, d);
  vload4(offset, d);
  vload8(offset, d);
  vload16(offset, d);

  vstore2((double2)(0, 0), offset, d);
  vstore4((double4)(0, 0, 0, 0), offset, d);
  vstore8((double8)(0, 0, 0, 0, 0, 0, 0, 0), offset, d);
  vstore16((double16)(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), offset, d);
}