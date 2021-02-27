classdef Map < handle
    properties
        size_x;
        size_y;
        size
        course_data;
        grid;
        binary_grid
        shorter_path_grid
        start_x;
        start_y;
        goal_x;
        goal_y;
        open_list = [];
    end
    methods
        function obj = Map(course_data, expantion) % x, y座標の行列　単位はcmにしたい
            obj.size_x = max(course_data(1, :)) - min(course_data(1, :)) + 1; % xのベクトルの最大値-最小値でマップのx方向サイズを計算 
            obj.size_y = max(course_data(2, :)) - min(course_data(2, :)) + 1; % yのベクトルの最大値-最小値でマップのy方向サイズを計算 
            obj.size = obj.size_x * obj.size_y;
            obj.course_data = course_data;
            [obj.grid, obj.binary_grid] = createMap(obj.size_x, obj.size_y, obj.course_data, expantion);
            obj.shorter_path_grid = obj.binary_grid;
            
            if course_data(1, 1) + 1 < 1
                obj.start_x = 1;
            elseif course_data(1, 1) + 1 > obj.size_y
                obj.start_x = obj.size_y;
            else
                obj.start_x = course_data(1, 1) + 1;
            end
            
            if course_data(2, 1) + 1 < 1
                obj.start_y = 1;   
            elseif course_data(2, 1) + 1 > obj.size_y
               obj.start_y =  obj.size_y;   
            else 
                obj.start_y = course_data(2, 1) + 1;
            end
                
            if course_data(1, end) + 1 < 1
                obj.goal_x = 1;
            elseif course_data(1, end) + 1 > obj.size_x
                obj.goal_x = obj.size_x;
            else
                obj.goal_x = course_data(1, end) + 1;
            end
            
            if course_data(2, end) + 1 < 1
                obj.goal_y =  1;
            elseif course_data(2, end) + 1 > obj.size_y
               obj.goal_y =  obj.size_y;   
            else 
               obj.goal_y = course_data(2, end) + 1;
            end
            
%             obj.start_x = course_data(1, 1);
%             obj.start_y = course_data(2, 1);
%             obj.goal_x = course_data(1, end);
%             obj.goal_y = course_data(2, end);
        end
        
        function calcScore(obj, x, y, g_cost, direction_cost)
            obj.grid(y, x).g_cost = g_cost + 1 + direction_cost;
%             obj.grid(y, x).g_cost = g_cost + 1;
%             obj.grid(y, x).h_cost = abs(obj.goal_x - x) + abs(obj.goal_y - y);
            obj.grid(y, x).h_cost = sqrt(power(obj.goal_x - x, 2) + power(obj.goal_y - y, 2));
%               obj.grid(y, x).h_cost = 0;

