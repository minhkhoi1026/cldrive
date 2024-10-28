//{"c":0,"f":6,"i":4,"result":7,"s":2,"uc":1,"ui":5,"us":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_function_argument2(char8 c, uchar8 uc, short8 s, ushort8 us, int8 i, uint8 ui, float8 f, global float8* result) {
  result[hook(7, 0)] = convert_float8(c);
  result[hook(7, 1)] = convert_float8(uc);
  result[hook(7, 2)] = convert_float8(s);
  result[hook(7, 3)] = convert_float8(us);
  result[hook(7, 4)] = convert_float8(i);
  result[hook(7, 5)] = convert_float8(ui);
  result[hook(7, 6)] = f;
}