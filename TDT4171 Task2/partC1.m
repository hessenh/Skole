% Clear old variables
clear O
clear T
clear fv

% Setting up the transition matrix
T = [0.7 0.3 ; 0.3 0.7];

% Setting up evidence
% Stupid MATLAB, beginning at 1, not 0
% State 1 is state 0 in the book, state 2 is first "real" state
O = [0 0 ; 0 0]; % Dummy-state for "nothing"
O(:,:,2) = [0.9 0.0 ; 0.0 0.2];
O(:,:,3) = [0.9 0.0 ; 0.0 0.2];

% Initial state
X = [0.5 0.5];

% Run the forward-backward algorithm
forwardbackward(O, X, T)