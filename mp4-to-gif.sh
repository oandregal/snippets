#!/bin/sh

# https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
# https://stackoverflow.com/questions/59202490/ffmpeg-converting-mp4-to-gif-with-color-palette-results-in-truncated-video
ffmpeg -i 2001-global-styles-font-settings-14-1218.mp4 -filter_complex "[0:v] fps=5,scale=840:-1 [r];[r] split [a][b];[b] fifo [bb];[a] palettegen [p];[bb][p] paletteuse" 2001-global-styles-font-settings-14-1218.gif

