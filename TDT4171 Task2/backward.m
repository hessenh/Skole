% Eq. 15.9 in AIMA

function sv = backward(b, e, T)
	sv = normalize(T*e*b.');
end