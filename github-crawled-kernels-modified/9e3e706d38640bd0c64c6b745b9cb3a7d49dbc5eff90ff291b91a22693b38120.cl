//{"Height":2,"ImIn":0,"ImOut":1,"LocalData":6,"LocalData[LocalPosX]":7,"LocalData[LocalPosY]":5,"Mask":4,"Width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Index(int Y, int X, int H, int W) {
  return (Y * W) + X;
}

int IndexTranspose(int Y, int X, int H, int W) {
  return (X * H) + Y;
}

bool IsInside(int Y, int X, int H, int W) {
  if ((Y >= 0) && (Y < H)) {
    if ((X >= 0) && (X < W)) {
      return true;
    } else {
      return false;
    }
  }
  return false;
}

bool IsInsideTranspose(int Y, int X, int H, int W) {
  if ((Y >= 0) && (Y < H)) {
    if ((X >= 0) && (X < W)) {
      return true;
    } else {
      return false;
    }
  }
  return false;
}

bool IsInsideMask(int Y, int X, int H, int W, global const uchar* Mask) {
  if (IsInside(Y, X, H, W)) {
    if (Mask[hook(4, Index(Y, X, H, W))] != 0) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

kernel void TempTranspose2(global int2* ImIn, global int2* ImOut, int Height, int Width) {
  local int2 LocalData[16][16];

  const int GlobalPosY = get_global_id(1);
  const int GlobalPosX = get_global_id(0);

  const int LocalPosY = get_local_id(1);
  const int LocalPosX = get_local_id(0);

  const int LocalSizeX = get_local_size(0);
  const int LocalSizeY = get_local_size(1);

  const int GroupPosX = get_group_id(0);
  const int GroupPosY = get_group_id(1);

  const int TransposedPosX = GroupPosY * LocalSizeY + LocalPosX;
  const int TransposedPosY = GroupPosX * LocalSizeX + LocalPosY;

  if (IsInside(GlobalPosY, GlobalPosX, Height, Width)) {
    LocalData[hook(6, LocalPosY)][hook(5, LocalPosX)] = ImIn[hook(0, Index(GlobalPosY, GlobalPosX, Height, Width))];
  }

  barrier(0x01);

  if (IsInside(TransposedPosY, TransposedPosX, Width, Height)) {
    ImOut[hook(1, Index(TransposedPosY, TransposedPosX, Width, Height))] = LocalData[hook(6, LocalPosX)][hook(7, LocalPosY)];
  }
}