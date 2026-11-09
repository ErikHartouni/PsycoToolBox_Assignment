function [p_n3, p_n5, p_n7, p_n9] = initialize_position_for_all_n(window_rect, r, W_image, H_image)
    p_n3 = initial_position_with_n(window_rect, 3, r, W_image, H_image);
    p_n5 = initial_position_with_n(window_rect, 5, r, W_image,H_image);
    p_n7 = initial_position_with_n(window_rect, 7, r, W_image,H_image);
    p_n9 = initial_position_with_n(window_rect, 9, r, W_image,H_image);
end

function positions = initial_position_with_n(window_retc, n, r, W_image, H_image)

    %check the diameter of r
    r = min(max(r, H_image/sin(2 * pi/n)), W_image / (1-cos(2 * pi/n)) );
    
    %check the total radius of page
    if r * 2 + W_image > (window_retc(3) - window_retc(1) )

        k = (window_retc(3) - window_retc(1)) / (2 * r + W_image)
        r = k * r;
        W_image = W_image * k;
        H_image = H_image * k;
    end

    if r * 2 + H_image > (window_retc(4) - window_retc(2) )
        k = (window_retc(4) - window_retc(2)) / (2 * r + H_image)
        r = k * r;
        W_image = W_image * k;
        H_image = H_image * k;
    end

    %check the diameter of r again
    r = min(max(r, H_image/sin(2 * pi/n)), W_image / (1-cos(2 * pi/n)) )

    

    window_center = [(window_retc(3)-window_retc(1))/2,  (window_retc(4)-window_retc(2))/2]
    positions = zeros([4,n]);
    for k = 0:(n-1)
        theta = 2 * pi / n * k;
        picture_center =  window_center + r * [cos(theta), -sin(theta)];
        positions(:,k+1) = [picture_center(1) - W_image/2; 
                            picture_center(2) - H_image/2;
                            picture_center(1) + W_image/2;
                            picture_center(2) + H_image/2] ;

    end

end