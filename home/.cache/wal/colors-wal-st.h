const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#030207", /* black   */
  [1] = "#6253B8", /* red     */
  [2] = "#4776B7", /* green   */
  [3] = "#956EE7", /* yellow  */
  [4] = "#A2A0A4", /* blue    */
  [5] = "#AB8FFC", /* magenta */
  [6] = "#DCAAFE", /* cyan    */
  [7] = "#f4def6", /* white   */

  /* 8 bright colors */
  [8]  = "#aa9bac",  /* black   */
  [9]  = "#6253B8",  /* red     */
  [10] = "#4776B7", /* green   */
  [11] = "#956EE7", /* yellow  */
  [12] = "#A2A0A4", /* blue    */
  [13] = "#AB8FFC", /* magenta */
  [14] = "#DCAAFE", /* cyan    */
  [15] = "#f4def6", /* white   */

  /* special colors */
  [256] = "#030207", /* background */
  [257] = "#f4def6", /* foreground */
  [258] = "#f4def6",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
