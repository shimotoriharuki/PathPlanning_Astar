% 前処理 master
clc
clf
clear

% --------------コースデータ用意-----------------%
% course_x = round(linspace(-1, 10, 10));
% course_y = [0, 1, 2, 3, 4, 4, 4, 3, 2, 1];

% course_x = round(1 : 1 : 100); %cm
% course_y = round(-sin(course_x/10) * 50); %cm

% course_x = [0, 1, 2, 3, 4, 5];
% course_y = [0, 0, 1, 1, 2, 2];

num = linspace(0, 1 * pi, 100);
course_x = round(sin(num) * 50); %cm
course_y = round(cos(num) * 50); %cm

% num = linspace(0, 0.3 * pi, 100);
% course_x = round(sin(1 * num) * 10); %cm
% course_y = round(sin(4 * num) * 8); %cm

figure(1)
scatter(course_x, course_y)
title('コース元データ')
xlabel('x')
ylabel('y')
axis equal

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
x = map.start_x;
y = map.start_y;
pre_x = x;
pre_y = y;

g_cost = 0;
% cost_table = [-1, -1, -1;
%               1, 0, 1;
%               1, 1, 1];
cost_table = [0, 0, 0;
              0, 0, 0;
              0, 0, 0];
          
map.openAroundNodeDP(x, y, cost_table); % 周りのノードをオープン

count = 0;
% for i = 1 : 1 
while x ~= map.goal_x || y ~= map.goal_y

    [x, y] = map.searchRefNode(); % スコアが最も小さいノードのx, yを得る
%     cost_table = map.getCostTable(x, y, pre_x, pre_y); % コストテーブルを更新
    map.openAroundNodeDP(x, y, cost_table);
    
    pre_x = x;
    pre_y = y;
    
    count = count + 1;
    
end

disp(count)
% % -----------プロット------------ %
map.shorter_path_grid(y, x) = 2;
store_x = [];
store_y = [];
while x ~= map.start_x || y ~= map.start_y

    temp_xy = map.grid(y, x).parent;
    x = temp_xy(1);
    y = temp_xy(2);
    
    store_x = [store_x, x];
    store_y = [store_y, y];
    
    map.shorter_path_grid(y, x) = 2;
end

figure(4)
heatmap(map.shorter_path_grid)

figure(5)
hold on
scatter(course(1, :), course(2, :))
title('マージンしたコースデータ')
xlabel('x')
ylabel('y')
axis equal

scatter(store_x, store_y)
title('ショートカット')
xlabel('x')
ylabel('y')
axis equal
hold off














