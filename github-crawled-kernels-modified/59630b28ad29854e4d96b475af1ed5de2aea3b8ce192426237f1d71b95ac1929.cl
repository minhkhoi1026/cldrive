//{"data":1,"index":2,"storage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef size_t size_t;
kernel void upload(global size_t* storage, global void* data, global int* index) {
  storage[hook(0, *index)] = (size_t)data;
}