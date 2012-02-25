function H = lpfilter2(M, N, std)
    % This function makes a gaussian low pass filter image

    std = M-std;

    % Create mask
    h = zeros(M,N);
    for x = 1:N
        for y = 1:M
            posX = x - N/2;
            posY = y - M/2;
            h(y,x) = exp(-(posX*posX+posY*posY)^2/(2*std^2));
        end
    end
    
    H = ifftshift(h);

end

