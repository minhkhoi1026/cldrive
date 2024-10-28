//{"count":3,"input":0,"output":1,"temp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void setArgLocal(global float* input, global float* output, local float* temp, const unsigned int count) {
  int gtid = get_global_id(0);
  int ltid = get_local_id(0);
  if (gtid < count) {
    temp[hook(2, ltid)] = input[hook(0, gtid)] + 2;
    output[hook(1, gtid)] = temp[hook(2, ltid)] * temp[hook(2, ltid)];
  }
}