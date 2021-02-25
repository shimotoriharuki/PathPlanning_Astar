function cost_map = createCostMap(ref_x, ref_y, src_map)
    info.g = 0;
    info.h = 0;
    info.x = 0;
    info.y = 0;
    info.status = 0;
    
    cost_map = repmat(info, 3, 3);

    for x = 1 : 3
        if x == 1
            mergin_x = ref_x - 1;
        elseif x == 2
            mergin_x = ref_x;
        elseif x == 3
            mergin_x = ref_x + 1;
        end
        
        max_x = size(src_map, 2);
        if mergin_x >= max_x
            mergin_x = max_x;
        elseif mergin_x < 1
            mergin_x = 1;
        end
        
        for y = 1 : 3 
            if y == 1
                mergin_y = ref_y - 1;
            elseif y == 2
                mergin_y = ref_y;
            elseif y == 3
                mergin_y = ref_y + 1;
            end
            
            max_y = size(src_map, 1);
            if mergin_y >= max_y
                mergin_y = max_y;
            elseif mergin_y < 1
                mergin_y = 1;
            end
        
            cost_map(y, x).x =  mergin_x;
            cost_map(y, x).y =  mergin_y;
        end
    end
    
end