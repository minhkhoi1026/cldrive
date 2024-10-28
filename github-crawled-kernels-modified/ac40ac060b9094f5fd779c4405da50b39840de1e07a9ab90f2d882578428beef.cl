//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int glob = 0;
__attribute__((visibility("hidden"))) int glob_hidden = 0;
__attribute__((visibility("protected"))) int glob_protected = 0;
__attribute__((visibility("default"))) int glob_default = 0;
extern int ext;
__attribute__((visibility("hidden"))) extern int ext_hidden;
__attribute__((visibility("protected"))) extern int ext_protected;
__attribute__((visibility("default"))) extern int ext_default;
kernel void kern() {
}