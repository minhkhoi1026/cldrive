//{"height":4,"hue":2,"input":0,"output":1,"sat":3,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void huehsv_pkd(global double* input, global double* output, const double hue, const double sat, const unsigned int height, const unsigned int width) {
  int id = get_global_id(0);
  id = id * 3;
  output[hook(1, id)] = input[hook(0, id)] + hue;
  output[hook(1, id + 1)] = input[hook(0, id + 1)] + sat;
}