//{"X":18,"constantintp":4,"constantintrestrictp":5,"constint":19,"constvolatileint":20,"globalconstintp":2,"globalconstintrestrictp":3,"globalconstvolatileintp":6,"globalconstvolatileintrestrictp":7,"globalintp":0,"globalintrestrictp":1,"globalvolatileintp":8,"globalvolatileintrestrictp":9,"localconstintp":12,"localconstintrestrictp":13,"localconstvolatileintp":14,"localconstvolatileintrestrictp":15,"localintp":10,"localintrestrictp":11,"localvolatileintp":16,"localvolatileintrestrictp":17,"volatileint":21}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* globalintp, global int* restrict globalintrestrictp, global const int* globalconstintp, global const int* restrict globalconstintrestrictp, constant int* constantintp, constant int* restrict constantintrestrictp, global const volatile int* globalconstvolatileintp, global const volatile int* restrict globalconstvolatileintrestrictp, global volatile int* globalvolatileintp, global volatile int* restrict globalvolatileintrestrictp, local int* localintp, local int* restrict localintrestrictp, local const int* localconstintp, local const int* restrict localconstintrestrictp, local const volatile int* localconstvolatileintp, local const volatile int* restrict localconstvolatileintrestrictp, local volatile int* localvolatileintp, local volatile int* restrict localvolatileintrestrictp, int X, const int constint, const volatile int constvolatileint, volatile int volatileint) {
  *globalintrestrictp = constint + volatileint;
}