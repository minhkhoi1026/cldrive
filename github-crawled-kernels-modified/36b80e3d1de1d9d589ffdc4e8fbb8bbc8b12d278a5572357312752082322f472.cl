//{"hahs_vlaue":1,"val":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void naive_hash(const int val, local int* hahs_vlaue) {
  *hahs_vlaue = (val * 8191) % (1 << 12);
}