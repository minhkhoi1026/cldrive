//{"(dest + doffset)":8,"(src + soffset)":9,"dest":0,"doffset":1,"dpitch":2,"height":7,"soffset":4,"spitch":5,"src":3,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int ToGlobalRow(int gidRow, int lszRow, int lidRow) {
  return gidRow * lszRow + lidRow;
}

inline int ToGlobalCol(int gidCol, int lszCol, int lidCol) {
  return gidCol * lszCol + lidCol;
}

inline int ToFlatHaloedIdx(int row, int col, int rowPitch) {
  return (row + 1) * (rowPitch + 2) + (col + 1);
}

inline int ToFlatIdx(int row, int col, int pitch) {
  return row * pitch + col;
}

kernel void CopyRect(global float* dest, int doffset, int dpitch, global float* src, int soffset, int spitch, int width, int height) {
  int gid = get_group_id(0);
  int lid = get_local_id(0);
  int gsz = get_global_size(0);
  int lsz = get_local_size(0);
  int grow = gid * lsz + lid;

  if (grow < height) {
    for (int c = 0; c < width; c++) {
      (dest + doffset)[hook(8, ToFlatIdx(grow, c, dpitch))] = (src + soffset)[hook(9, ToFlatIdx(grow, c, spitch))];
    }
  }
}