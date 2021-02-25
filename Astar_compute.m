%% 前処理 master
clc
clf
clear

% --------------コースデータ用意-----------------%
course_x = round(linspace(0, 10, 10));
course_y = round(linspace(0, 15, 10));

% course_x = round(-1 : 1 : 5); %cm
% course_y = round(sin(course_x/100) * 100); %cm
% course = [[0, 1, 2, 3, 4, 5]; [0, 0, 1, 1, 2, 2]];

figure(1)
scatter(course_x, course_y)
title('コース元データ')
xlabel('x')
ylabel('y')

% ------------------正の整数にするためにマージンをとる---------------- %
min_x = min(course_x);
min_y = min(course_y);
if min_x < 0
    mergin_x = linspace(abs(min_x), abs(min_x), length(course_x));
    course_x = course_x + mergin_x;
end
if min_y < 0
    mergin_y = linspace(abs(min_y), abs(min_y), length(course_y));
    course_y = course_y + mergin_y;
end

course = [course_x; course_y];

figure(2)
scatter(course(1, :), course(2, :))
title('マージンしたコースデータ')
xlabel('x')
ylabel('y')

% -------------------マップ作成--------------------%
expantion = round(3); %cm 膨張させる大きさ
map = Map(course, expantion); %バイナリマップ

figure(3)
heatmap(map.binary_grid)
title('バイナリマップ')
xlabel('x')
ylabel('y')

% 計算
% -----------A star開始------------ %

map.grid(1, 1).score = calcScore(map, 1, 1); %スタートのスコアを計算
map.grid(1, 1).score
% map.grid(1, 1).score = 10;

function score = calcScore(map, x, y)
    map.grid(y, x).g_cost = 0;
    map.grid(y, x).h_cost = map.goal_x - x + map.goal_y - y;
    score = map.grid(y, x).g_cost + map.grid(y, x).h_cost;
end



















