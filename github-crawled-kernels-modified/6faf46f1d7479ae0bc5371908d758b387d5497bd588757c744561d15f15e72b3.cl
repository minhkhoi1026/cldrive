//{"afloat":4,"aint":0,"along":2,"auint":1,"aulong":3,"floatout":9,"intout":5,"longout":7,"uintout":6,"ulongout":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(const int aint, const unsigned auint, long along, unsigned long aulong, const float afloat, global int* intout, global unsigned int* uintout, global long* longout, global unsigned long* ulongout, global float* floatout) {
  const int globalid = get_global_id(0);

  intout[hook(5, globalid)] = aint + globalid;
  uintout[hook(6, globalid)] = auint + globalid;
  longout[hook(7, globalid)] = along + globalid;
  ulongout[hook(8, globalid)] = aulong + globalid;

  floatout[hook(9, globalid)] = afloat + globalid;
}