% 前処理 master
clc
clf
clear

% --------------コースデータ用意-----------------%
course_x = round(linspace(-1, 10, 10));
course_y = [0, 1, 2, 3, 4, 4, 4, 3, 2, 1];

% course_x = round(1 : 1 : 500); %cm
% course_y = round(-sin(course_x/50) * 100); %cm
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
% % -----------A star開始------------ %
g_cost = 0;
x = map.start_x;
y = map.start_y;

map.openAroundNode(x, y, g_cost); % 周りのノードをオープン

g_cost = 1;
for i = 1 : 5
% while x ~= map.goal_x || y ~= map.goal_y

    [x, y] = map.searchRefNode(); %スコアが最も小さいノードのx, yを得る
    map.openAroundNode(x, y, g_cost);

    g_cost = g_cost + 1;

end

map.shorter_path_grid(y, x) = 2;
while x ~= map.start_x || y ~= map.start_y

    temp_xy = map.grid(y, x).parent;
    x = temp_xy(1);
    y = temp_xy(2);
    
    map.shorter_path_grid(y, x) = 2;
    
end

figure(4)
heatmap(map.shorter_path_grid)
















