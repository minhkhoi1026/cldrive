//{"boundaries":2,"oldPosition":1,"position":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void apply_periodic_boundary(global double2* position, global double2* oldPosition, const double4 boundaries) {
  size_t index = get_global_id(0);
  double holder;
  double intervals = boundaries.y - boundaries.x;

  double2 privatePos = position[hook(0, index)];
  double2 privateOldPos = oldPosition[hook(1, index)];
  holder = (privatePos.x > boundaries.y || privatePos.x < boundaries.x) ? copysign(intervals, privatePos.x - intervals) : 0;
  privatePos.x -= holder;
  privateOldPos.x -= holder;

  holder = (privatePos.y > boundaries.w || privatePos.y < 0) ? copysign(boundaries.w, privatePos.y) : 0;
  privatePos.y -= holder;
  privateOldPos.y -= holder;
  position[hook(0, index)] = privatePos;
  oldPosition[hook(1, index)] = privateOldPos;
}