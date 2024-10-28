//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct s9 {
  char c;
  int i;
  float f;
} __attribute__((aligned(16)));
struct s10 {
  char c;
  int i;
  float f;
} __attribute__((aligned));
struct s11 {
  char c;
  int i;
  float f;
} __attribute__((packed));
struct s12 {
  char c;
  int i;
  float f;
} __attribute__((endian(host)));
struct s13 {
  char c;
  int i;
  float f;
} __attribute__((endian(device)));
struct s14 {
  char c;
  int i;
  float f;
} __attribute__((endian));

kernel void compiler_structure_attributes() {
}