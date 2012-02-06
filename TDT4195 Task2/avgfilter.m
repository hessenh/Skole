function H = avgfilter(M, N)
  % This function creates an average filter image

    % Create mask
    h = zeros(M,N);

    avgVal = 1 / (M * N);

    for x = 1:M
      for y = 1:N
	h(x,y) = avgVal;
	end
	end

    H = ifftshift(h);

end

