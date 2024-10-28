//{"Mydate":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct date {
  int dd, mm, yyyy;
};

kernel void kernel_with_struct(struct date Mydate, global int* output) {
  output[hook(1, 0)] = Mydate.dd;
  output[hook(1, 1)] = Mydate.mm;
  output[hook(1, 2)] = Mydate.yyyy;
}