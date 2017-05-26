function exercise4_11 ()
% EXERCISE4_11 Solves exercse 4.11 of book.
%
% exercise4_11 ()
%
% Solves system with SOR method. Plots SOR iterations errors for different
% values of omega.

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

A = [
     4 -1 0 -1 0 0;
     -1 4 -1 0 -1 0;
     0 -1 4 0 0 -1;
     -1 0 0 4 -1 0;
     0 -1 0 -1 4 -1;
     0 0 -1 0 -1 4;
];  % input matrix
b = [2 1 2 2 1 2]';  % known terms

toll = 1e-8;
kmax = 50;
x0 = zeros(6, 1);
o = 1;  % initial set of omega parameter
xSolution = ones(6, 1);  % correct solution of Ax = b

%% Solve system
disp('Solving system with omega = 1');
[x, k] = sor(A, b, x0, toll, kmax, o)

%% Plots comparison of different values of omega
figure  % initalize plot
minO = 0;
maxO = 2;
lenO = 51;
oValues = linspace(minO, maxO, lenO);

%% Solve with mulitple omegas
for oI = 2 : length(oValues) - 1  % except 0 and 2
    o = oValues(oI);
    n = size(A, 1);
    k = 0;
    x = x0;
    r = b - A * x;
    testToll = norm(r);
    toll = toll * norm(b);
    xHelper = zeros(n, 1);
    errors = [];
    
    while testToll > toll && k < kmax
        k = k + 1;
        errors = [errors log10(norm(x - xSolution))];  % add error of iteration

        for i = 1 : n
            xHelper(i) = 0;
            for j = 1 : i - 1
                xHelper(i) = xHelper(i) + A(i, j) * xHelper(j);
            end

            for j = i + 1 : n
                xHelper(i) = xHelper(i) + A(i, j) * x(j);
            end

            xHelper(i) = (b(i) - xHelper(i)) / A(i, i);
            xHelper(i) = x(i) + o * (xHelper(i) - x(i));
        end

        x = xHelper;
        r = b - A * x;
        testToll = norm(r);
    end
    
    %% Plot errors
    plot(linspace(1, k, k), errors, '-');  % plot iterations
    hold on  % wait before showing plot
    legendInfo{oI - 1} = ['omega = ' num2str(o)];
end

%% Prettify plot
xlabel('iterations');  % add axis labels to plot
ylabel('log10 of error of solution');
title('SOR solution comparison with multiple omegas parameters');  % add title
legend(legendInfo);  % add legend
hold off  % release lock and show plot
