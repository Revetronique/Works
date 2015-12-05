/*
  Packet Format
  - Serial Communication: RS232C -
  
  1. OverAll
  +----------------+--------+------+
  | Header Command | Length | Data |

  
  - Header Command: Identify received data; what do the data transfered later mean?
  - Length:         the length of the data. If you use mode selecting, provide 0 to the argument.
  - Data:           the contents of the data. If you use mode selecting, provide null to the argument.
  
  2. mode selecting
  - Header Command -> 'D':68 | 'M':77 | 'P':80 | 'A':65
  - Length         -> 0
  - Data           -> null
  
  3. default
  - Header Command -> 'D':68
  - Length         -> 1
  - Data           -> number
  
  4. drawing manually (manual mode)
  - Header Command -> 'M':77
  - Length         -> 3
  - Data           -> <X, Y, flag>; coordinate value of x and y, LED is On or Off
  
  4-1. reset drawing (manual mode)
  - Header Command -> 'r':114
  - Length         -> 0
  - Data           -> null
  
  5. typing character
  - Header Command -> 'P':80
  - Length         -> length of the message(number of characters)
  - Data           -> <char array>; array variable which contains all characters of the message
  
  5-1. character animation
  - Header Command -> 'p':112
  - Length         -> 1
  - Data           -> <animation mode>; 0: Fly out, 1: Cut off
  
  6. picture animation
  - Header Command -> 'A':65
  - Length         -> length of the pics(number of cells)
  - Data           -> 8 bytes picture data by number of pics times
*/

/*
  Picture flash animation
  
  (Picture)
  a0, a1, a2, a3, a4, a5, a6, a7,
  b0, ......................, b7,
  c0, ......................, c7,
  d0, ......................, d7,
  e0, ......................, e7,
  f0, ......................, f7,
  g0, ......................, g7,
  h0, h1, h2, h3, h4, h5, h6, h7
  
  - each bit has 0(off) or 1(on)
  - pattern is draw as a dot picture
  
  (Application Side)
  - 1 long variable
  h7,h6,h5,h4,h3,h2,h1,h0|g7...g0|f7...f0|e7...e0|d7...d0|c7...c0|b7...b0|a7,a6,a5,a4,a3,a2,a1,a0
  
  (Device SIde)
  - 2 integer variables
  int dat0: d7...d0|c7...c0|b7...b0|a7,a6,a5,a4,a3,a2,a1,a0
  int dat1: h7,h6,h5,h4,h3,h2,h1,h0|g7...g0|f7...f0|e7...e0
  
  (How to send)
  send each picture data from LSB to MSB (from a0 to h7
*/