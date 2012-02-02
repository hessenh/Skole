function H = hpfilter2(M, N, std )
    % This function makes a gaussian high pass filter image
    H = 1 - lpfilter2(M, N, std);

end

