function [ h ] = gaussian(mean, std)

    h = zeros(101, 1);
    c = 1;
    for x = 0:0.01:1 
        h(c) = exp((-(x-mean)^2)/(2*std^2)) / (sqrt(2*pi)*std);
        c = c + 1;
    end
end

