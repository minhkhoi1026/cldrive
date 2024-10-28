//{"Neighbours":6,"equivTable":5,"info":4,"labelImg":0,"label_step":2,"table_step":3,"tmpBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct SBlobInfo {
  int ConnectType;
  int NbBlobs;
  int LastUsefulIteration;
};

unsigned int GetLabel(int gx, int gy) {
  return gy << 16 | gx;
}

int2 GetPosFromLabel(unsigned int Label) {
  int2 pos;
  pos.x = Label & 0xFFFF;
  pos.y = (Label >> 16) & 0xFFFF;
  return pos;
}

unsigned int FindMasterLabel(global unsigned int* equivTable, unsigned int table_step, unsigned int Label) {
  int2 Pos = GetPosFromLabel(Label);

  unsigned int Parent = equivTable[hook(5, Pos.y * table_step + Pos.x)];

  while (Label != Parent) {
    Label = Parent;
    Pos = GetPosFromLabel(Label);
    Parent = equivTable[hook(5, Pos.y * table_step + Pos.x)];
  }

  return Label;
}

unsigned int GetNeighboursMin(global const unsigned int* labelImg, int gx, int gy, int img_width, int img_height, unsigned int ConnectType, unsigned int label_step, unsigned int Label) {
  int NbNeighbours = 0;
  unsigned int Neighbours[8];

  if (gx > 0)
    Neighbours[hook(6, NbNeighbours++)] = gy * label_step + gx - 1;

  if (gx < img_width - 1)
    Neighbours[hook(6, NbNeighbours++)] = gy * label_step + gx + 1;

  if (gy > 0) {
    Neighbours[hook(6, NbNeighbours++)] = (gy - 1) * label_step + gx;

    if (ConnectType == 8) {
      if (gx > 0)
        Neighbours[hook(6, NbNeighbours++)] = (gy - 1) * label_step + gx - 1;

      if (gx < img_width - 1)
        Neighbours[hook(6, NbNeighbours++)] = (gy - 1) * label_step + gx + 1;
    }
  }

  if (gy < img_height - 1) {
    Neighbours[hook(6, NbNeighbours++)] = (gy + 1) * label_step + gx;

    if (ConnectType == 8) {
      if (gx > 0)
        Neighbours[hook(6, NbNeighbours++)] = (gy + 1) * label_step + gx - 1;

      if (gx < img_width - 1)
        Neighbours[hook(6, NbNeighbours++)] = (gy + 1) * label_step + gx + 1;
    }
  }

  unsigned int NeighboursMin = Label;

  for (int i = 0; i < NbNeighbours; i++)
    NeighboursMin = min(NeighboursMin, labelImg[hook(0, Neighbours[ihook(6, i))]);

  return NeighboursMin;
}

kernel void reorder_labels1(global unsigned int* labelImg, global unsigned int* tmpBuffer, unsigned int label_step, unsigned int table_step, global struct SBlobInfo* info) {
  const int gx = get_global_id(0);
  const int gy = get_global_id(1);

  label_step /= sizeof(unsigned int);
  table_step /= sizeof(unsigned int);

  const unsigned int label_index = gy * label_step + gx;
  const unsigned int table_index = gy * table_step + gx;

  unsigned int Label = labelImg[hook(0, label_index)];

  if (Label != 0xffffffff) {
    if (Label == GetLabel(gx, gy)) {
      unsigned int NewLabel = atomic_inc(&info->NbBlobs);
      tmpBuffer[hook(1, table_index)] = NewLabel;
    }
  }
}