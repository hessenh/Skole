% This function normalizes the input vector, so that it adds ut to one
function normalized = normalize(unnormalized)
  value = sum(unnormalized);
  normalized = unnormalized / value;
end