//{"result":2,"val1":0,"val2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global const float* val1, global const float* val2, global float* result) {
  if (get_global_id(0) == 0)
    *result = *val1 + *val2;
}