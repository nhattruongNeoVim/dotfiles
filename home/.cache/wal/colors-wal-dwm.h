static const char norm_fg[] = "#f4def6";
static const char norm_bg[] = "#030207";
static const char norm_border[] = "#aa9bac";

static const char sel_fg[] = "#f4def6";
static const char sel_bg[] = "#4776B7";
static const char sel_border[] = "#f4def6";

static const char urg_fg[] = "#f4def6";
static const char urg_bg[] = "#6253B8";
static const char urg_border[] = "#6253B8";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
