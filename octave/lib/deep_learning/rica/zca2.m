function [Z, U, S, V] = zca2(x)
epsilon = 1e-2;
% You should be able to use the code from your PCA/ZCA exercise
% Retain all of the components from the ZCA transform (i.e. do not do
% dimensionality reduction)

% x is the input patch data of size
% z is the ZCA transformed data. The dimenison of z = x.
sigma_x = x * x' / size(x, 2);
[U, S, V] = svd(sigma_x);
Z = U * diag(1 ./ sqrt(diag(S) + epsilon)) * U' * x;

end
