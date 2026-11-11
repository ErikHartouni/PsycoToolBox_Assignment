function [charachters, mouse_position] = give_pressed_keys(pressed_matricx, mouse_positions)
    pressed_keys_index = find(pressed_matricx > 0);

    press_time = pressed_matricx(pressed_keys_index);

    [~, sorted_index] = sort(press_time);
    ordered_codes = pressed_keys_index(sorted_index);

    charachters = cell(1, length(pressed_keys_index));
    mouse_position = [];
    for i = 1:length(ordered_codes)
        char = KbName(ordered_codes(i));
        if strcmp(char, 'x') || strcmp(char, 'space')
            charachters{i} = char;
            that_pressed_time = press_time(sorted_index(i));
            [~, closest_index] = min(abs(mouse_positions(:,1) - that_pressed_time));
            mouse_position(end+1,:) = mouse_positions(closest_index, 2:3);
        end
    end

    charachters = charachters(~cellfun('isempty', charachters));

end