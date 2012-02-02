% The Markow assumption, Eq. 15.5 in AIMA
%
% Eq. 15.12 in AIMA is a matrix operations equivalent of Eq. 15.5,
% and is implemented here written in MATLAB

function f_next = forward(f,e,T)
  % normalize is the alpha-function
  f_next = normalize(e*T*f.');
end
