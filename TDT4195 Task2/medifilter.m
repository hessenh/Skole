function h = medifilter(img, M, N)
  % This function creates a median filtered image

    % Create mask
    h = zeros(M,N);

	median_array = zeros(M, N);

imgSize = size(img);
imgXSize = imgSize(2);
imgYSize = imgSize(1);
for x = 1:imgXSize
	for y = 1:imgYSize
	   for m = 1:M
   	   for n = 1:N
      	   posX = x - (n - ceil(N/2));
            posY = y - (m - ceil(M/2));
            if (posX > 0 && posY > 0 && posX <= imgXSize && posY <= imgYSize)
	            median_array(m, n) = img(posY, posX);
	         end
			end
		end
%      disp(median_array(:));
		h(y,x) = median(median_array(:));
	end
end
end
