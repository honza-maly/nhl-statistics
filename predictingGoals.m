%Data for goals and shots of NHL teams between seasons 2013/14 and 2017/18
%Each row represents one team
%Columns represent:
    %goals from first 41 games
    %shots from first 41 games
    %goals from remaining 41 games
    %shots from remaining 41 games
%For more details plese see the xlsx data file at:
%https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910%2FDVN%2FJSRN7H
data = [89 2333 110 2362;131 2379 130 2491;89 2201 104 2232;145 2548 139 2354;98 2517 106 2424;129 2403 136 2534;108 2215 101 2225;110 2336 101 2275;110 2399 132 2488;108 2478 150 2434;117 2366 123 2337;119 2247 102 2211;106 2362 121 2491;120 2238 128 2258;124 2180 113 2317;110 2589 112 2651;135 2336 119 2288;120 2651 102 2616;114 2396 101 2449;130 2236 119 2222;116 2089 130 2224;118 2381 108 2364;125 2330 131 2513;135 2370 133 2414;111 2233 115 2357;111 2581 131 2537;116 2316 112 2349;107 2150 105 2267;108 2600 101 2675;111 2624 111 2337;135 2422 125 2497;84 2187 103 2044;94 2537 134 2418;92 2111 101 2235;113 2213 111 2321;120 2373 92 2282;123 2450 121 2444;95 2103 96 2080;99 2206 103 2323;87 2330 111 2241;137 2471 135 2267;114 2429 91 2420;138 2196 110 2254;131 2231 107 2271;114 2333 139 2284;88 1972 85 2020;104 2324 103 2391;113 2231 120 2290;105 2238 126 2321;112 2127 115 2107;77 2087 81 2218;131 2201 128 2312;107 2384 110 2462;112 2388 122 2333;108 2115 134 2281;109 2205 108 2325;104 2413 109 2435;93 2383 94 2536;95 2041 76 2133;106 2213 107 2225;112 2335 125 2285;112 2071 91 2246;121 2247 110 2370;90 2126 105 2124;99 2229 118 2272;116 2381 97 2276;101 2452 88 2484;96 2060 104 2309;109 2190 115 2205;108 1965 123 2072;93 2292 142 2449;86 2314 115 2487;118 2097 111 2213;102 2065 109 2214;127 2307 114 2320;86 1742 87 1780;90 2381 98 2208;109 2291 112 2235;105 2311 119 2220;96 2215 115 2188;115 2045 95 2104;109 2167 103 2162;140 2504 119 2539;104 2358 118 2221;108 2246 101 2260;76 2357 135 2327;114 2251 118 2389;100 2489 111 2573;96 2098 86 2040;100 2239 120 2237;93 2195 99 2247;99 2301 101 2386;71 1634 81 1742;131 2239 124 2219;105 2172 103 2272;128 2182 75 2178;112 2208 112 2196;104 2277 121 2428;96 2203 101 2163;116 2237 95 2356;106 2189 101 2331;119 2207 123 2344;100 2002 122 2133;119 2292 113 2361;87 1881 88 1766;81 2305 101 2469;115 2443 124 2594;121 2590 96 2430;125 2283 109 2236;101 2014 106 1978;107 2383 116 2168;124 2409 129 2641;117 2380 101 2387;99 2336 120 2241;106 2343 114 2290;109 2493 113 2533;113 2473 104 2346;109 2204 121 2176;109 2121 119 2195;89 2221 102 2189;91 2276 69 2271;115 2359 139 2417;65 1960 82 1897;107 2175 119 2202;98 2248 104 2142;107 2062 110 2114;104 2106 109 2163;112 2455 114 2494;92 2168 96 2234;125 2213 113 2119;103 2319 126 2376;92 2379 120 2549;108 2087 115 2295;115 2260 106 2141;92 1934 96 2026;96 2413 105 2442;103 2251 109 2394;153 2463 107 2358;144 2266 92 2276;115 2158 120 2060;91 2077 105 1913;116 2484 113 2401;96 2046 115 2121;104 2353 110 2294;125 2253 131 2377;128 2711 107 2560;101 2434 93 2542;104 2324 81 2390;89 2020 106 2142;102 2081 92 1958;116 2343 91 2277];

%g1 predicts team's future goals per game as past goals per game 
errorGpg1 = 0;

%g2 predicts team's future goals per game as average goals per game of all other teams 
errorGpg2 = 0;

%g3 applies regression to the mean to shooting percentages of the first
%half of the season
errorGpg3 = 0;

%g4 applies regression to the mean to both shots and shooting percentages
%of the first half of the season
errorGpg4 = 0;

for row = 1:size(data,1)
    
    goals = data(row,1);
    shots = data(row,2);
        
    %data without the team we are making the prediction for
    otherTeamsData = [data(1: row - 1, :); data(row + 1: end, :)];
    
    %regression of shooting percentage to the mean
    mu = mean(otherTeamsData(:, 1) ./ otherTeamsData(: ,2));
    s = var(otherTeamsData(:, 1) ./ otherTeamsData(:, 2));
    nu = mean(1 ./ otherTeamsData(:, 2));
    rho = (s - mu * (1 - mu) * nu) / ((shots - 1) / shots * s + mu * (1 - mu) * (1 / shots - nu));
    shcEst = mu + rho * (goals / shots - mu);

    %regression of shots to the mean
    shotsVar = var(otherTeamsData(:, 2));
    shotsMean = mean(otherTeamsData(:, 2));
    shotsEst = (shotsMean + (shotsVar - shotsMean) / shotsVar * (shots - shotsMean)) / 41;
    
    %different estimates of goals per game
    gpg1 = goals / 41;
    gpg2 = mean(otherTeamsData(:, 1)) / 41;
    gpg3 = shcEst * shots / 41;
    gpg4 = shcEst * shotsEst;
    
    %real goals per game in teh second half of the season
    realGpg = data(row, 3) / 41;
    
    %cumulative absolute estimate errors
    errorGpg1 = errorGpg1 + abs(gpg1 - realGpg);
    errorGpg2 = errorGpg2 + abs(gpg2 - realGpg);
    errorGpg3 = errorGpg3 + abs(gpg3 - realGpg);
    errorGpg4 = errorGpg4 + abs(gpg4 - realGpg);
end
    
avgErrorGpg1 = errorGpg1 / size(data,1)
avgErrorGpg2 = errorGpg2 / size(data,1)
avgErrorGpg3 = errorGpg3 / size(data,1)
avgErrorGpg4 = errorGpg4 / size(data,1)