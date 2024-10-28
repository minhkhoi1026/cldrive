//{"bipol_off":3,"bipol_on":2,"cols":6,"elements_per_row":8,"horiz_out":1,"parvo_off":5,"parvo_on":4,"photo_out":0,"rows":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void OPL_OnOffWaysComputing(global float4* photo_out, global float4* horiz_out, global float4* bipol_on, global float4* bipol_off, global float4* parvo_on, global float4* parvo_off, const int cols, const int rows, const int elements_per_row) {
  int gidx = get_global_id(0), gidy = get_global_id(1);
  if (gidx * 4 >= cols || gidy >= rows) {
    return;
  }

  int offset = mad24(gidy, elements_per_row >> 2, gidx);
  photo_out += offset;
  horiz_out += offset;
  bipol_on += offset;
  bipol_off += offset;
  parvo_on += offset;
  parvo_off += offset;

  float4 diff = *photo_out - *horiz_out;
  float4 isPositive = convert_float4(abs(diff > (float4)0.0f));
  float4 res_on = isPositive * diff;
  float4 res_off = (isPositive - (float4)(1.0f)) * diff;

  *bipol_on = res_on;
  *parvo_on = res_on;

  *bipol_off = res_off;
  *parvo_off = res_off;
}