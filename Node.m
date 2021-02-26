classdef Node < handle
    properties
        obstacle % 0:障害物なし, 1:障害物
        status % 0:None, 1:Open, -1:close
        g_cost
        h_cost
        score
        parent % [x, y]
    end
    methods
        function obj = Node(obstacle_flag)
            obj.obstacle = obstacle_flag;
            obj.status = 0;
            obj.g_cost = 0;
            obj.h_cost = 0;
            obj.score = 0;
            obj.parent = [];
        end
    end
end