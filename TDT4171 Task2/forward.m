% The Markow assumption, Eq. 15.5 in AIMA

function f_next = forward(f,e,T)
    % Eq. 15.12 is matrix-vector operation of 15.5, this is its equivalent
    % written in MATLAB
    f_next = normalize(e*T*f);
end
