% 前処理 master
clc
clf
clear

% --------------コースデータ用意-----------------%
course_x = round(linspace(0, 10, 5));
course_y = round(linspace(0, 5, 5));

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
map.calcScore(1, 1, 0); %スタートノードのスコアを計算

map.openAroundNode(1, 1, 1); % 周りのノードをオープン
% [x, y] = map.searchRefNode(); %スコアが最も小さいノードのx, yを得る


g_cost = 2;
% while x ~= map.goal_x || x ~= map.goal_y
for i = 1 : 4
    [x, y] = map.searchRefNode(); %スコアが最も小さいノードのx, yを得る
    map.openAroundNode(x, y, g_cost);
    
    g_cost = g_cost + 1;
end





















