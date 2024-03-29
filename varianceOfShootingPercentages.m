%Data for goals and shots of NHL teams between seasons 2013/14 and 2017/18
%Each row represents one team
%Columns represent:
    %goals from first x shots
    %x
%For more details plese see the xlsx data file at:
%https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910%2FDVN%2FJSRN7H
data = [41 1000;46 1000;44 1000;67 1000;39 1000;60 1000;46 1000;60 1000;57 1000;42 1000;49 1000;55 1000;49 1000;52 1000;60 1000;40 1000;62 1000;43 1000;53 1000;63 1000;56 1000;47 1000;54 1000;66 1000;47 1000;43 1000;52 1000;48 1000;42 1000;31 1000;58 1000;43 1000;40 1000;37 1000;57 1000;58 1000;52 1000;47 1000;35 1000;45 1000;49 1000;53 1000;76 1000;55 1000;46 1000;43 1000;45 1000;44 1000;55 1000;43 1000;39 1000;45 1000;48 1000;48 1000;52 1000;51 1000;38 1000;34 1000;34 1000;41 1000;48 1000;54 1000;60 1000;41 1000;43 1000;63 1000;40 1000;45 1000;50 1000;50 1000;41 1000;32 1000;64 1000;48 1000;50 1000;49 1000;31 1000;49 1000;42 1000;49 1000;53 1000;52 1000;58 1000;51 1000;50 1000;31 1000;49 1000;39 1000;54 1000;41 1000;46 1000;46 1000;40 1000;69 1000;48 1000;55 1000;51 1000;50 1000;40 1000;66 1000;49 1000;49 1000;46 1000;49 1000;51 1000;39 1000;50 1000;36 1000;47 1000;49 1000;48 1000;48 1000;45 1000;31 1000;45 1000;48 1000;43 1000;52 1000;61 1000;43 1000;44 1000;49 1000;39 1000;57 1000;44 1000;55 1000;46 1000;52 1000;39 1000;51 1000;34 1000;39 1000;47 1000;53 1000;46 1000;31 1000;49 1000;54 1000;62 1000;58 1000;47 1000;42 1000;45 1000;37 1000;59 1000;53 1000;39 1000;47 1000;50 1000;46 1000;55 1000];
shc = data(:,1) ./ data(:,2);

s = var(shc);
mu = mean(shc);
nu = mean(1 ./ data(: , 2));
teamsCount = length(shc);
b = chi2inv(0.975, teamsCount - 1);
a = chi2inv(0.025, teamsCount - 1);

%estimate of parameters of a priori distribution of shooting percentages
%across the league
alpha = mu * (1 - s / (mu - mu^2)) / (s / (mu - mu^2) - nu)
beta = (1 - mu) * (1 - s / (mu - mu^2)) / (s / (mu - mu^2) - nu)

%estimate of standard deviation
standardDeviation = sqrt((s - nu * mu * (1 - mu)) / (1 - nu))
lowerBoundForStandardDeviation = sqrt(((teamsCount - 1) / b * s - nu * mu * (1 - mu)) / (1 - nu))
upperBoundForStandardDeviation = sqrt(((teamsCount - 1) / a * s - nu * mu * (1 - mu)) / (1 - nu))