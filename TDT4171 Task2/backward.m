% Eq. 15.9 in AIMA
% 
% Eq. 15.13 is the eqivalent equation using matrixes,
% this is its implementation in MATLAB
function sv = backward(b, O, T)
	sv = T*O*b;
end