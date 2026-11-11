 %% initial variables

SCREEN_NUMBER = 0;

BG_COLOR = [0, 0, 0];
WINDOW_RECT = [500,500, 1500, 1000];
R = 50;
FRACTAL_NUMBERS = 48; 
NUMBER_OF_AVALABLE_FRACTAL_SHOWS = [3, 5, 7, 9];


TOTAL_TRIAL_NUMBER= 4;

REWARD_AMOUNT = 1000;

%% subject variables
SUBJECT_NAME = 'ERIK';
SUBJECT_ID = 401102778;
total = 0.0;
%% inital show variables

state = 0;
next_satae = 1;
% fixation 
FIXATION_CIRCLE_RADIUS = 10;
FIXATION_TIME = 0.5; 
FIXATION_DISAPPEAR_TIME = 0.0 ; 

% show of fractals
FRACTAL_SHOW_SECONDS = 3.0;

%show of No Press
NO_PRESS_WINDOW_TIME = 1.5;

% rejection time
TA_REJECTION_WITH_REWARD_TIME = 1.5;
TA_REJECTION_WITHOUT_REWARD_TIME = 1.5;
TP_REJECTION_TIME = 1.5;

% deward delivarytime
REWARD_DELIVARY_TIME = 1.5;
%% initial uploads of data
[H_image, W_image, fractals] = upload_fractals('data', FRACTAL_NUMBERS);
value_of_fractal = give_initial_0_1_for_subject(SUBJECT_ID, FRACTAL_NUMBERS);
%% initial calculations
[p_n3, p_n5, p_n7, p_n9] = initialize_position_for_all_n(WINDOW_RECT, R, W_image, H_image);

%% Listeners
DEVICE_NUMBER = -1;
MOUSE_DEVICE = 1;


%% window start
[w_ptr, WINDOW_RECT] = Screen('OpenWindow', SCREEN_NUMBER, BG_COLOR, WINDOW_RECT);

WINDOW_CENTER = [WINDOW_RECT(3) - WINDOW_RECT(1), WINDOW_RECT(4) - WINDOW_RECT(2)]/2;



%% enterinng the main loop

rng('shuffle');


