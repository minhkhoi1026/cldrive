//{"f":0,"result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct sfloat8 {
  float a;
  float b;
  float c;
  float d;
  float e;
  float f;
  float g;
  float h;
};

kernel void compiler_function_argument3(struct sfloat8 f, global struct sfloat8* result) {
  result[hook(1, 0)].a = f.a;
  result[hook(1, 0)].b = 12.0f;
  result[hook(1, 0)].c = 12.0f;
  result[hook(1, 0)].d = 12.0f;
  result[hook(1, 0)].e = 12.0f;
  result[hook(1, 0)].f = 12.0f;
  result[hook(1, 0)].g = 12.0f;
  result[hook(1, 0)].h = f.a + f.h;

  result[hook(1, 1)].a = f.a;
  result[hook(1, 1)].b = 12.0f;
  result[hook(1, 1)].c = 12.0f;
  result[hook(1, 1)].d = 12.0f;
  result[hook(1, 1)].e = 12.0f;
  result[hook(1, 1)].f = 12.0f;
  result[hook(1, 1)].g = 12.0f;
  result[hook(1, 1)].h = f.a + f.h;

  result[hook(1, 2)].a = f.a;
  result[hook(1, 2)].b = 12.0f;
  result[hook(1, 2)].c = 12.0f;
  result[hook(1, 2)].d = 12.0f;
  result[hook(1, 2)].e = 12.0f;
  result[hook(1, 2)].f = 12.0f;
  result[hook(1, 2)].g = 12.0f;
  result[hook(1, 2)].h = f.a + f.h;

  result[hook(1, 3)].a = f.a;
  result[hook(1, 3)].b = 12.0f;
  result[hook(1, 3)].c = 12.0f;
  result[hook(1, 3)].d = 12.0f;
  result[hook(1, 3)].e = 12.0f;
  result[hook(1, 3)].f = 12.0f;
  result[hook(1, 3)].g = 12.0f;
  result[hook(1, 3)].h = f.a + f.h;

  result[hook(1, 4)].a = f.a;
  result[hook(1, 4)].b = 12.0f;
  result[hook(1, 4)].c = 12.0f;
  result[hook(1, 4)].d = 12.0f;
  result[hook(1, 4)].e = 12.0f;
  result[hook(1, 4)].f = 12.0f;
  result[hook(1, 4)].g = 12.0f;
  result[hook(1, 4)].h = f.a + f.h;

  result[hook(1, 5)].a = f.a;
  result[hook(1, 5)].b = 12.0f;
  result[hook(1, 5)].c = 12.0f;
  result[hook(1, 5)].d = 12.0f;
  result[hook(1, 5)].e = 12.0f;
  result[hook(1, 5)].f = 12.0f;
  result[hook(1, 5)].g = 12.0f;
  result[hook(1, 5)].h = f.a + f.h;

  result[hook(1, 6)] = result[hook(1, 0)];
}