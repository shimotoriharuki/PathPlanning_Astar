function shortcut_course = computeAstar(map)
    % % -----------A star開始------------ %
    x = map.start_x;
    y = map.start_y;
    pre_x = x;
    pre_y = y;

    % cost_table = [1, 1, 1;
    %               1, 0, 1;
    %               0, 0, 0];
    cost_table = [0, 0, 0;
                  0, 0, 0;
                  0, 0, 0];

    map.openAroundNode(x, y, cost_table); % スタートノードの周りをオープン

    count = 0;
    % for i = 1 : 1 
    while x ~= map.goal_x || y ~= map.goal_y

        [x, y] = map.searchRefNode(); % スコアが最も小さいノードのx, yを得る
%         cost_table = map.getCostTable(x, y, pre_x, pre_y); % コストテーブルを更新 
        map.openAroundNode(x, y, cost_table);

        pre_x = x;
        pre_y = y;

        count = count + 1;

    end

    disp(count)

    % % -----------最短経路の座標を取得------------ %
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

    shortcut_course = [store_x; store_y];
end