 allocate outputPixelValue[image width][image height]
   edgex := (window width / 2) rounded down
   edgey := (window height / 2) rounded down
   for x from edgex to image width - edgex
       for y from edgey to image height - edgey
           allocate colorArray[window width][window height]
           for fx from 0 to window width
               for fy from 0 to window height
                   colorArray[fx][fy] := inputPixelValue[x + fx - edgex][y + fy - edgey]
           sort all entries in colorArray[][]
           outputPixelValue[x][y] := colorArray[window width / 2][window height / 2]
