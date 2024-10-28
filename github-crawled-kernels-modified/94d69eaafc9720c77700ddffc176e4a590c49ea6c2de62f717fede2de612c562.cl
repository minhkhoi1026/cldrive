//{"DecStrng":0,"EncStrng":1,"Key":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Decrypt(global char* DecStrng, global char* EncStrng, int Key) {
  unsigned int xid = get_global_id(0);
  EncStrng[hook(1, xid)] = DecStrng[hook(0, xid)] ^ Key;
}