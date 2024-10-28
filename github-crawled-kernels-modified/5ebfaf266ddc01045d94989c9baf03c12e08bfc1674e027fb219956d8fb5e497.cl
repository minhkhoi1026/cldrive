//{"a":1,"b":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global char* out, int a, int b) {
  char x;
  if (a == 10 || b == 2)
    x = 2;
  else if (b == 12 && a == 4)
    x = 3;
  else if (b != 3 || a != 5)
    x = 1;
  else
    x = 0;
  *out = x;
}