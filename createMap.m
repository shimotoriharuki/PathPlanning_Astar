function [map, size_x, size_y] = createMap(course_data, expantion)
    size_x = max(course_data(1, :)) - min(course_data(1, :)) + 1; % xのベクトルの最大値-最小値でマップのx方向サイズを計算 
    size_y = max(course_data(2, :)) - min(course_data(2, :)) + 1; % yのベクトルの最大値-最小値でマップのy方向サイズを計算
    empty_map = zeros(size_y, size_x); % 行、列　＝　y, x

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
                elseif x > size_x
                    x = size_x;
                end
                if y < 1
                   y = 1; 
                elseif y > size_y
                    y = size_y;
                end

                empty_map(y, x) = 1;
            end
        end
    end

    map = empty_map;
%             grid = flipud(empty_map); %上下反転する

end