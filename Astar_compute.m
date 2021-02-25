%% 前処理 non_class
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
[map, size_x, size_y] = createMap(course, expantion); %バイナリマップ

figure(3)
heatmap(map)
title('バイナリマップ')
xlabel('x')
ylabel('y')

%% 計算
% -----------A star開始------------ %

index.x = course_x + linspace(1, 1, length(course_x));  %コースの座標をマップのインデックスに使うため、すべての要素に1足す
index.y = course_y + linspace(1, 1, length(course_y));
index.max_x = size_x;
index.max_y = size_y;
index.start_x = index.x(1);
index.start_y = index.y(1);
index.end_x = index.x(end);
index.end_y = index.y(end);


map(index.start_x, index.start_y) %行列：y, x
cost_map = createCostMap(index.start_x, index.start_y, map);



function cost = getHcost(node_pos, goal_pos)
    cost = goal_pos(1) - node_pos(1) + goal_pos(2) - node_pos(2);
end


















