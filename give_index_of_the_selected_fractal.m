function index_of_fractal = give_index_of_the_selected_fractal(mouse_psition, fractal_positions)
    index_of_fractal = -1;
    
    
    for i = 1:size(fractal_positions,2)
        if mouse_psition(1) > fractal_positions(1,i) && mouse_psition(1) < fractal_positions(3,i)
            if mouse_psition(2) > fractal_positions(2,i) && mouse_psition(2) < fractal_positions(4,i)
                index_of_fractal = i
                break
            end
        end
    end
    
end