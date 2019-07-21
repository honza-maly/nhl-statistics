%Data for goals and shots of NHL teams between seasons 2013/14 and 2017/18
%Each row represents one team
%Columns represent:
    %goals from first 2000 shots
    %2000 shots
    %goals in the rest of the season
    %shots in the rest of the season
%For more details plese see the data file at:
data = [75 2000 124 2695;98 2000 163 2870;79 2000 114 2433;122 2000 162 2902;83 2000 121 2941;105 2000 160 2937;97 2000 112 2440;92 2000 119 2611;96 2000 146 2887;89 2000 169 2912;96 2000 144 2703;112 2000 109 2458;88 2000 139 2853;108 2000 140 2496;115 2000 122 2497;83 2000 139 3240;123 2000 131 2624;92 2000 130 3267;101 2000 114 2845;113 2000 136 2458;106 2000 140 2313;97 2000 129 2745;114 2000 142 2843;118 2000 150 2784;98 2000 128 2590;85 2000 157 3118;101 2000 127 2665;103 2000 109 2417;85 2000 124 3275;89 2000 133 2961;112 2000 148 2919;77 2000 110 2231;74 2000 154 2955;83 2000 110 2346;103 2000 121 2534;105 2000 107 2655;93 2000 151 2894;90 2000 101 2183;88 2000 114 2529;77 2000 121 2571;110 2000 162 2738;100 2000 105 2849;122 2000 126 2450;120 2000 118 2502;91 2000 162 2617;88 2000 85 1992;89 2000 118 2715;102 2000 131 2521;96 2000 135 2559;103 2000 124 2234;75 2000 83 2305;115 2000 144 2513;87 2000 130 2846;94 2000 140 2721;99 2000 143 2396;101 2000 116 2530;81 2000 132 2848;80 2000 107 2919;89 2000 82 2174;96 2000 117 2438;99 2000 138 2620;107 2000 96 2317;112 2000 119 2617;86 2000 109 2250;89 2000 128 2501;101 2000 112 2657;87 2000 102 2936;94 2000 106 2369;105 2000 119 2395;110 2000 121 2037;77 2000 158 2741;69 2000 132 2801;110 2000 119 2310;100 2000 111 2279;108 2000 133 2627;96 2000 77 1522;76 2000 112 2589;95 2000 126 2526;89 2000 135 2531;91 2000 120 2403;113 2000 97 2149;100 2000 112 2329;107 2000 152 3043;90 2000 132 2579;97 2000 112 2506;66 2000 145 2684;96 2000 136 2640;77 2000 134 3062;91 2000 91 2138;88 2000 132 2476;88 2000 104 2442;85 2000 115 2687;90 2000 62 1376;116 2000 139 2458;94 2000 114 2444;122 2000 81 2360;101 2000 123 2404;92 2000 133 2705;80 2000 117 2366;107 2000 104 2593;100 2000 107 2520;113 2000 129 2551;100 2000 122 2135;98 2000 134 2653;93 2000 82 1647;69 2000 113 2774;96 2000 143 3037;93 2000 124 3020;101 2000 133 2519;99 2000 108 1992;96 2000 127 2551;97 2000 156 3050;93 2000 125 2767;84 2000 135 2577;96 2000 124 2633;88 2000 134 3026;91 2000 126 2819;106 2000 124 2380;105 2000 123 2316;77 2000 114 2410;78 2000 82 2547;92 2000 162 2776;67 2000 80 1857;98 2000 128 2377;85 2000 117 2390;102 2000 115 2176;96 2000 117 2269;92 2000 134 2949;84 2000 104 2402;112 2000 126 2332;85 2000 144 2695;74 2000 138 2928;104 2000 119 2382;107 2000 114 2401;95 2000 93 1960;79 2000 122 2855;85 2000 127 2645;115 2000 145 2821;124 2000 112 2542;103 2000 132 2218;87 2000 109 1990;93 2000 136 2885;94 2000 117 2167;84 2000 130 2647;113 2000 143 2630;95 2000 140 3271;86 2000 108 2976;90 2000 95 2714;89 2000 106 2162;97 2000 97 2039;104 2000 103 2620];

%shc1 predicts team's future shooting percetnage as past goals/shots 
shc1Error = 0;

%shc2 predicts team's future shooting percetnage as average shooting percentage of all other teams 
shc2Error = 0;

%shc3 is a regression of shc1 to the mean shc2
shc3Error = 0;

%for each team we will make predictions of shooting percentages shc1, shc2 and shc3
for row = 1:size(data,1)
    
    %data without the team we are making the prediction for
    otherTeamsData = [data(1:row-1,:);data(row+1:end,:)];
    
    goals = data(row,1);
    shots = data(row,2);
    
    %shooting percetange of a given team
    shc1 = goals/shots;
    
    %average shooting percentage of all other teams
    shc2 = mean(otherTeamsData(:,1)./otherTeamsData(:,2));
    
    variance = var(otherTeamsData(:,1)./otherTeamsData(:,2));
    rho = shots/(shots-1) - shc2*(1-shc2)/((shots-1)*variance);
    
    %regression of shc1 to mean shc2
    shc3 = shc2 + rho*(shc1 - shc2);
    
    %real shooting percentage in the second half of the season
    shcReal = data(row,3)/data(row,4);

    shc1Error = shc1Error + abs(shc1 - shcReal);
    shc2Error = shc2Error + abs(shc2 - shcReal);
    shc3Error = shc3Error + abs(shc3 - shcReal);

end
    
avgShc1Error = shc1Error/size(data,1)
avgShc2Error = shc2Error/size(data,1)
avgShc3Error = shc3Error/size(data,1)