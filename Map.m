classdef Map
    properties
        size_x;
        size_y;
        size
        course_data;
        grid;
        binary_grid
        start;
        goal;
    end
    methods
        function obj = Map(course_data, expantion) % x, y座標の行列　単位はcmにしたい
            obj.size_x = max(course_data(1, :)) - min(course_data(1, :)) + 1; % xのベクトルの最大値-最小値でマップのx方向サイズを計算 
            obj.size_y = max(course_data(2, :)) - min(course_data(2, :)) + 1; % yのベクトルの最大値-最小値でマップのy方向サイズを計算 
            obj.size = obj.size_x * obj.size_y;
            obj.course_data = course_data;
            [obj.grid, obj.binary_grid] = createMap(obj.size_x, obj.size_y, obj.course_data, expantion);
            obj.start = [course_data(1, 1), course_data(2, 1)];
            obj.goal = [course_data(1, end), course_data(2, end)];
        end
    end
       
end

function [grid, binary_grid] = createMap(x_size, y_size, course_data, expantion)
empty_grid = repmat(Node(0), y_size, x_size); % 行、列　＝　y, x
empty_binary_grid = zeros(y_size, x_size); % 行、列　＝　y, x

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

            empty_grid(y, x) = Node(1);
            empty_binary_grid(y, x) = 1;
        end
    end
end

grid = empty_grid;
binary_grid = empty_binary_grid;
%             grid = flipud(empty_grid); %上下反転する
%             binary_grid = flipud(empty_binary_grid);

end

    