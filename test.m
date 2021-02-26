index = [3, 2, 2];
cost = [1, 2, 3];

if length(index) > 1 %最小のコストが複数あったら
    disp('HERE')
    min_cost = 99999;
    min_index = [];
    for j = index
        if cost(j) < min_cost
            min_cost = cost(j);
            min_index = j;
        end
    end     
else 
    min_index = index;
end