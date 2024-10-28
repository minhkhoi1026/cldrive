//{"out":4,"val_down":1,"val_exact":0,"val_mid":2,"val_up":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_f2i(const float val_exact, const float val_down, const float val_mid, const float val_up, global int* out) {
  size_t offset = 32 * get_global_id(0);
  out[hook(4, offset)] = (int)val_exact;
  out[hook(4, offset + 1)] = (int)val_down;
  out[hook(4, offset + 2)] = (int)val_mid;
  out[hook(4, offset + 3)] = (int)val_up;
  out[hook(4, offset + 4)] = (int)-val_exact;
  out[hook(4, offset + 5)] = (int)-val_down;
  out[hook(4, offset + 6)] = (int)-val_mid;
  out[hook(4, offset + 7)] = (int)-val_up;
  out[hook(4, offset + 8)] = (int)ceil(val_exact);
  out[hook(4, offset + 9)] = (int)ceil(-val_exact);
  out[hook(4, offset + 10)] = (int)ceil(val_mid);
  out[hook(4, offset + 11)] = (int)ceil(-val_mid);
  out[hook(4, offset + 12)] = (int)floor(val_exact);
  out[hook(4, offset + 13)] = (int)floor(-val_exact);
  out[hook(4, offset + 14)] = (int)floor(val_mid);
  out[hook(4, offset + 15)] = (int)floor(-val_mid);
  out[hook(4, offset + 16)] = (int)rint(val_exact);
  out[hook(4, offset + 17)] = (int)rint(-val_exact);
  out[hook(4, offset + 18)] = (int)rint(val_mid);
  out[hook(4, offset + 19)] = (int)rint(-val_mid);
  out[hook(4, offset + 20)] = (int)round(val_exact);
  out[hook(4, offset + 21)] = (int)round(val_down);
  out[hook(4, offset + 22)] = (int)round(val_mid);
  out[hook(4, offset + 23)] = (int)round(val_up);
  out[hook(4, offset + 24)] = (int)round(-val_exact);
  out[hook(4, offset + 25)] = (int)round(-val_down);
  out[hook(4, offset + 26)] = (int)round(-val_mid);
  out[hook(4, offset + 27)] = (int)round(-val_up);
  out[hook(4, offset + 28)] = (int)trunc(val_mid);
  out[hook(4, offset + 29)] = (int)trunc(-val_mid);
}