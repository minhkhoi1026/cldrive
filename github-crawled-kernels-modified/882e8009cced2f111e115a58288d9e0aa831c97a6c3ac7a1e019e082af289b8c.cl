//{"data":0,"lp":3,"lvl":4,"player":2,"scr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct screen_params {
  unsigned int res_x;
  unsigned int res_y;
};

struct level_params {
  unsigned int level_x;
  unsigned int level_y;
};

struct player_params {
  float pos_x;
  float pos_y;
  float dir_x;
  float dir_y;
  float plane_x;
  float plane_y;
};

struct wall_params {
  int res_x;
  int res_y;
};

struct pixel {
  uchar r;
  uchar g;
  uchar b;
  uchar unused;
};

constant struct pixel ceiling_color = {96, 96, 96};
constant struct pixel floor_color = {128, 128, 128};

void swap(int* i, int* j) {
  const int tmp = *i;
  *i = *j;
  *j = tmp;
}

void draw_vertical_line(global struct pixel* data, const struct screen_params scr, const int x, int y_start, int y_end, const struct pixel wall_color) {
  if (y_end < y_start) {
    swap(&y_start, &y_end);
  }

  if ((x < 0) || (x >= scr.res_x) || (y_end < 0) || (y_start >= scr.res_y)) {
    return;
  }

  if (y_start < 0) {
    y_start = 0;
  }
  if (y_end >= scr.res_x) {
    y_end = scr.res_y - 1;
  }

  for (int y = 0; y < scr.res_y; y++) {
    const int xy = x + (y * scr.res_x);

    if (y < y_start) {
      data[hook(0, xy)] = ceiling_color;
    } else if (y <= y_end) {
      data[hook(0, xy)] = wall_color;
    } else {
      data[hook(0, xy)] = floor_color;
    }
  }
}

kernel void rc_1(global struct pixel* data, const struct screen_params scr, const struct player_params player, const struct level_params lp, global int* lvl) {
  const int x = (int)get_global_id(0);
  if (x >= scr.res_x) {
    return;
  }

  const float cam_x = 2.f * x / scr.res_x - 1;

  const float ray_dir_x = player.dir_x + player.plane_x * cam_x;
  const float ray_dir_y = player.dir_y + player.plane_y * cam_x;
  const float ray_pos_x = player.pos_x;
  const float ray_pos_y = player.pos_y;

  const int step_x = (ray_dir_x >= 0) ? 1 : -1;
  const int step_y = (ray_dir_y >= 0) ? 1 : -1;

  const float delta_dist_x = sqrt(1 + pow(ray_dir_y, 2) / pow(ray_dir_x, 2));
  const float delta_dist_y = sqrt(1 + pow(ray_dir_x, 2) / pow(ray_dir_y, 2));

  int map_x = ray_pos_x;
  int map_y = ray_pos_y;

  float side_dist_x = (step_x == 1) ? ((map_x + 1.0f - ray_pos_x) * delta_dist_x) : ((ray_pos_x - map_x) * delta_dist_x);
  float side_dist_y = (step_y == 1) ? ((map_y + 1.0f - ray_pos_y) * delta_dist_y) : ((ray_pos_y - map_y) * delta_dist_y);

  bool y_side_hit;

  for (;;) {
    if (side_dist_x < side_dist_y) {
      map_x += step_x;
      side_dist_x += delta_dist_x;
      y_side_hit = false;
    } else {
      map_y += step_y;
      side_dist_y += delta_dist_y;
      y_side_hit = true;
    }

    if (lvl[hook(4, map_y + (map_x * lp.level_y))] != 0) {
      break;
    }
  }

  const float perp_wall_dist = y_side_hit ? fabs((map_y - ray_pos_y + (1 - step_y) / 2) / ray_dir_y) : fabs((map_x - ray_pos_x + (1 - step_x) / 2) / ray_dir_x);

  const int wall_height = abs((int)(scr.res_y / perp_wall_dist));

  int wall_start = (-wall_height / 2) + (scr.res_y / 2);
  int wall_end = wall_height / 2 + scr.res_y / 2;

  if (wall_start < 0) {
    wall_start = 0;
  }

  if (wall_end >= scr.res_y) {
    wall_end = scr.res_y - 1;
  }

  struct pixel float3;
  switch (lvl[hook(4, map_y + (map_x * lp.level_y))]) {
    case 1:
      float3 = (struct pixel){0x00, 0x00, 0xff};
      break;
    case 2:
      float3 = (struct pixel){0x00, 0xff, 0x00};
      break;
    case 3:
      float3 = (struct pixel){0xff, 0x00, 0x00};
      break;
    case 4:
      float3 = (struct pixel){0xff, 0xff, 0xff};
      break;
    case 5:
      float3 = (struct pixel){0x00, 0xff, 0xff};
      break;
    default:
      float3 = (struct pixel){0x30, 0x30, 0x30};
      break;
  }

  if (y_side_hit) {
    float3.r *= .7f;
    float3.g *= .7f;
    float3.b *= .7f;
  }

  draw_vertical_line(data, scr, x, wall_start, wall_end, float3);
}