while state ~= 10
    
    
    if state == 0
        trial = 0;
        KbQueueCreate(DEVICE_NUMBER);
        next_state = 1;
    elseif state == 1
        trial = trial + 1; 

        % fixation
        Screen('DrawDots', w_ptr,WINDOW_CENTER, FIXATION_CIRCLE_RADIUS, [0, 0, 255], [], 2 );
        Screen('Flip', w_ptr);
        WaitSecs(FIXATION_TIME);
        next_state = 2;
    elseif state == 2
        % fixation dissappear 
        Screen('Flip', w_ptr);
        WaitSecs(FIXATION_DISAPPEAR_TIME);
        

        % object selection
        number_of_fractals_in_this_set = randsample(NUMBER_OF_AVALABLE_FRACTAL_SHOWS,1);

        use_value_group = randsample([0, 1], 1);
        if use_value_group
            fractals_to_select = 1 : (FRACTAL_NUMBERS/2 );
        else
            fractals_to_select = (FRACTAL_NUMBERS/2+1):(FRACTAL_NUMBERS);
        end


        to_have_high_value = randsample([0, 1], 1);
        [fractal_indexees, index_of_high_fractal] = select_fractals_for_one_set( ...
                                                    fractals_to_select, ...
                                                    value_of_fractal(fractals_to_select), ...
                                                    to_have_high_value, ...
                                                    number_of_fractals_in_this_set)
        if index_of_high_fractal ~= -1
            fractal_indexees = [fractal_indexees , index_of_high_fractal]
        end
        shuffled_indexes = randperm(length(fractal_indexees));
        fractal_indexees = fractal_indexees(shuffled_indexes);

        if number_of_fractals_in_this_set == 3
            p_n = p_n3;
        elseif number_of_fractals_in_this_set == 5
            p_n = p_n5;
        elseif number_of_fractals_in_this_set == 7
            p_n = p_n7;
        elseif number_of_fractals_in_this_set == 9
            p_n = p_n9;
        end
       

        next_state = 3;

    elseif state == 3 
        %object display
        
        for k = 1:number_of_fractals_in_this_set
            i = fractal_indexees(k);
            img = fractals(i,:,:,:);  
            img = reshape(img, [W_image, H_image, 3]); 
            my_texture = Screen('MakeTexture', w_ptr, img);
            
            Screen('DrawTexture', w_ptr, my_texture, [], p_n(:,k), 2*pi*rand());
            
            if index_of_high_fractal == i
                Screen('FrameRect', w_ptr, [255,0,0],p_n(:,k), 4);
                index_of_high_fractal_in_this_set = k;
            end
        end
        
        
        Screen('Flip', w_ptr);

        next_state = 4;


    elseif state == 4
        % wait for selection
        KbQueueFlush(DEVICE_NUMBER);
        KbQueueStart(DEVICE_NUMBER);
        
        start_time = GetSecs();
        positions = [];
        while GetSecs() - start_time < FRACTAL_SHOW_SECONDS 
            now = GetSecs();
            [x, y] = GetMouse(w_ptr, MOUSE_DEVICE);
            positions = [positions ; [now x y]];
        end
        
        KbQueueStop(DEVICE_NUMBER);
        [pressed, firstPress] = KbQueueCheck(DEVICE_NUMBER);

        [pressed_chars, mouse_position] = give_pressed_keys(firstPress, positions)


        % verification of score - ITI
        pressed
        if pressed == 0
            next_state = 5;
        elseif  strcmp(pressed_chars(1), 'x')
            if to_have_high_value
                % reject TP
                next_state = 7;
            else
                %reject TA
                next_state = 6;
            end

        else % pressed 'space'
            if give_index_of_the_selected_fractal(mouse_position,p_n) == -1
                next_state = 5;
            else
                next_state = 8;
            end
        end  

    elseif state == 5
        % NO PRESS
        Screen('DrawText', w_ptr, 'No Press', WINDOW_CENTER(1), WINDOW_CENTER(2), [255, 255, 255]);
        total_string = sprintf('total = %.2f $', total); 
        Screen('DrawText', w_ptr, total_string, WINDOW_CENTER(1), WINDOW_CENTER(2)+30, [255, 255, 255]);
        Screen('Flip', w_ptr);
        
        WaitSecs(NO_PRESS_WINDOW_TIME);

        next_state = 9;
    elseif state == 6
         % REJECT PRESS TA
        Screen('DrawText', w_ptr, 'REJECTED TA', WINDOW_CENTER(1), WINDOW_CENTER(2), [255, 255, 255]);
        total_string = sprintf('total = %.2f $', total); 
        Screen('DrawText', w_ptr, total_string, WINDOW_CENTER(1), WINDOW_CENTER(2)+30, [255, 255, 255]);
        Screen('Flip', w_ptr);

        WaitSecs(TA_REJECTION_WITHOUT_REWARD_TIME);
        next_state = 9;

    elseif state == 7
        % REJECT PRESS TP
        Screen('DrawText', w_ptr, 'REJECTED TP', WINDOW_CENTER(1), WINDOW_CENTER(2), [255, 255, 255]);
        total_string = sprintf('total = %.2f $', total); 
        Screen('DrawText', w_ptr, total_string, WINDOW_CENTER(1), WINDOW_CENTER(2)+30, [255, 255, 255]);
        Screen('Flip', w_ptr);
        
        WaitSecs(TP_REJECTION_TIME);
        next_state = 9;

    elseif state == 8
         % REWARD DELIVARY
         if give_index_of_the_selected_fractal(mouse_position,p_n) == index_of_high_fractal_in_this_set
            total = total + REWARD_AMOUNT;
            Screen('DrawText', w_ptr, 'CORRECT', WINDOW_CENTER(1), WINDOW_CENTER(2), [255, 255, 255]);
            total_string = sprintf('total = %.2f $', total); 
            Screen('DrawText', w_ptr, total_string, WINDOW_CENTER(1), WINDOW_CENTER(2)+30, [0, 255, 0]);
            Screen('Flip', w_ptr);
         else 
            Screen('DrawText', w_ptr, 'Wrong', WINDOW_CENTER(1), WINDOW_CENTER(2), [255, 0, 0]);
            total_string = sprintf('total = %.2f $', total); 
            Screen('DrawText', w_ptr, total_string, WINDOW_CENTER(1), WINDOW_CENTER(2)+30, [255, 255, 255]);
            Screen('Flip', w_ptr);

         end
         WaitSecs(REWARD_DELIVARY_TIME);
         next_state = 9;

    elseif state == 9
        if trial < TOTAL_TRIAL_NUMBER
            next_state= 1;
        else
            next_state = 10;
        end

    elseif state == 10 
        % ending
        break
    end
        




state = next_state;
end

KbQueueRelease();

KbWait();
sca();