%             obj.grid(y, x).h_cost = obj.goal_x - x + obj.goal_y - y;

            obj.grid(y, x).score = obj.grid(y, x).g_cost + obj.grid(y, x).h_cost;
        end
        
        function openAroundNode(obj, ref_x, ref_y, cost_table)
            for i = -1 : 1
                x = ref_x + i;
                if x < 1
                    x = 1;
                    continue;
                elseif x > obj.size_x
                    x = obj.size_x;
                    continue;
                end
                
                for j =  -1 : 1
                    y = ref_y + j;
                    if y < 1
                        y = 1;
                        continue;
                    elseif y > obj.size_y
                        y = obj.size_y;
                        continue;
                    end
                    
                    
                    
                    if obj.grid(y, x).obstacle == 0 && obj.grid(y, x).status == 0 && ~(ref_x == x && ref_y == y) % 移動可能 かつ 状態がNone かつ 基準ノードでない
                        obj.grid(y, x).status = 1; % open
                        direction_cost = cost_table(j + 2, i + 2);
                        obj.calcScore(x, y, obj.grid(ref_y, ref_x).g_cost, direction_cost) % コストを計算
                        
                        temp_node.x = x;
                        temp_node.y = y;
                        temp_node.score = obj.grid(y, x).score;
                        temp_node.g_cost = obj.grid(y, x).g_cost;
                        temp_node.h_cost = obj.grid(y, x).h_cost;
                        obj.open_list = [obj.open_list, temp_node]; %オープンリストに追加
                        
                        obj.grid(y, x).parent = [ref_x, ref_y]; %親ノードの位置を保存
                    end
                    
                    obj.grid(ref_y, ref_x).status = -1; %基準ノードをクローズ
                    obj.deleteOpenList(ref_x, ref_y) %オープンリストからクローズした基準ノードを削除
                end
                
                
            end
 
        end

        function [ref_x, ref_y] = searchRefNode(obj)     
            scores = zeros(1, length(obj.open_list));
            
            for i = 1 : length(obj.open_list)
                scores(i) = obj.open_list(i).score;
            end
            
            minimum = min(min(scores));
            index = find(scores == minimum); % 最小スコアのインデックスを取得
            
            if length(index) > 1 %最小のコストが複数あったら
                disp('HERE')
                min_cost = 99999;
                min_index = [];
                for j = index
                    disp(num2str(obj.open_list(j).x));
                    disp(num2str(obj.open_list(j).y));

                    if obj.open_list(j).g_cost < min_cost
                        min_cost = obj.open_list(j).g_cost;
                        min_index = j;
                    end
                end     
            else 
                disp('here')
                min_index = index;
            end

            ref_x = obj.open_list(min_index).x;
            ref_y = obj.open_list(min_index).y;

        end
        
        function deleteOpenList(obj, ref_x, ref_y)
            for i = 1 : length(obj.open_list)
                if obj.open_list(i).x == ref_x && obj.open_list(i).y == ref_y
                    obj.open_list(i) = [];
                    break;
                end
            end
        end
        
        function cost_table = getCostTable(obj, x, y, pre_x, pre_y) % -の方向に進みやすい
            
            direction = obj.determineDirection(x, y, pre_x, pre_y);
            
            if strcmp(direction, 'u') % 上
                cost_table = [-1, -1, -1;
                              1, 0, 1;
                              1, 1, 1];
            elseif strcmp(direction, 'ru') % 右上
                cost_table = [1, -1, -1;
                              1, 0, -1;
                              1, 1, 1];
            elseif strcmp(direction, 'r') % 右
                cost_table = [1, 1, -1;
                              1, 0, -1;
                              1, 1, -1];
            elseif strcmp(direction, 'rb') % 右下
                cost_table = [1, 1, 1;
                              1, 0, -1;
                              1, -1, -1];
            elseif strcmp(direction, 'b') % 下
                cost_table = [1, 1, 1;
                              1, 0, 1;
                               -1, -1, -1];
            elseif strcmp(direction, 'lb') % 左下
                cost_table = [1, 1, 1;
                              -1, 0, 1;
                              -1, -1, 1];
            elseif strcmp(direction, 'l') % 左
                cost_table = [-1, 1, 1;
                              -1, 0, 1;
                              -1, 1, 1];
            elseif strcmp(direction, 'lu') % 左上
                cost_table = [-1, -1, 1;
                              -1, 0, 1;
                              1, 1, 1];
            else
                cost_table = [1, 1, 1;
                              1, 0, 1;
                              1, 1, 1];
            end
               
        end
        
        function direction = determineDirection(obj, x, y, pre_x, pre_y)
            
            dx = x - pre_x;
            dy = y - pre_y;
            
            if dx > 0 && dy > 0
                direction = 'rb';
            elseif dx == 0 && dy > 0
                direction = 'b';
            elseif dx < 0 && dy > 0
                direction = 'lb';
            elseif dx < 0 && dy == 0
                direction = 'l';
            elseif dx < 0 && dy < 0
                direction = 'lu';
            elseif dx == 0 && dy < 0
                direction = 'u';
            elseif dx > 0 && dy < 0
                direction = 'ru';
            elseif dx > 0 && dy == 0
                direction = 'r';
            end

%             if dx == 0 && dy > 0
%                 direction = 'b';
% 
%             elseif dx < 0 && dy == 0
%                 direction = 'l';
% 
%             elseif dx == 0 && dy < 0
%                 direction = 'u';
% 
%             elseif dx > 0 && dy == 0
%                 direction = 'r';
%             else
%                 direction = 'a'; % around
%             end
            
        end
        
    end

       
end

function [grid, binary_grid] = createMap(x_size, y_size, course_data, expantion)
    empty_grid = repmat(Node(1), y_size, x_size); % 行、列　＝　y, x
    empty_binary_grid = ones(y_size, x_size); % 行、列　＝　y, x

    x_datas = course_data(1, :);
    y_datas = course_data(2, :);
    half_expantion = round(expantion / 2);
    for i = 1 : length(x_datas)
        for ex = 1 : expantion
            for ey = 1 : expantion
                x = x_datas(i) + 1 - half_expantion + ex;
                y = y_datas(i) + 1 - half_expantion + ey;

                if x < 1
                   x = 1; 
                elseif x > x_size
                    x = x_size;
                end
                if y < 1
                   y = 1; 
                elseif y > y_size
                    y = y_size;
                end

                empty_grid(y, x) = Node(0);
                empty_binary_grid(y, x) = 0;
            end
        end
    end

    grid = empty_grid;
    binary_grid = empty_binary_grid;
    %             grid = flipud(empty_grid); %上下反転する
    %             binary_grid = flipud(empty_binary_grid);

end

    