//{"dst":0,"e":1,"m":3,"o":4,"r":2,"zero_arr":5,"zero_flt":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int m[3] = {71, 72, 73};
const constant int n = 1;
constant int o[3] = {3, 2, 1};

constant int4 a = {1, 2, 3, 4};
constant int4 b = {0, -1, -2, -3};

struct Person {
  char name[7];
  int3 idNumber;
};

struct Test1 {
  int a0;
  char a1;
};

struct Test2 {
  char a0;
  int a1;
};
struct Test3 {
  int a0;
  int a1;
};
struct Test4 {
  float a0;
  float a1;
};

constant struct Person james = {{"james"}, (int3)(1, 2, 3)};
constant struct Test1 t0 = {1, 2};
constant struct Test2 t1 = {1, 2};

constant int3 c[3] = {(int3)(0, 1, 2), (int3)(3, 4, 5), (int3)(6, 7, 8)};
constant char4 d[3] = {(char4)(0, 1, 2, 3), (char4)(4, 5, 6, 7), (char4)(8, 9, 10, 11)};

constant struct Person members[3] = {{{"abc"}, (int3)(1, 2, 3)}, {{"defg"}, (int3)(4, 5, 6)}, {{"hijk"}, (int3)(7, 8, 9)}};
constant struct Test3 zero_struct = {0, 0};
constant int3 zero_vec = {0, 0, 0};
constant int zero_arr[3] = {0, 0, 0};
constant float zero_flt[3] = {0.0f, 0.0f, 0.0f};

kernel void compiler_global_constant(global int* dst, int e, int r) {
  int id = (int)get_global_id(0);

  int4 x = a + b;
  dst[hook(0, id)] = m[hook(3, id % 3)] * n * o[hook(4, 2)] + e + r * x.y * a.x + zero_struct.a0 + zero_vec.x + zero_arr[hook(5, 1)] + (int)zero_flt[hook(6, 2)];
}