//{"_A":1,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_integer_v2(global int* ptr, int _A) {
  int2 x = (int2)(_A, (_A + 1));
  int2 y = (int2)get_local_id(0);

  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  x = (y * x) + y;
  y = (x * y) + x;
  x = (y * x) + y;
  y = (x * y) + x;
  ;
  ;
  ;

  ptr[hook(0, get_global_id(0))] = (y.S0) + (y.S1);
}