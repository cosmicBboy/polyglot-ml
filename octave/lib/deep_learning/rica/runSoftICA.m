%% We will use minFunc for this exercise, but you can use your
% own optimizer of choice
clear all;
addpath(genpath('../common')) % path to minfunc
addpath ../ex1;
%% These parameters should give you sane results. We recommend experimenting
% with these values after you have a working solution.
global params;
params.m=50000; % num patches
params.patchWidth=9; % width of a patch
params.n=params.patchWidth^2; % dimensionality of input to RICA
params.lambda = 0.001; % sparsity cost
params.numFeatures = 50; % number of filter banks to learn
params.epsilon = 1e-2; % epsilon to use in square-sqrt nonlinearity

% Load MNIST data set
data = loadMNISTImages('../common/train-images-idx3-ubyte');

%% Preprocessing
% Our strategy is as follows:
% 1) Sample random patches in the images
% 2) Apply standard ZCA transformation to the data
% 3) Normalize each patch to be between 0 and 1 with l2 normalization

% Step 1) Sample patches
patches = samplePatches(data,params.patchWidth,params.m);
% Step 2) Apply ZCA
[Z, U, S, V] = zca2(patches); % Note U, S, and V are not used here
% Step 3) Normalize each patch. Each patch should be normalized as
% x / ||x||_2 where x is the vector representation of the patch
m = sqrt(sum(Z .^ 2) + (1e-8));
x = bsxfunwrap(@rdivide, Z, m);

%% Run the optimization
options.Method = 'lbfgs';
options.MaxFunEvals = Inf;
options.MaxIter = 500;
options.useMex = 0;
%options.display = 'off';
options.outputFcn = @showBases;

% initialize with random weights
randTheta = randn(params.numFeatures,params.n)*0.01; % 1/sqrt(params.n);
randTheta = randTheta ./ repmat(sqrt(sum(randTheta.^2,2)), 1, size(randTheta,2));
randTheta = randTheta(:);

% % uncomment this part if you want to do gradient checking
% num_checks = 100;
% grad_check(@softICACost, randTheta, num_checks, x, params);

% optimize
[opttheta, cost, exitflag] = minFunc( @(theta) softICACost(theta, x, params), randTheta, options); % Use x or xw

% % display result
W = reshape(opttheta, params.numFeatures, params.n);
display_network(W');
