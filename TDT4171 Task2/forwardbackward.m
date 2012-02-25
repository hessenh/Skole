% ev is the set of evidence for 1..t
% pripor is the initial state P(X_0)
% T is the transition matrix
function sv = forwardbackward(ev, prior, T) 
  fv(:,:,1) = prior;    % first forward message is "prior"
  ev_size = size(ev);	% ev is a vector of length t, so we extract t from ev
  t = ev_size(3);       % since ev is 3-dim., and we are interested in the number of time slices, this is the third dimension

% Initialize backward message array as [1 ; 1]*t
  b = [1.0 ;  1.0];     
  for i = 2.0:t
    b(:,:,i) = [1.0 ; 1.0];
  end  
  
% Initialize smoothing-array the same way as backward message array
  sv = [0.0 0.0];
  for i = 2.0:t
    sv(:,:,i) = [0.0 0.0];
  end  
  
% Calculate forward messages
  for i = 2.0:t
    fv(:,:,i) = forward(fv(:,:,i-1),ev(:,:,i), T);
  end

% Calculate backward messages and perform smoothing
  for i = t:-1.0:2.0
    sv(:,:,i) = normalize(fv(:,:,i).*b(:,:,i)');
    b(:,:,i-1) = backward(b(:,:,i), ev(:,:,i), T);
  end

% Display backward messages
disp('Backward-messages: ');
for i = 1:t
  disp([b(1,1,i) b(2,1,i)]);
end

% Display normalized backward messages
disp('Normalized Backward-messages: ');
for i = 1:t
  tmp = normalize(b(:,:,i));
  disp([tmp(1) tmp(2)]);
end
  
% Last (first) smoothed value not computed in loop
  sv(:,:,1) = normalize(fv(:,1)'.*b(:,:,1));
end
