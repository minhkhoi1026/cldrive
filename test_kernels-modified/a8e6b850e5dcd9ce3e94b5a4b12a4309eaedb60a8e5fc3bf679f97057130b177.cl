//{"array":0,"m":1,"t":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct main_struct {
  int value;
};

typedef struct main_struct typedef_struct;

kernel void kernel_with_structure_parameters(global int* array,

                                             struct main_struct m,

                                             typedef_struct t) {
  const int i = get_global_id(0);
  array[hook(0, i)] = m.value + t.value;
}