% Jeff Arata - 11/15/17
% This function is an implementation of a Normalized LMS adaptive filter 
% using information gleaned from the wikipedia article on the filter.

function [h, e, y] = adap_nlms( x, d, mu, order )
% This function is an adaptive filter using an LMS algorithm.
%
% x     - is the input signal
% d     - is the desired signal
% mu    - is the convergence constant
% order - is the filter order we want
%
% h     - the filter coefficients
% e     - the error found
% y     - the filtered output signal

x = x(:);               % Make sure x is a column vector
N = length(x);          

h = zeros(order, 1);    % Initialize filter coefficients to be 0
e = zeros(1,N);         % Initialize error vector for efficiency
y = zeros(N,1);         % Initialize output

for ii = order:N 
    x_col = x(ii:-1:ii-order+1);        % Slice of x we want  
    e(ii) = d(ii) - h' * x_col;         % Error at current time of iith sample
    y(ii) = h' * x_col;                 % Update output
    h = h + mu * conj(e(ii)) * x_col / (x_col' * x_col);   % Update the filter weights.
end

end