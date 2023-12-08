const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#090a0c", /* black   */
  [1] = "#384358", /* red     */
  [2] = "#3A4E6A", /* green   */
  [3] = "#4C4F61", /* yellow  */
  [4] = "#3D5E85", /* blue    */
  [5] = "#3F6187", /* magenta */
  [6] = "#4F6689", /* cyan    */
  [7] = "#9eaabc", /* white   */

  /* 8 bright colors */
  [8]  = "#6e7683",  /* black   */
  [9]  = "#384358",  /* red     */
  [10] = "#3A4E6A", /* green   */
  [11] = "#4C4F61", /* yellow  */
  [12] = "#3D5E85", /* blue    */
  [13] = "#3F6187", /* magenta */
  [14] = "#4F6689", /* cyan    */
  [15] = "#9eaabc", /* white   */

  /* special colors */
  [256] = "#090a0c", /* background */
  [257] = "#9eaabc", /* foreground */
  [258] = "#9eaabc",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
