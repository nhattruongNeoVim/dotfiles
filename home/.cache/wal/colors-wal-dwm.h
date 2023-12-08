static const char norm_fg[] = "#9eaabc";
static const char norm_bg[] = "#090a0c";
static const char norm_border[] = "#6e7683";

static const char sel_fg[] = "#9eaabc";
static const char sel_bg[] = "#3A4E6A";
static const char sel_border[] = "#9eaabc";

static const char urg_fg[] = "#9eaabc";
static const char urg_bg[] = "#384358";
static const char urg_border[] = "#384358";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
