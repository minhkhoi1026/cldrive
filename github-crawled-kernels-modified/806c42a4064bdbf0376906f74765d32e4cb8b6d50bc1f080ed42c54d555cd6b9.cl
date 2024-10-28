//{"boundaries":2,"oldPosition":1,"position":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void apply_solid_boundary(global double2* position, global double2* oldPosition, const double4 boundaries) {
  size_t index = get_global_id(0);
  double ds;
  double2 privatePos = position[hook(0, index)];
  double2 privateOldPos = oldPosition[hook(1, index)];

  if (privatePos.x > boundaries.y) {
    ds = privatePos.x - boundaries.y;
    privatePos.x -= (ds + ds);
    ds = boundaries.y - privateOldPos.x;
    privateOldPos.x += (ds + ds);
  } else if (privatePos.x < boundaries.x) {
    ds = boundaries.x - privatePos.x;
    privatePos.x += (ds + ds);
    ds = privateOldPos.x - boundaries.x;
    privateOldPos.x -= (ds + ds);
  }

  if (privatePos.y > boundaries.w) {
    ds = privatePos.y - boundaries.w;
    privatePos.y -= (ds + ds);
    ds = boundaries.w - privateOldPos.y;
    privateOldPos.y += (ds + ds);
  } else if (privatePos.y < 0) {
    ds = -privatePos.y;
    privatePos.y += (ds + ds);
    ds = privateOldPos.y;
    privateOldPos.y -= (ds + ds);
  }

  position[hook(0, index)] = privatePos;
  oldPosition[hook(1, index)] = privateOldPos;
}