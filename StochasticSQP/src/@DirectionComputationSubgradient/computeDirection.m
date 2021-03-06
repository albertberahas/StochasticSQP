% Copyright (C) 2020 Frank E. Curtis
%
% All Rights Reserved.
%
% Authors: Frank E. Curtis

% DirectionComputationSubgradient: computeDirection
function err = computeDirection(D,options,quantities,reporter,strategies)

% Initialize error
err = false;

% Store quantities
cE = quantities.currentIterate.constraintFunctionEqualities(quantities);
JE = quantities.currentIterate.constraintJacobianEqualities(quantities);
cI = quantities.currentIterate.constraintFunctionInequalities(quantities);
JI = quantities.currentIterate.constraintJacobianInequalities(quantities);

% Determine constraint activities
cE_P = find(cE > 0);
cE_N = find(cE < 0);
cI_P = find(cI > 0);
cI_Z = find(cI == 0);

% Compute subgradient
v = quantities.meritParameter * quantities.currentIterate.objectiveGradient(quantities);
if quantities.currentIterate.numberOfConstraintsEqualities > 0
  v = v + (ones(length(cE_P),1)'*JE(cE_P,:))' - (ones(length(cE_N),1)'*JE(cE_N,:))';
end
if quantities.currentIterate.numberOfConstraintsInequalities > 0
  v = v + (ones(length(cI_P),1)'*JI(cI_P,:))';
end

% Set direction
quantities.setDirectionPrimal(-v);

% Initialize multipliers
yE = zeros(quantities.currentIterate.numberOfConstraintsEqualities,1);
yI = zeros(quantities.currentIterate.numberOfConstraintsInequalities,1);

% Compute least squares multipliers
if D.compute_least_squares_multipliers_
  
  % Construct "active" Jacobian
  Jacobian = [JE' JI(cI_P,:)' JI(cI_Z,:)'];
  
  % Compute least squares multipliers
  y = -Jacobian\quantities.currentIterate.objectiveGradient(quantities);
  
  % Set multipliers in place
  yE = y(1:quantities.currentIterate.numberOfConstraintsEqualities);
  yI(cI_P) = y(quantities.currentIterate.numberOfConstraintsEqualities+1:quantities.currentIterate.numberOfConstraintsEqualities+length(cI_P));
  yI(cI_Z) = y(quantities.currentIterate.numberOfConstraintsEqualities+length(cI_P)+1:quantities.currentIterate.numberOfConstraintsEqualities+length(cI_P)+length(cI_Z));
    
end

% Set multipliers
quantities.currentIterate.setMultipliers(yE,yI);

end % computeDirection