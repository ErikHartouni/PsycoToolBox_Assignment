function [fractal_indexees, index_of_high_fractal] = select_fractals_for_one_set(fractals_avalable, fractal_values, to_have_high_value, number_of_fractals_to_show)
    fractals_without_high_value = fractal_values == 0;
    fractals_with_high_value = fractal_values == 1;

    fractal_indexees = randsample(fractals_avalable(fractals_without_high_value), number_of_fractals_to_show- to_have_high_value);
    index_of_high_fractal = randsample(fractals_avalable(fractals_with_high_value),  to_have_high_value);
    if isempty(index_of_high_fractal)
        index_of_high_fractal = -1;
    end
end