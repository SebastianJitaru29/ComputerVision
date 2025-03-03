function rectangle(file1, file2)
    data1 = readfile(file1);
    data2 = readfile(file2);

    %direction vectors of the sides of the rectangles
    dir1 = compute_direction_vectors(data1);
    dir2 = compute_direction_vectors(data2);
    %camera constant 'f'
    dot_product = dot(dir1, dir2); %dot prod of direction vec
    f = abs(dot_product / (norm(dir1) * norm(dir2)));%normalize
    fprintf('Camera constant (f): %f\n', f);

    fprintf('Direction vectors of rectangle sides:\n');
    fprintf('Side 1: [%f, %f, %f]\n', dir1(1), dir1(2), dir1(3));
    fprintf('Side 2: [%f, %f, %f]\n', dir2(1), dir2(2), dir2(3));


    %compute the normal of the planar patch containing the rectangle
    normal = cross(dir1, dir2);
    normal = normal / norm(normal);
    fprintf('Normal of the planar patch: [%f, %f, %f]\n', normal(1), normal(2), normal(3));
end


function dir = compute_direction_vectors(data)
    %dir vector for set of parallel lines

    n = 3; 
    m = size(data, 1);
    if m < 3
        error('Not enough data points (m < 3).');
    end

    a = zeros(m,n);
    a(:,1) = data(:,4) - data(:,2);
    a(:,2) = -(data(:,3) - data(:,1));
    a(:,3) = data(:,2) .* -a(:,2)  - data(:,1) .* a(:,1);
    
    [U,S,V] = svd(a);  % call matlab SVD routine
    v_min = V(:,n); % s and v are already sorted from largest to smallest
    if all(v_min < 0); v_min = -v_min; end % ?

    dir = v_min / norm(v_min); 
end

function data = readfile(file)
    f = fopen(file, 'r');
    for i = 1:4
        fgets(f);
    end
    all = fscanf(f, '%f %f %f %f ');
    m = length(all) / 4;
    data = reshape(all, 4, m)';
    fclose(f);
end
