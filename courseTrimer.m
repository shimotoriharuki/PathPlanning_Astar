function [trimming_course, remaining_course] = courseTrimer(course, range, search_mergin)
    for i = search_mergin : length(course) % search_meginから検索することで、同じ交差点を検知することを防ぐ
        ref_position = [course(1, i); course(2, i)];
        diffs = course - ref_position;
        distances = sqrt(diffs(1, :).^2 + diffs(2, :).^2); % すべての点とref_positionとの距離を計算

        index = find(distances <= range); % 距離がrange以下だったインデックスを取得

        outlier = isoutlier(index); % 外れ値検知　外れ値があったら外れ値の位置に1がたつ
        total = sum(outlier, 'all'); % すべて足す
        flag = ge(total, 1); % 1以上（1つでも外れ値があったら）だったら交差している
        
        if flag == 1 % 交差点だったら
            disp('cross!!')
            trimming_course = [course(1, 1 : i); course(2, 1 : i)];
            
            % 残りのコースを返す
            remaining_course = [course(1, i + 1 : end); course(2, i + 1 : end)];
            break;
        
        else 
            trimming_course = course;
            remaining_course = course;
        end
        
    end
      
end
