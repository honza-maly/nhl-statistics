a = 77;
b = 1530;
teamsC = 1000;
shotsCmin = 1000;
shotsCmax = 10000;
teamsI = 1000;
shotsI = 4000;

%data for control subjects
pC = betarnd(a, b, teamsC, 1);
nC = unidrnd(shotsCmax - shotsCmin + 1, teamsC, 1) + shotsCmin - 1;
mC = binornd(nC, pC);

%data for subjects of interest
pI = betarnd(a, b, teamsI, 1);
mI = binornd(shotsI, pI);

%estimating probability by m/n
estP1 = mI / shotsI;

%regression of the basic estimate to the mean
mu = mean(mC ./ nC);
nu = mean(1 ./ nC);
s = var(mC ./ nC);
corr = (s - mu * (1 - mu) * nu) / ((shotsI - 1) / shotsI * s + mu * (1 - mu) * (1 / shotsI - nu));
regression = @(mu, corr, m, n) mu + corr * (m / n - mu);
estP3 = regression(mu, corr, mI, shotsI);

%sum of total error of estimate m/n
errorP1 = mean(abs(estP1 - pI))

%sum of total error of estimate by overall average
errorP2 = mean(abs(mu - pI))

%sum of total error of the estimate regressed to the mean
errorP3 = mean(abs(estP3 - pI))