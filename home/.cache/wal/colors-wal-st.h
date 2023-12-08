const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#020A12", /* black   */
  [1] = "#9D2A35", /* red     */
  [2] = "#C15253", /* green   */
  [3] = "#E39373", /* yellow  */
  [4] = "#36738C", /* blue    */
  [5] = "#B0788F", /* magenta */
  [6] = "#2EA7B3", /* cyan    */
  [7] = "#e9c8cb", /* white   */

  /* 8 bright colors */
  [8]  = "#a38c8e",  /* black   */
  [9]  = "#9D2A35",  /* red     */
  [10] = "#C15253", /* green   */
  [11] = "#E39373", /* yellow  */
  [12] = "#36738C", /* blue    */
  [13] = "#B0788F", /* magenta */
  [14] = "#2EA7B3", /* cyan    */
  [15] = "#e9c8cb", /* white   */

  /* special colors */
  [256] = "#020A12", /* background */
  [257] = "#e9c8cb", /* foreground */
  [258] = "#e9c8cb",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
