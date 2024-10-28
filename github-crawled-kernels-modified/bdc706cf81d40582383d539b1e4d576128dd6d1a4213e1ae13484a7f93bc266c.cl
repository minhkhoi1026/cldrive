//{"height":10,"mean_Ib":2,"mean_Ibb":8,"mean_Ig":1,"mean_Igb":7,"mean_Igg":6,"mean_Ir":0,"mean_Irb":5,"mean_Irg":4,"mean_Irr":3,"var_Ibb":16,"var_Igb":15,"var_Igg":14,"var_Irb":13,"var_Irg":12,"var_Irr":11,"width":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void var_math_32F(global const float* mean_Ir, global const float* mean_Ig, global const float* mean_Ib, global const float* mean_Irr, global const float* mean_Irg, global const float* mean_Irb, global const float* mean_Igg, global const float* mean_Igb, global const float* mean_Ibb, const int width, const int height, global float* var_Irr, global float* var_Irg, global float* var_Irb, global float* var_Igg, global float* var_Igb, global float* var_Ibb) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int d = get_global_id(2);

  const int offset = (((d * height) + y) * width) + x;

  var_Irr[hook(11, offset)] = mean_Irr[hook(3, offset)] - (mean_Ir[hook(0, offset)] * mean_Ir[hook(0, offset)]);
  var_Irg[hook(12, offset)] = mean_Irg[hook(4, offset)] - (mean_Ir[hook(0, offset)] * mean_Ig[hook(1, offset)]);
  var_Irb[hook(13, offset)] = mean_Irb[hook(5, offset)] - (mean_Ir[hook(0, offset)] * mean_Ib[hook(2, offset)]);
  var_Igg[hook(14, offset)] = mean_Igg[hook(6, offset)] - (mean_Ig[hook(1, offset)] * mean_Ig[hook(1, offset)]);
  var_Igb[hook(15, offset)] = mean_Igb[hook(7, offset)] - (mean_Ig[hook(1, offset)] * mean_Ib[hook(2, offset)]);
  var_Ibb[hook(16, offset)] = mean_Ibb[hook(8, offset)] - (mean_Ib[hook(2, offset)] * mean_Ib[hook(2, offset)]);
}