function value_matrix = give_randomly_fractals(ID, avalable_fractal_numbers)
    
    arguments
        ID
        avalable_fractal_numbers = 48
    end
    value_matrix = zeros([1,avalable_fractal_numbers]);
    indexes = 1: (avalable_fractal_numbers/2+1);
    value_matrix(randsample(indexes, avalable_fractal_numbers/4)) = 1;
    indexes = (avalable_fractal_numbers/2+1);
    value_matrix(randomsample())
    
    
end