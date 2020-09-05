% Copyright (C) 2020 Frank E. Curtis
%
% All Rights Reserved.
%
% Authors: Frank E. Curtis

% Stochastic SQP: printHeader
function printHeader(S)

% Get global variables
global R_SOLVER R_PER_ITERATION

% Print software name
S.reporter.printf(R_SOLVER,R_PER_ITERATION,...
                  ['+---------------------------------------------------------------------+\n'...
                   '|                             StochasticSQP                           |\n'...
                   '| StochasticSQP is released as open source code under the MIT License |\n'...
                   '+---------------------------------------------------------------------+\n'...
                   '\n'...
                   'This is StochasticSQP version %s\n'...
                   '\n'],...
                   '0.1.0');

end