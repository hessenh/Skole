function [mag] = magnitude(vector)
 mag = sqrt(sum(vector .* vector));
end
