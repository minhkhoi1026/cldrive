//{"buf":1,"bufOffset":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float TWOPI = 3.14159265358979323846264338327950288f * 2.0f;
constant float phStepR = (440.0f * 3.14159265358979323846264338327950288f) / 44100.0f;
kernel void cl_synth(int bufOffset, global float* buf) {
  const int gid = get_global_id(0);

  buf[hook(1, gid)] = (gid % 2) * sin((float)(bufOffset + gid - 1) * phStepR);
}