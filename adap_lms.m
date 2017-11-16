% Jeff Arata - 11/8/17
% This function is an implementation of an LMS adaptive filter using
% information gleaned from the wikipedia article on the filter.

function [e, h] = adap_lms( x, d, mu, order )
% This function is an adaptive filter using an LMS algorithm.
%
% x     - is the input signal
% d     - is the desired signal
% mu    - is the convergence constant
% order - is the filter order we want
%
% h     - the filter coefficients
% e     - the error found

x = x(:);               % Make sure x is a column vector
N = length(x);          

h = zeros(order+1, 1);  % Initialize filter coefficients to be 0
e = zeros(1,N);         % Initialize error vector for efficiency

for ii = order+1:N 
    x_col = x(ii:-1:ii-order);          % Slice of x we want  
    e(ii) = d(ii) - h' * x_col;         % Error at current time of iith sample
    h = h + mu * conj(e(ii)) * x_col;   % Update the filter weights.
end

end

