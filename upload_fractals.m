function [H, W, fractals] = upload_fractals(dir, max_number)
    fractals = imread([dir, '\\01.jpeg']);
     [H, W, rgb_or_gray] = size(fractals);

    fractals = zeros([max_number, H, W, 3]);
    for k = 1:max_number
        fractals(k,:,:,:) = imread([dir,'//',sprintf('%02d', k) ,'.jpeg']);
    end
end