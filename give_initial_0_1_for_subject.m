function value_matrix = give_initial_0_1_for_subject(ID, avalable_fractal_numbers)
    
    rng(ID);

    value_matrix = zeros([1,avalable_fractal_numbers]);
    indexes = 1: (avalable_fractal_numbers/2);
    value_matrix(randsample(indexes, avalable_fractal_numbers/4)) = 1;
    indexes = (avalable_fractal_numbers/2+1): (avalable_fractal_numbers);
    value_matrix(randsample(indexes, avalable_fractal_numbers/4)) = 1;
    
    
end