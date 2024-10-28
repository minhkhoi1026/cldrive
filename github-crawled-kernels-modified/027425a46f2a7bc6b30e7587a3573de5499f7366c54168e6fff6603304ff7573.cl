//{"dum":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct main_struct {
  int value;
};

typedef struct main_struct typedef_struct;

int function_with_structure_parameters(struct main_struct m, typedef_struct t);

int function_with_structure_parameters(struct main_struct m, typedef_struct t) {
  return m.value + t.value;
}

kernel void dummy(int dum) {
}