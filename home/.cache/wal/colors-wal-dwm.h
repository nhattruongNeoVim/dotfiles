static const char norm_fg[] = "#e9c8cb";
static const char norm_bg[] = "#020A12";
static const char norm_border[] = "#a38c8e";

static const char sel_fg[] = "#e9c8cb";
static const char sel_bg[] = "#C15253";
static const char sel_border[] = "#e9c8cb";

static const char urg_fg[] = "#e9c8cb";
static const char urg_bg[] = "#9D2A35";
static const char urg_border[] = "#9D2A35";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
