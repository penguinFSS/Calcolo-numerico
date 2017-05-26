function [x, k] = jacobi(A, b, x0, toll, kmax)
% JACOBI: Solve Ax = b with Jacobi method
%
%  [x, k] = jacobi(A, b, x0, toll, kmax)
%
% Input:
% A - Matrix n x n
% b - vector of known terms
% x0 - starting vector
% toll - max error tolerance
% kmax - max number of iterations
%
% Output:
% x - solution of Ax = b
% k - number of iterations done

% Copyright 2017 Stefano Fogarollo
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
% http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.


n = size(A, 1);
k = 0;
x = x0;
testToll = toll + 1;
xHelper = zeros(n, 1);
while testToll > toll & k < kmax
    k = k + 1;
    for i = 1 : n
        xHelper(i) = 0;
        for j = 1 : i - 1
            xHelper(i) = xHelper(i) + A(i, j) * x(j);
        end
        
        for j = i + 1 : n
            xHelper(i) = xHelper(i) + A(i, j) * x(j);
        end
        
        xHelper(i) = (b(i) - xHelper(i)) / A(i, i);
    end
    
    testToll = abs(xHelper - x);
    x = xHelper;
end