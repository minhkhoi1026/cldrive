//{"bg1":1,"bg2":2,"bgw":5,"cutOff":7,"df1":3,"df2":4,"dfw":6,"fg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ff(global float* fg, global float* bg1, global float* bg2, global float* df1, global float* df2, const float bgw, const float dfw, const float cutOff) {
  int l = get_global_id(0);

  float fgg = fg[hook(0, l)];

  float bg;
  if (bg1 && bg2)
    bg = bg1[hook(1, l)] * bgw + bg2[hook(2, l)] * (1 - bgw);
  else if (bg1)
    bg = bg1[hook(1, l)];
  else if (bg2)
    bg = bg2[hook(2, l)];
  else
    bg = 1.0f;

  float df;
  if (df1 && df2)
    df = df1[hook(3, l)] * dfw + df2[hook(4, l)] * (1 - dfw);
  else if (df1)
    df = df1[hook(3, l)];
  else if (df2)
    df = df2[hook(4, l)];
  else
    df = 0.0f;

  if (df >= bg)
    fg[hook(0, l)] = 1.0f;
  else if (df >= fgg)
    fg[hook(0, l)] = 0.0f;
  else
    fg[hook(0, l)] = (fgg - df) / (bg - df);

  if (cutOff > 0.0f && fg[hook(0, l)] > cutOff)
    fg[hook(0, l)] = cutOff;
}