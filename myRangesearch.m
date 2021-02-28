function index = myRangesearch(datas, ref_position, range)
    diffs = datas - ref_position;
    distances = sqrt(diffs(1, :).^2 + diffs(2, :).^2)

    index = find(distances <= range);
end